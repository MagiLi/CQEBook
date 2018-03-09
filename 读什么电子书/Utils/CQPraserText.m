//
//  CQPraserText.m
//  读什么电子书
//
//  Created by mac on 17/3/16.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQPraserText.h"
#import "ReadModel+CoreDataClass.h"
#import "RecorderModel+CoreDataClass.h"
#import "ChapterModel+CoreDataClass.h"
#import "CQFrameSetterParser.h"
#import <CoreText/CoreText.h>
#import "CQThemeConfig.h"

@implementation CQPraserText
#pragma mark - text处理
+ (ReadModel *)insertReadModelWithUserID:(NSNumber *)userID withBookID:(NSNumber *)bookID withBookName:(NSString *)bookName withFilePath:(NSString *)filePath {
    NSString *content = [self encodeWithFilePath:filePath];
    return [self separateWithContent:content withUserID:userID withBookID:bookID withBookName:bookName];
}

+ (NSString *)encodeWithFilePath:(NSString *)filePath {
    
    if (!filePath) return @"";
    
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
    
    NSString *content = [NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    if (!content) {
        content = [NSString stringWithContentsOfURL:fileURL encoding:0x80000632 error:nil];
    }
    if (!content) {
        content = [NSString stringWithContentsOfURL:fileURL encoding:0x80000631 error:nil];
    }
    if (!content)  return @"";
    
    return content;
}
#pragma mark -
#pragma mark - private 初始化时 解析内容
+ (ReadModel *)separateWithContent:(NSString *)content withUserID:(NSNumber *)userid withBookID:(NSNumber *)bookID withBookName:(NSString *)bookName {
    ReadModel *readModel = [NSEntityDescription insertNewObjectForEntityForName:@"ReadModel" inManagedObjectContext:[CQCoreDataTools sharedCoreDataTools].managedObjectContext];
    readModel.userID = [userid intValue];
    readModel.bookID = [bookID intValue];
    readModel.bookName = bookName;
    readModel.currentFontSize = [CQThemeConfig sharedInstance].fontSize;
    
    RecorderModel *recorderModel = [NSEntityDescription insertNewObjectForEntityForName:@"RecorderModel" inManagedObjectContext:[CQCoreDataTools sharedCoreDataTools].managedObjectContext];
    recorderModel.currentPage = 0;
    recorderModel.currentChapter = 0;
    recorderModel.recoder_read = readModel;
    
    
    NSString *parten = @"第[0-9一二三四五六七八九十百千]*[章回].*";
    NSError *error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *match = [reg matchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, [content length])];
    CGRect bounds = CGRectMake(0, 0, kScreen_W - LeftSpacing - RightSpacing, kScreen_H - Title_H - PageIndex_H);
    __block NSUInteger pageCountForAll = 0;
    if (match.count) {
        __block NSRange lastRange = NSMakeRange(0, 0);
        [match enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSRange range = [obj range];
            NSInteger local = range.location;
            if (idx == 0) {
                ChapterModel *chapterModel =  [NSEntityDescription insertNewObjectForEntityForName:@"ChapterModel" inManagedObjectContext:[CQCoreDataTools sharedCoreDataTools].managedObjectContext];
                chapterModel.title = @"开始";
                NSUInteger len = local;
                NSString *chapterContent = [content substringWithRange:NSMakeRange(0, len)];
                chapterModel.chapterContent = chapterContent;
                
                NSAttributedString *attributedStr = [self getAttributeContentWithContent:chapterContent withTitle:@"开始"];
                CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedStr);
                [self setterWithChapterModel:chapterModel withBounds:bounds withFrameSetter:frameSetter];
                CFRelease(frameSetter);
                
                
                chapterModel.currentChapter = (int)idx;
                chapterModel.chapterOffset = 0;
                chapterModel.chapter_read = readModel;
                
                pageCountForAll += chapterModel.pageCountForChapter;
            } else if (idx > 0 ) {
                ChapterModel *chapterModel =  [NSEntityDescription insertNewObjectForEntityForName:@"ChapterModel" inManagedObjectContext:[CQCoreDataTools sharedCoreDataTools].managedObjectContext];
                // 标题
                NSString *title = [content substringWithRange:lastRange];
                chapterModel.title = title;
                // 内容
                NSUInteger len = local - lastRange.location - title.length;
                NSString *chapterContent = [content substringWithRange:NSMakeRange(lastRange.location + title.length, len)];
                chapterModel.chapterContent = chapterContent;
                
                // 属性字符串
                NSAttributedString *attributedStr = [self getAttributeContentWithContent:chapterContent withTitle:title];
                CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedStr);
                [self setterWithChapterModel:chapterModel withBounds:bounds withFrameSetter:frameSetter];
                CFRelease(frameSetter);
                
                chapterModel.currentChapter = (int)idx;
                chapterModel.chapterOffset = pageCountForAll;
                chapterModel.chapter_read = readModel;
                pageCountForAll += chapterModel.pageCountForChapter;
            }
            if (idx == match.count-1) {
                ChapterModel *chapterModel =  [NSEntityDescription insertNewObjectForEntityForName:@"ChapterModel" inManagedObjectContext:[CQCoreDataTools sharedCoreDataTools].managedObjectContext];
                // 标题
                NSString *title = [content substringWithRange:range];
                chapterModel.title = title;
                // 内容
                NSInteger location = local + title.length;
                NSString *chapterContent = [content substringWithRange:NSMakeRange(location, content.length - location)];
                chapterModel.chapterContent = chapterContent;
                
                NSAttributedString *attributedStr = [self getAttributeContentWithContent:chapterContent withTitle:title];
                CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedStr);
                [self setterWithChapterModel:chapterModel withBounds:bounds withFrameSetter:frameSetter];
                CFRelease(frameSetter);
                
                chapterModel.currentChapter = (int)idx + 1;
                chapterModel.chapterOffset = pageCountForAll;
                chapterModel.chapter_read = readModel;
                
                pageCountForAll += chapterModel.pageCountForChapter;
            }
            lastRange = range;
        }];
        
        readModel.pageCountForAll = pageCountForAll;
        return readModel;
    } else {
        ChapterModel *chapterModel =  [NSEntityDescription insertNewObjectForEntityForName:@"ChapterModel" inManagedObjectContext:[CQCoreDataTools sharedCoreDataTools].managedObjectContext];
        
        chapterModel.chapterContent = content;
        
        NSAttributedString *attributedStr = [self getAttributeContentWithContent:content withTitle:@"开始"];
        
        CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedStr);
        [self setterWithChapterModel:chapterModel withBounds:bounds withFrameSetter:frameSetter];
        CFRelease(frameSetter);
        
        chapterModel.title = @"开始";
        chapterModel.currentChapter = 0;
        chapterModel.chapterOffset = pageCountForAll;
        chapterModel.chapter_read = readModel;
        
        readModel.pageCountForAll = chapterModel.pageCountForChapter;
        return readModel;
    }
}
+ (void)setterWithChapterModel:(ChapterModel *)chapterModel withBounds:(CGRect)bounds withFrameSetter:(CTFramesetterRef)frameSetter {
    
    CGPathRef path = CGPathCreateWithRect(bounds, NULL);
    NSUInteger length = chapterModel.chapterContent.length + chapterModel.title.length;
    int currentOffset = 0;// 当前页的起始位置
    NSUInteger currentPage = 0; // 当前页数
    BOOL hasMorePages = YES;
    while (hasMorePages) {
        CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentOffset, 0), path, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frameRef);
        
        currentPage++;
        if ((range.location + range.length) < length) {
            currentOffset += range.length;
        } else {
            hasMorePages = NO;
        }
        if (frameRef) CFRelease(frameRef);
    }
    CGPathRelease(path);
    chapterModel.pageCountForChapter = currentPage;
}
// 获取章节的属性字符串
+ (NSAttributedString *)getAttributeContentWithContent:(NSString *)content withTitle:(NSString *)title {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] init];
    NSAttributedString *attributeTitle = [CQFrameSetterParser parseAttributedContentWithType:NSAttributedStringTitle withContent:title];
    [attributedStr appendAttributedString:attributeTitle];
    
    NSAttributedString *attributeContent = [CQFrameSetterParser parseAttributedContentWithType:NSAttributedStringDefault withContent:content];
    [attributedStr appendAttributedString:attributeContent];
    return attributedStr;
}

@end

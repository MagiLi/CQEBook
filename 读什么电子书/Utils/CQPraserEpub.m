//
//  CQPraserEpub.m
//  读什么电子书
//
//  Created by mac on 17/3/14.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQPraserEpub.h"
#import "ZipArchive.h"
#import "CQThemeConfig.h"
#import "CQReadParser.h"
#import "ReadModel+CoreDataClass.h"
#import "RecorderModel+CoreDataClass.h"
#import "ChapterModel+CoreDataClass.h"
#import "CoverModel+CoreDataClass.h"
#import "TFHpple.h"
#import "CQFrameSetterParser.h"

@implementation CQPraserEpub
#pragma mark -
#pragma mark - ePub处理
+ (ReadModel *)insertReadModelWithUserID:(NSNumber *)userID withBookID:(NSNumber *)bookID withBookName:(NSString *)bookName withFilePath:(NSString *)filePath {
    NSString *epubPath = [self unarchiveZipFile:filePath]; // 获取解压缩后的epub文件路径
    if (!epubPath) return nil;
    NSString *opfPath = [self getOpfPath:epubPath];// opf文件路径
    ReadModel *readModel = [self parserOpf:opfPath withUserID:userID withBookID:bookID withBookName:bookName]; // 解析opf文件 并做缓存
    [[NSFileManager defaultManager] removeItemAtPath:epubPath error:NULL]; // 解析完毕后移除文件夹
    return readModel;
}

#pragma mark - 解压文件路径
+ (NSString *)unarchiveZipFile:(NSString *)filePath {
    ZipArchive *zip = [[ZipArchive alloc] init];
    NSString *zipFile = [[filePath stringByDeletingPathExtension] lastPathComponent];
    if ([zip UnzipOpenFile:filePath]) { // open zip file
        NSString *zipPath = [NSString stringWithFormat:@"%@/%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject,zipFile];
        if ([[NSFileManager defaultManager] fileExistsAtPath:zipPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:zipPath error:NULL];
        }
        if ([zip UnzipFileTo:[NSString stringWithFormat:@"%@/",zipPath] overWrite:YES]) {
            return zipPath;
        }
    }
    return nil;
}

#pragma mark - OPF文件路径
+(NSString *)getOpfPath:(NSString *)epubPath {
    NSString *containerPath = [NSString stringWithFormat:@"%@/META-INF/container.xml",epubPath];
    //container.xml文件路径 通过container.xml获取到opf文件的路径
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if ([fileManager fileExistsAtPath:containerPath]) {
        NSData *data = [NSData dataWithContentsOfFile:containerPath];
        TFHpple *hpple = [TFHpple hppleWithXMLData:data];
        NSArray *array =[hpple searchWithXPathQuery:@"//@full-path"]; //获取到为title的标题
        return [NSString stringWithFormat:@"%@/%@",epubPath,[[array firstObject] content]];
    } else {
        return nil;
    }
}
#pragma mark - 解析OPF文件
+(ReadModel *)parserOpf:(NSString *)opfPath withUserID:(NSNumber *)userid withBookID:(NSNumber *)bookID withBookName:(NSString *)bookName {
    CGRect bounds = CGRectMake(0, 0, kScreen_W - LeftSpacing - RightSpacing, kScreen_H - Title_H - PageIndex_H);
    
    ReadModel *readModel = [NSEntityDescription insertNewObjectForEntityForName:@"ReadModel" inManagedObjectContext:[CQCoreDataTools sharedCoreDataTools].managedObjectContext];
    readModel.userID = [userid intValue];
    readModel.bookID = [bookID intValue];
    readModel.bookName = bookName;
    readModel.currentFontSize = [CQThemeConfig sharedInstance].fontSize;
    
    RecorderModel *recorderModel = [NSEntityDescription insertNewObjectForEntityForName:@"RecorderModel" inManagedObjectContext:[CQCoreDataTools sharedCoreDataTools].managedObjectContext];
    recorderModel.currentPage = 0;
    recorderModel.currentChapter = 0;
    recorderModel.recoder_read = readModel;
    NSData *opfData = [NSData dataWithContentsOfFile:opfPath];
    
    NSString *absolutePath = [opfPath stringByDeletingLastPathComponent];// opf的绝对路径
    TFHpple *opfHpple = [TFHpple hppleWithData:opfData isXML:NO];
    
    
    NSArray *elementArray = [opfHpple searchWithXPathQuery:@"//reference"];

    __block NSUInteger pageCountForAll = 0;
    [elementArray enumerateObjectsUsingBlock:^(TFHppleElement *_Nonnull element, NSUInteger idx, BOOL * _Nonnull stop) {
        ChapterModel *chapterModel = [NSEntityDescription insertNewObjectForEntityForName:@"ChapterModel" inManagedObjectContext:[CQCoreDataTools sharedCoreDataTools].managedObjectContext];
        NSString *chapterPath = [NSString stringWithFormat:@"%@/%@",absolutePath,element.attributes[@"href"]];// 章节路径
        NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:chapterPath]];
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] init];
        NSString *title = element.attributes[@"title"];// 获取章节标题
        NSAttributedString *attributeTitle = [CQFrameSetterParser parseAttributedContentWithType:NSAttributedStringTitle withContent:title];
        [attributedStr appendAttributedString:attributeTitle];
        
        TFHpple *hpple = [TFHpple hppleWithHTMLData:data];
        if (idx == 0) {
            NSArray *coverArray = [hpple searchWithXPathQuery:@"//img[@class='cover']"]; // 只取封皮
            for (TFHppleElement *coverElement in coverArray) {
                UIImage *imgCover = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",absolutePath, coverElement.attributes[@"src"]]];
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@250, @"height", @170, @"width", nil];
                NSAttributedString *placeStr = [CQFrameSetterParser getPlaceholderStringWithDictionary:dict];
                [attributedStr appendAttributedString:placeStr];
                
                CoverModel *coverModel = [NSEntityDescription insertNewObjectForEntityForName:@"CoverModel" inManagedObjectContext:[CQCoreDataTools sharedCoreDataTools].managedObjectContext];
                coverModel.cover = UIImagePNGRepresentation(imgCover);
                coverModel.location = attributedStr.length - 1;
                coverModel.length = 2; // 该长度加上了换行符的长度
                coverModel.cover_chapter = chapterModel;
            }
        }
        
        NSArray *titleH1Array = [hpple searchWithXPathQuery:@"//h1"]; // 副标题
        for (TFHppleElement *titleH1Element in titleH1Array) {
            NSString *titleH1 = [NSString stringWithFormat:@"\n%@", titleH1Element.content];
            NSAttributedString *attributeTitle1 = [CQFrameSetterParser parseAttributedContentWithType:NSAttributedStringTitleH1 withContent:titleH1];
            [attributedStr appendAttributedString:attributeTitle1];
            chapterModel.titleH1 = titleH1;
        }
        
        NSArray *titleH2Array = [hpple searchWithXPathQuery:@"//h2"];
        for (TFHppleElement *titleH2Element in titleH2Array) {
            NSString *titleH2 = [NSString stringWithFormat:@"\n%@", titleH2Element.content];
            NSAttributedString *attributeTitle2 = [CQFrameSetterParser parseAttributedContentWithType:NSAttributedStringTitleH2 withContent:titleH2];
            [attributedStr appendAttributedString:attributeTitle2];
            chapterModel.titleH2 = titleH2;
        }
        
        NSArray *contentArray =[hpple searchWithXPathQuery:@"//p"];//获取正文内容
        NSMutableString *contentStr = [NSMutableString string];
        for (TFHppleElement *contentElement in contentArray) {
            [contentStr appendFormat:@"\n%@",contentElement.content];
        }
        NSAttributedString *attributeContent = [CQFrameSetterParser parseAttributedContentWithType:NSAttributedStringDefault withContent:contentStr];
        [attributedStr appendAttributedString:attributeContent];

        // 章节数据
        chapterModel.title = title;
        
        chapterModel.chapterContent = contentStr;
        CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedStr);
        [CQPraserEpub setterWithChapterModel:chapterModel withBounds:bounds withFrameSetter:frameSetter];
        CFRelease(frameSetter);
        chapterModel.currentChapter = (int)idx;
        chapterModel.chapterOffset = pageCountForAll;
        chapterModel.chapter_read = readModel;

        pageCountForAll += chapterModel.pageCountForChapter;

    }];
    readModel.pageCountForAll = pageCountForAll;
    return readModel;
}
+ (void)setterWithChapterModel:(ChapterModel *)chapterModel withBounds:(CGRect)bounds withFrameSetter:(CTFramesetterRef)frameSetter {
    
    CGPathRef path = CGPathCreateWithRect(bounds, NULL);
    NSUInteger length = chapterModel.chapter_cover.length + chapterModel.chapterContent.length + chapterModel.title.length + chapterModel.titleH1.length + chapterModel.titleH2.length;
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
@end

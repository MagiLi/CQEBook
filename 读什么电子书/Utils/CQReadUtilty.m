//
//  CQReadUtilty.m
//  读什么电子书
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQReadUtilty.h"
#import "CQReadParser.h"
#import "CQPraserEpub.h"
#import "CQPraserText.h"
#import "ReadModel+CoreDataClass.h"
#import "RecorderModel+CoreDataClass.h"
#import "ChapterModel+CoreDataClass.h"
#import "MarkModel+CoreDataClass.h"
#import "NoteModel+CoreDataClass.h"
#import "CQThemeConfig.h"
#import "CQPageModel.h"
#import "CQFrameSetterParser.h"

@implementation CQReadUtilty

#pragma mark -
#pragma mark - 查询书
+ (ReadModel *)queryReadModelWithUserID:(NSNumber *)userID withBookID:(NSNumber *)bookID {
    NSEntityDescription *bookDescription = [NSEntityDescription entityForName:@"ReadModel" inManagedObjectContext:[CQCoreDataTools sharedCoreDataTools].managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:bookDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID=%@&&bookID=%@",userID, bookID];
    [request setPredicate:predicate];
    NSArray *bookAry = [[CQCoreDataTools sharedCoreDataTools].managedObjectContext executeFetchRequest:request error:nil];
    
    if (bookAry.count) {
        ReadModel *readModel = [bookAry firstObject];
        return readModel;
    }
    return nil;
}

#pragma mark -
#pragma mark - 查询章节
+ (ChapterModel *)queryChapterModelWithReadModel:(ReadModel *)readModel withChapter:(NSInteger)chapter {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currentChapter=%d", chapter];
    NSSet *chapterSet = [readModel.read_chapter filteredSetUsingPredicate:predicate];
    if (chapterSet.count) {
        return [chapterSet anyObject];
    }
    return nil;
}
+ (ChapterModel *)queryChapterModelWithChapterSet:(NSSet <ChapterModel *>*)chapterSet withChapter:(NSInteger)chapter {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currentChapter=%d", chapter];
    NSSet *chapterModelSet = [chapterSet filteredSetUsingPredicate:predicate];
    if (chapterModelSet.count) {
        return [chapterModelSet anyObject];
    }
    return nil;
}

#pragma mark -
#pragma mark - 获取pageArray
+ (NSArray *)getPageArrayWithChapterModel:(ChapterModel *)chapterModel withFrameSetter:(CTFramesetterRef)frameSetter {
    CGRect bounds = CGRectMake(0, 0, kScreen_W - LeftSpacing - RightSpacing, kScreen_H - Title_H - PageIndex_H);
    CGPathRef path = CGPathCreateWithRect(bounds, NULL);
    
    int currentOffset = 0;// 当前页的起始位置
    NSUInteger currentPage = 0; // 当前页数
    BOOL hasMorePages = YES;
    
    NSString *placeStr = chapterModel.chapter_cover ? @"\n\n" : @"";
    NSString *titleH1 = chapterModel.titleH1.length ? chapterModel.titleH1 : @"";
    NSString *titleH2 = chapterModel.titleH2.length ? chapterModel.titleH2 : @"";
    NSString *content = [NSString stringWithFormat:@"%@%@%@%@%@", chapterModel.title, placeStr, titleH1, titleH2, chapterModel.chapterContent];
    NSUInteger length = content.length;
    NSMutableArray *arrayPage = [NSMutableArray array];
    while (hasMorePages) {
        CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentOffset, 0), path, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frameRef);
    
        CQPageModel *pageModel = [[CQPageModel alloc] init];
        pageModel.location = currentOffset;
        pageModel.currentLength = range.length;
        pageModel.currentPageForChapter = currentPage;
        pageModel.ctFrame = frameRef;
        pageModel.pageContent = [content substringWithRange:NSMakeRange(currentOffset, range.length)];
        if (currentPage == 0) {
            pageModel.coverModel = chapterModel.chapter_cover;
        }
        [arrayPage addObject:pageModel];
    
        currentPage++;
        if ((range.location + range.length) < length) {
            currentOffset += range.length;
        } else {
            hasMorePages = NO;
        }
        if (frameRef) CFRelease(frameRef);
    }
    CGPathRelease(path);
    return arrayPage;;
}
+ (NSArray *)getPageArrayWithChapterModel:(ChapterModel *)chapterModel withFrameSetter:(CTFramesetterRef)frameSetter withPage:(NSInteger *)currentPage withLocation:(NSInteger)location {
    CGRect bounds = CGRectMake(0, 0, kScreen_W - LeftSpacing - RightSpacing, kScreen_H - Title_H - PageIndex_H);
    CGPathRef path = CGPathCreateWithRect(bounds, NULL);
    
//    NSUInteger length = chapterModel.chapter_cover.length + chapterModel.chapterContent.length + chapterModel.title.length + chapterModel.titleH1.length + chapterModel.titleH2.length;
    
    int currentOffset = 0;// 当前页的起始位置
    NSUInteger page = 0; // 当前页数
    BOOL hasMorePages = YES;
    
    NSString *placeStr = chapterModel.chapter_cover ? @"\n\n" : @"";
    NSString *titleH1 = chapterModel.titleH1.length ? chapterModel.titleH1 : @"";
    NSString *titleH2 = chapterModel.titleH2.length ? chapterModel.titleH2 : @"";
    NSString *content = [NSString stringWithFormat:@"%@%@%@%@%@", chapterModel.title, placeStr, titleH1, titleH2, chapterModel.chapterContent];
    NSUInteger length = content.length;
    
    NSMutableArray *arrayPage = [NSMutableArray array];
    while (hasMorePages) {
        CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentOffset, 0), path, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frameRef);
        
        CQPageModel *pageModel = [[CQPageModel alloc] init];
        pageModel.location = currentOffset;
        pageModel.currentLength = range.length;
        pageModel.currentPageForChapter = page;
        pageModel.ctFrame = frameRef;
        pageModel.pageContent = [content substringWithRange:NSMakeRange(currentOffset, range.length)];
        if (page == 0) {
            pageModel.coverModel = chapterModel.chapter_cover;
        }
        [arrayPage addObject:pageModel];
        if ((location >= currentOffset) && (location < currentOffset + range.length)) {
            *currentPage = page;
        }

        NSMutableSet *markSet = chapterModel.chapter_mark;
        // 重新计算标签页
        [markSet enumerateObjectsUsingBlock:^(MarkModel *_Nonnull markModel, BOOL * _Nonnull stop) {
            if ((markModel.location >= currentOffset) && (markModel.location < currentOffset + range.length)) {
                markModel.currentPage = page;
            }
        }];
        
        NSMutableSet *noteSet = chapterModel.chapter_note;
        // 重新计算笔记业
        [noteSet enumerateObjectsUsingBlock:^(NoteModel *_Nonnull noteModel, BOOL * _Nonnull stop) {
            // ctFrame是否包含选中的笔记
            NSUInteger rightLocation = currentOffset + range.length;
            BOOL containLeft = noteModel.location >= currentOffset && noteModel.location < rightLocation;
            if (containLeft) {
                noteModel.currentPage = page;
            }
        }];
        page++;
        
        if ((range.location + range.length) < length) {
            currentOffset += range.length;
        } else {
            hasMorePages = NO;
        }
        if (frameRef) CFRelease(frameRef);
    }
    CGPathRelease(path);
    chapterModel.pageCountForChapter = page;
    return arrayPage;;
}


#pragma mark -
#pragma mark - 重新分页
+ (void)resetPagingWithReadModel:(ReadModel *)readModel completion:(void (^ _Nullable)(BOOL))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CGRect bounds = CGRectMake(0, 0, kScreen_W - LeftSpacing - RightSpacing, kScreen_H - Title_H - PageIndex_H);
        NSUInteger pageCountForAll = 0;
        NSInteger count = readModel.read_chapter.count;
        for (NSInteger i = 0; i < count; i++) {
            @autoreleasepool {
                ChapterModel *currentChapterModel = [CQReadUtilty queryChapterModelWithReadModel:readModel withChapter:i];
                
                NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] init];
                NSAttributedString *attributeTitle = [CQFrameSetterParser parseAttributedContentWithType:NSAttributedStringTitle withContent:currentChapterModel.title];// 标题
                [attributedStr appendAttributedString:attributeTitle];
                if (currentChapterModel.chapter_cover) {
                    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@250, @"height", @170, @"width", nil];
                    NSAttributedString *placeStr = [CQFrameSetterParser getPlaceholderStringWithDictionary:dict]; // 占位符
                    [attributedStr appendAttributedString:placeStr];
                }
                if (currentChapterModel.titleH1.length) {
                    NSAttributedString *attributeTitleH1 = [CQFrameSetterParser parseAttributedContentWithType:NSAttributedStringTitleH1 withContent:currentChapterModel.titleH1];// 副标题
                    [attributedStr appendAttributedString:attributeTitleH1];
                }
                
                if (currentChapterModel.titleH2.length) {
                    NSAttributedString *attributeTitleH2 = [CQFrameSetterParser parseAttributedContentWithType:NSAttributedStringTitleH2 withContent:currentChapterModel.titleH2];// 副标题
                    [attributedStr appendAttributedString:attributeTitleH2];
                }
                NSAttributedString *attributeContent = [CQFrameSetterParser parseAttributedContentWithType:NSAttributedStringDefault withContent:currentChapterModel.chapterContent];// 内容
                [attributedStr appendAttributedString:attributeContent];
                CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedStr);
                [CQReadUtilty resetterWithChapterModel:currentChapterModel withBounds:bounds withFrameSetter:frameSetter];
                CFRelease(frameSetter);
                
                currentChapterModel.chapterOffset = pageCountForAll;
                pageCountForAll += currentChapterModel.pageCountForChapter;
            }
           
        }
        readModel.pageCountForAll = pageCountForAll;
        readModel.currentFontSize = [CQThemeConfig sharedInstance].fontSize;
        [[CQCoreDataTools sharedCoreDataTools].managedObjectContext save:nil];
        if (completion) {
            completion(YES);
        }
    });

}
+ (void)resetterWithChapterModel:(ChapterModel *)chapterModel withBounds:(CGRect)bounds withFrameSetter:(CTFramesetterRef)frameSetter {
    
    CGPathRef path = CGPathCreateWithRect(bounds, NULL);
    
    int currentOffset = 0;// 当前页的起始位置
    NSUInteger currentPage = 0; // 当前页数
    BOOL hasMorePages = YES;
    
    NSUInteger length = chapterModel.chapter_cover.length + chapterModel.chapterContent.length + chapterModel.title.length + chapterModel.titleH1.length + chapterModel.titleH2.length;
    while (hasMorePages) {
        CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentOffset, 0), path, NULL);
        CFRange range = CTFrameGetVisibleStringRange(frameRef);
        
        NSMutableSet *markSet = chapterModel.chapter_mark;
        // 重新计算标签页
        [markSet enumerateObjectsUsingBlock:^(MarkModel *_Nonnull markModel, BOOL * _Nonnull stop) {
            if ((markModel.location >= currentOffset) && (markModel.location < currentOffset + range.length)) {
                markModel.currentPage = currentPage;
            }
        }];
        
        NSMutableSet *noteSet = chapterModel.chapter_note;
        // 重新计算笔记业
        [noteSet enumerateObjectsUsingBlock:^(NoteModel *_Nonnull noteModel, BOOL * _Nonnull stop) {
            // ctFrame是否包含选中的笔记
            NSUInteger rightLocation = currentOffset + range.length;
            BOOL containLeft = noteModel.location >= currentOffset && noteModel.location < rightLocation;
            if (containLeft) {
                noteModel.currentPage = currentPage;
            }
        }];
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





// 思考。。。
//+ (CQPageModel *)getPageModelWithCurrentOffset:(NSInteger)currentOffset currentPage:(NSInteger)currentPage withBounds:(CGRect)bounds withFrameSetter:(CTFramesetterRef)frameSetter {
//    
//    CGPathRef path = CGPathCreateWithRect(bounds, NULL);
//    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentOffset, 0), path, NULL);
//    CFRange range = CTFrameGetVisibleStringRange(frameRef);
//    CGPathRelease(path);
//    CFRelease(frameRef);
//    
//    CQPageModel *pageModel = [[CQPageModel alloc] init];
//    pageModel.location = currentOffset;
//    pageModel.currentLength = range.length;
//    pageModel.currentPageForChapter = currentPage;
//    
//    return pageModel;
//}
@end

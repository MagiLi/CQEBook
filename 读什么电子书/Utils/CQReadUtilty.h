//
//  CQReadUtilty.h
//  读什么电子书
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h> 

@class ReadModel, RecorderModel, ChapterModel, MarkModel, NoteModel, ThemeModel;

@interface CQReadUtilty : NSObject

+ (ReadModel *__nonnull)queryReadModelWithUserID:(NSNumber *__nonnull)userID withBookID:(NSNumber *__nonnull)bookID;
+ (ChapterModel *__nonnull)queryChapterModelWithReadModel:(ReadModel *__nonnull)readModel withChapter:(NSInteger)chapter;
+ (ChapterModel *__nonnull)queryChapterModelWithChapterSet:(NSSet <ChapterModel *>*__nonnull)chapterSet withChapter:(NSInteger)chapter;

// 获取pageModel
+ (NSArray *__nonnull)getPageArrayWithChapterModel:(ChapterModel *__nonnull)chapterModel withFrameSetter:(CTFramesetterRef __nonnull)frameSetter;
// 获取pageModel 需要修改当前页
+ (NSArray *__nonnull)getPageArrayWithChapterModel:(ChapterModel *__nonnull)chapterModel withFrameSetter:(CTFramesetterRef __nonnull)frameSetter withPage:(NSInteger *__nonnull)currentPage withLocation:(NSInteger)location;
// 改变字体大小重新分页时调用
+ (void)resetPagingWithReadModel:(ReadModel *__nonnull)readModel completion:(void (^ __nullable)(BOOL finished))completion;
@end

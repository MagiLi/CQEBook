//
//  ChapterModel+CoreDataProperties.h
//  读什么电子书
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ChapterModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ChapterModel (CoreDataProperties)

+ (NSFetchRequest<ChapterModel *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *chapterContent;
@property (nonatomic) int64_t chapterOffset;
@property (nonatomic) int32_t currentChapter;
@property (nonatomic) int64_t pageCountForChapter;
@property (nullable, nonatomic, copy) NSString *title;
@property (nullable, nonatomic, copy) NSString *titleH1;
@property (nullable, nonatomic, copy) NSString *titleH2;
@property (nullable, nonatomic, retain) ReadModel *chapter_read;
@property (nullable, nonatomic, retain) CoverModel *chapter_cover;
@property (nullable, nonatomic, retain) NSMutableSet<MarkModel *> *chapter_mark;
@property (nullable, nonatomic, retain) NSMutableSet<NoteModel *> *chapter_note;
@end

@interface ChapterModel (CoreDataGeneratedAccessors)

@end

NS_ASSUME_NONNULL_END

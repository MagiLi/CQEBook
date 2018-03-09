//
//  NoteModel+CoreDataProperties.h
//  读什么电子书
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "NoteModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface NoteModel (CoreDataProperties)

+ (NSFetchRequest<NoteModel *> *)fetchRequest;

@property (nonatomic) int64_t currentChapter;
@property (nonatomic) int64_t currentPage;
@property (nonatomic) int64_t length;
@property (nonatomic) int64_t location;
@property (nonatomic) int16_t type; // 笔记类型 0：笔记 1：划线
@property (nullable, nonatomic, copy) NSString *noteContent;
@property (nullable, nonatomic, copy) NSString *noteTitle;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) ReadModel *note_read;
@property (nullable, nonatomic, retain) ChapterModel *note_chapter;

@end

NS_ASSUME_NONNULL_END

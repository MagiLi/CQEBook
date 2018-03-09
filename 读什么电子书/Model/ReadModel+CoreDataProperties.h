//
//  ReadModel+CoreDataProperties.h
//  读什么电子书
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ReadModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ReadModel (CoreDataProperties)

+ (NSFetchRequest<ReadModel *> *)fetchRequest;

@property (nonatomic) int64_t bookID;
@property (nullable, nonatomic, copy) NSString *bookName;
@property (nonatomic) float currentFontSize;
@property (nullable, nonatomic, copy) NSString *fileURL;
@property (nullable, nonatomic, copy) NSData *cover;
@property (nonatomic) int64_t pageCountForAll;
@property (nonatomic) int64_t userID;
@property (nullable, nonatomic, retain) NSSet<ChapterModel *> *read_chapter;
@property (nullable, nonatomic, retain) NSMutableSet<MarkModel *> *read_mark;
@property (nullable, nonatomic, retain) NSMutableSet<NoteModel *> *read_note;
@property (nullable, nonatomic, retain) RecorderModel *read_recoder;

@end

@interface ReadModel (CoreDataGeneratedAccessors)
@end

NS_ASSUME_NONNULL_END

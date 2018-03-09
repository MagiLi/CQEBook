//
//  MarkModel+CoreDataProperties.h
//  读什么电子书
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "MarkModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MarkModel (CoreDataProperties)

+ (NSFetchRequest<MarkModel *> *)fetchRequest;

@property (nonatomic) int64_t currentChapter;
@property (nonatomic) int64_t currentPage;
@property (nonatomic) int64_t location;
@property (nullable, nonatomic, copy) NSString *markTitle;
@property (nullable, nonatomic, copy) NSString *markContent;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) ReadModel *mark_read;
@property (nullable, nonatomic, retain) ChapterModel *mark_chapter;

@end

NS_ASSUME_NONNULL_END

//
//  RecorderModel+CoreDataProperties.h
//  读什么电子书
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "RecorderModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface RecorderModel (CoreDataProperties)

+ (NSFetchRequest<RecorderModel *> *)fetchRequest;

@property (nonatomic) NSInteger currentChapter;
@property (nonatomic) NSInteger currentPage;
@property (nullable, nonatomic, retain) ReadModel *recoder_read;

@end

NS_ASSUME_NONNULL_END

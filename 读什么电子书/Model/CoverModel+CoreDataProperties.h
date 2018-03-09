//
//  CoverModel+CoreDataProperties.h
//  读什么电子书
//
//  Created by mac on 17/3/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CoverModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CoverModel (CoreDataProperties)

+ (NSFetchRequest<CoverModel *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSData *cover;
@property (nonatomic) int16_t length;
@property (nonatomic) int16_t location;
@property (nullable, nonatomic, copy) NSString *stringRect;
@property (nullable, nonatomic, copy) NSString *stringFrame;
@property (nullable, nonatomic, retain) ChapterModel *cover_chapter;

@end

NS_ASSUME_NONNULL_END

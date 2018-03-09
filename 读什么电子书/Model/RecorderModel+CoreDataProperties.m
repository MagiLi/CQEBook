//
//  RecorderModel+CoreDataProperties.m
//  读什么电子书
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "RecorderModel+CoreDataProperties.h"

@implementation RecorderModel (CoreDataProperties)

+ (NSFetchRequest<RecorderModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"RecorderModel"];
}

@dynamic currentChapter;
@dynamic currentPage;
@dynamic recoder_read;

@end

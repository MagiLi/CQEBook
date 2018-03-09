//
//  MarkModel+CoreDataProperties.m
//  读什么电子书
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "MarkModel+CoreDataProperties.h"

@implementation MarkModel (CoreDataProperties)

+ (NSFetchRequest<MarkModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MarkModel"];
}

@dynamic currentChapter;
@dynamic currentPage;
@dynamic location;
@dynamic markTitle;
@dynamic mark_read;
@dynamic mark_chapter;
@dynamic markContent;
@dynamic date;

@end

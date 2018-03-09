//
//  CoverModel+CoreDataProperties.m
//  读什么电子书
//
//  Created by mac on 17/3/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CoverModel+CoreDataProperties.h"

@implementation CoverModel (CoreDataProperties)

+ (NSFetchRequest<CoverModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CoverModel"];
}

@dynamic cover;
@dynamic length;
@dynamic location;
@dynamic stringRect;
@dynamic stringFrame;
@dynamic cover_chapter;

@end

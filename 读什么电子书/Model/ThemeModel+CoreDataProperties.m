//
//  ThemeModel+CoreDataProperties.m
//  读什么电子书
//
//  Created by mac on 17/3/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ThemeModel+CoreDataProperties.h"

@implementation ThemeModel (CoreDataProperties)

+ (NSFetchRequest<ThemeModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ThemeModel"];
}

@dynamic firstLineHeadIndent;
@dynamic fontColorTag;
@dynamic fontSize;
@dynamic kernSpace;
@dynamic lineSpace;
@dynamic themeTag;

@end

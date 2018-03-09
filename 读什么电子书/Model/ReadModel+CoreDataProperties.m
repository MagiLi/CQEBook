//
//  ReadModel+CoreDataProperties.m
//  读什么电子书
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ReadModel+CoreDataProperties.h"

@implementation ReadModel (CoreDataProperties)

+ (NSFetchRequest<ReadModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ReadModel"];
}

@dynamic bookID;
@dynamic bookName;
@dynamic currentFontSize;
@dynamic fileURL;
@dynamic cover;
@dynamic pageCountForAll;
@dynamic userID;
@dynamic read_chapter;
@dynamic read_mark;
@dynamic read_note;
@dynamic read_recoder;

@end

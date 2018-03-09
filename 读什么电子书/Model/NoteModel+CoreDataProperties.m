//
//  NoteModel+CoreDataProperties.m
//  读什么电子书
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "NoteModel+CoreDataProperties.h"

@implementation NoteModel (CoreDataProperties)

+ (NSFetchRequest<NoteModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"NoteModel"];
}

@dynamic currentChapter;
@dynamic currentPage;
@dynamic length;
@dynamic location;
@dynamic noteContent;
@dynamic noteTitle;
@dynamic note_read;
@dynamic note_chapter;
@dynamic type;
@dynamic date;
@end

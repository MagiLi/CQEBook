//
//  ChapterModel+CoreDataProperties.m
//  读什么电子书
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ChapterModel+CoreDataProperties.h"

@implementation ChapterModel (CoreDataProperties)

+ (NSFetchRequest<ChapterModel *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ChapterModel"];
}

@dynamic chapterContent;
@dynamic chapterOffset;
@dynamic currentChapter;
@dynamic pageCountForChapter;
@dynamic title;
@dynamic titleH1;
@dynamic titleH2;
@dynamic chapter_read;
@dynamic chapter_cover;
@dynamic chapter_mark;
@dynamic chapter_note;
@end

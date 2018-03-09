//
//  CQNoteCellLayout.m
//  读什么电子书
//
//  Created by mac on 17/3/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQNoteCellLayout.h"
#import "NoteModel+CoreDataClass.h"
#import "MarkModel+CoreDataClass.h"

@implementation CQNoteCellLayout

- (instancetype)initWithNoteModel:(NoteModel *)noteModel {
    self = [super init];
    if (self) {
        self.noteModel = noteModel;
        CGFloat contentH = [noteModel.noteContent boundingRectWithSize:CGSizeMake(kScreen_W - 34.0 - 35.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0]} context:nil].size.height;
        self.contentLabH = contentH > 46.0 ? 46.0 : contentH;
        
        if (noteModel.type == 0) { // 笔记
            CGFloat noteTitleH = [noteModel.noteTitle boundingRectWithSize:CGSizeMake(kScreen_W - 34.0 - 34.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11.0]} context:nil].size.height;
            self.noteTitleLabH = noteTitleH > 42.0 ? 42.0 : noteTitleH;
        } else { // 下划线
        
        }
        
        self.cellH = self.contentLabH + self.noteTitleLabH + 50.0;
    }
    return self;
}

- (instancetype)initWithMarkModel:(MarkModel *)markModel {
    self = [super init];
    if (self) {
        self.markModel = markModel;
        CGFloat contentH = [markModel.markContent boundingRectWithSize:CGSizeMake(kScreen_W - 34.0 - 35.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.0]} context:nil].size.height;
        self.contentLabH = contentH > 46.0 ? 46.0 : contentH;
        
        self.cellH = self.contentLabH + 50.0;

    }
    return self;
}

@end

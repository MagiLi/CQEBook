//
//  CQNoteCellLayout.h
//  读什么电子书
//
//  Created by mac on 17/3/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NoteModel, MarkModel;
@interface CQNoteCellLayout : NSObject
@property(nonatomic,strong)NoteModel *noteModel;
@property(nonatomic,strong)MarkModel *markModel;


@property(nonatomic,assign)CGFloat cellH;
@property(nonatomic,assign)CGFloat contentLabH;
@property(nonatomic,assign)CGFloat noteTitleLabH;

- (instancetype)initWithNoteModel:(NoteModel *)noteModel;
- (instancetype)initWithMarkModel:(MarkModel *)markModel;
@end

//
//  CQNoteModel.h
//  读什么电子书
//
//  Created by mac on 17/2/9.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    NoteTypeRect = 0,   // 笔记
    NoteTypeLine = 1,   // 划线
} NoteType;

@interface CQNoteModel : NSObject
@property(nonatomic,assign)NoteType type;           // 类型
@property(nonatomic,copy)NSString *noteContent;     // 内容
@property(nonatomic,strong)NSArray *arrayPath;      // 笔记路径
@property(nonatomic,assign)NSUInteger location;     // 笔记的起始位置
@property(nonatomic,assign)NSUInteger length;       // 笔记的长度
@property(nonatomic,assign)NSInteger currentPage;

@end

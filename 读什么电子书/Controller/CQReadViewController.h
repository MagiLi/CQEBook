//
//  CQReadViewController.h
//  读什么电子书
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "ChapterModel+CoreDataClass.h"
#import "NoteModel+CoreDataClass.h"
#import "CQPageModel.h"

@protocol CQReadViewControllerDelegate <NSObject>

- (void)addNoteContentEvent:(NoteModel *)noteModel;

@end

@interface CQReadViewController : UIViewController
@property(nonatomic,assign)NSUInteger page; // 第几页
@property(nonatomic,assign)NSUInteger chapter; // 第几张
@property(nonatomic,assign)NSUInteger pageCountForAll; // 总页数
@property(nonatomic,assign,readonly)BOOL selectedState;

@property (nonatomic,strong)ChapterModel *chapterModel;
@property(nonatomic,weak)CQPageModel *pageModel;
@property(nonatomic,weak)id<CQReadViewControllerDelegate> delegate;
@property(nonatomic,assign)BOOL markShow;
@property(nonatomic,assign)CGFloat batteryLevel;

- (void)addMark; // 添加标签
- (void)removeMark; // 移除标签
- (void)drawReadViewWithNoteModel:(NoteModel *)noteModel; // 重绘
- (void)showLabIndex; // 展示页数索引
- (void)setBatteryLevel:(CGFloat)batteryLevel;
@end

//
//  CQReadView.h
//  读什么电子书
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChapterModel+CoreDataClass.h"
#import "NoteModel+CoreDataClass.h"
#import <CoreText/CoreText.h>
#import "CQPageModel.h"


@protocol CQReadViewDelegate <NSObject>

- (void)addNoteContentBtnClicked:(NoteModel *)noteModel;

@end

@interface CQReadView : UIView
@property(nonatomic,strong)CQPageModel *pageModel;
@property(nonatomic,weak)NSMutableSet *noteModelSet;
@property(nonatomic,assign)NSUInteger chapter; // 第几张
@property(nonatomic,strong)NSArray *pathArray;

@property(nonatomic,weak)id<CQReadViewDelegate> delegate;

- (void)needDrawReadViewWithNoteModel:(NoteModel *)noteModel;
@end

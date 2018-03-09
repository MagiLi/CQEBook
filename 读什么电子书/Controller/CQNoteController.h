//
//  CQNoteController.h
//  读什么电子书
//
//  Created by mac on 17/2/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReadModel;
@protocol CQNoteControllerDelegate <NSObject>
- (void)noteDidSelectedChapter:(NSInteger)chapter page:(NSInteger)page;
@end

@interface CQNoteController : UITableViewController
@property(nonatomic,strong)ReadModel *readModel;
@property(nonatomic,weak)id<CQNoteControllerDelegate> noteDelegate;

- (void)setNoteData;
@end

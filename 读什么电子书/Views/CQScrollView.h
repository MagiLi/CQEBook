//
//  CQPageScrollView.h
//  读什么电子书
//
//  Created by mac on 17/3/27.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CQScrollViewDelegate <NSObject>

- (void)panGestureDirectionRight; // 向右滑动
- (void)panGestureDirectionLeft; // 向左滑动

@end

@interface CQScrollView : UIScrollView

@property(nonatomic,weak)id<CQScrollViewDelegate> scrollDelegate;

@end

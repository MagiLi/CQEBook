//
//  CQPageScrollView.m
//  读什么电子书
//
//  Created by mac on 17/3/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQPageScrollView.h"

@interface CQPageScrollView ()<UIGestureRecognizerDelegate>

@end

@implementation CQPageScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (self.contentOffset.x < 10.0) return YES;
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) return NO;
    return YES;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.delaysContentTouches = NO;
        self.canCancelContentTouches = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor colorWithRed:247.0 / 255.0 green:247.0 / 255.0 blue:247.0 / 255.0 alpha:1.0];
        self.pagingEnabled = YES;
    }
    return self;
}

@end

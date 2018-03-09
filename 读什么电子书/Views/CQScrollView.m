//
//  CQPageScrollView.m
//  读什么电子书
//
//  Created by mac on 17/3/27.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQScrollView.h"

@interface CQScrollView ()<UIScrollViewDelegate>

@end

@implementation CQScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
        self.scrollEnabled = YES;
        self.delegate = self;
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
//        [self addGestureRecognizer:pan];
    }
    return self;
}

@end

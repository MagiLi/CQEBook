//
//  CQBaseAnimator.m
//  CQPayedDemo
//
//  Created by 李超群 on 2018/3/8.
//  Copyright © 2018年 wwdx. All rights reserved.
//

#import "CQBaseAnimator.h"

@implementation CQBaseAnimator
#pragma mark - Override
- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    _duration = 0.35;
    return self;
}

#pragma mark - UIViewControllerInteractiveTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerInteractiveTransitioning>)transitionContext
{
    return _duration;
}

- (void)animateTransition:(nonnull id<UIViewControllerContextTransitioning>)transitionContext { 
    
}

@end

//
//  CQBaseAnimator.h
//  CQPayedDemo
//
//  Created by 李超群 on 2018/3/8.
//  Copyright © 2018年 wwdx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQBaseAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) NSTimeInterval duration;

@property (nonatomic, strong) id<UIViewControllerInteractiveTransitioning> interactiveTransitioning;

- (NSTimeInterval)transitionDuration:(id<UIViewControllerInteractiveTransitioning>)transitionContext;
@end

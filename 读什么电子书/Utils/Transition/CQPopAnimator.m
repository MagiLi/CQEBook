//
//  CQPopAnimator.m
//  CQPayedDemo
//
//  Created by 李超群 on 2018/3/8.
//  Copyright © 2018年 wwdx. All rights reserved.
//

#import "CQPopAnimator.h"

@interface CQPopAnimator ()

@end

@implementation CQPopAnimator
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    self.bigView.hidden = NO;
    // 目标控制器
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    // 源控制器
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    fromVc.view.userInteractionEnabled = NO;
    
    UIView *container = [transitionContext containerView];// 控制器栈
    [container insertSubview:toVc.view belowSubview:fromVc.view];

    CGFloat scaleY = kScreen_H / CGRectGetHeight(self.imgViewFrame);
    CGFloat scaleX = kScreen_W / CGRectGetWidth(self.imgViewFrame);
    CGFloat transformX = -CGRectGetMinX(self.imgViewFrame);
    CGFloat transformY = (kScreen_H - CGRectGetHeight(self.imgViewFrame)) * 0.5 - CGRectGetMinY(self.imgViewFrame);

    __block typeof(self) weakSelf = self;
    CATransform3D pageViewTransform = CATransform3DIdentity;
    pageViewTransform.m42 = -transformY;
    pageViewTransform.m41 = -transformX;
    [UIView animateWithDuration:OpenBookAnimationDuration animations:^{
        fromVc.view.layer.transform = CATransform3DScale(pageViewTransform, 1 / scaleX, 1 / scaleY, 1.0);
        weakSelf.imgView.layer.transform = CATransform3DIdentity;
    } completion:^(BOOL finished) {
        weakSelf.bigView.hidden = YES;
        fromVc.view.userInteractionEnabled = YES;
        [fromVc.view removeFromSuperview];
        if (transitionContext.transitionWasCancelled) { // 如果遇到未知取消操作恢复栈结构
            [container addSubview:fromVc.view];
        }
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}
@end

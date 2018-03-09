//
//  CQPushAnimator.m
//  CQPayedDemo
//
//  Created by 李超群 on 2018/3/8.
//  Copyright © 2018年 wwdx. All rights reserved.
//

#import "CQPushAnimator.h"

@interface CQPushAnimator ()

@end

@implementation CQPushAnimator

 - (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
 {
     self.bigView.hidden = NO;
     // 目标控制器
     UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
     toVc.view.layer.anchorPoint = CGPointMake(0, 0.5);
     toVc.view.frame = CGRectMake(0, 0, kScreen_W, kScreen_H);
     toVc.view.layer.masksToBounds = YES;
     // 源控制器
     UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
     fromVc.view.userInteractionEnabled = NO;
     UIView *container = [transitionContext containerView];// 控制器栈
     [container addSubview:toVc.view];// 入栈
     
     CGFloat scaleY = kScreen_H / CGRectGetHeight(self.imgViewFrame);
     CGFloat scaleX = kScreen_W / CGRectGetWidth(self.imgViewFrame);
     CGFloat transformX1 = -CGRectGetMinX(self.imgViewFrame);
     CGFloat transformY1 = (kScreen_H - CGRectGetHeight(self.imgViewFrame)) * 0.5 - CGRectGetMinY(self.imgViewFrame);
     
     CATransform3D pageViewTransform = CATransform3DIdentity;
     pageViewTransform.m42 = -transformY1;
     pageViewTransform.m41 = -transformX1;
     toVc.view.layer.transform = CATransform3DScale(pageViewTransform, 1 / scaleX, 1 / scaleY, 1.0);
     
     __block typeof(self) weakSelf = self;
     CATransform3D transform = CATransform3DIdentity;
     transform.m34 = 4.5 / 2000;
     transform.m11 = scaleX * 1.3;
     transform.m22 = scaleY * 1.2;
     transform.m42 = transformY1;
     transform.m41 = transformX1;
     [UIView animateWithDuration:OpenBookAnimationDuration animations:^{
         weakSelf.imgView.layer.transform =  CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
         toVc.view.layer.transform = CATransform3DIdentity;
     } completion:^(BOOL finished) {
         fromVc.view.userInteractionEnabled = YES;
         weakSelf.bigView.hidden = YES;
         if (transitionContext.transitionWasCancelled) {  //如果遇到未知取消操作恢复栈结构
             [toVc.view removeFromSuperview];
         }
         [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
     }];
 
 }

@end

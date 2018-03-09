//
//  CQNavigationController.m
//  CQPayedDemo
//
//  Created by 李超群 on 2018/3/8.
//  Copyright © 2018年 wwdx. All rights reserved.
//

#import "CQMainNavigationController.h"
#import "CQPushAnimator.h"
#import "CQPopAnimator.h"

@interface CQMainNavigationController ()<UINavigationControllerDelegate>
@property(nonatomic,weak)UIView *bigView;
@property(nonatomic,weak)UIImageView *imgView;
@property(nonatomic,assign)CGRect imgViewFrame;
@end

@implementation CQMainNavigationController

#pragma mark -
#pragma mark - UINavigationControllerDelegate
- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    if([animationController isKindOfClass:[CQBaseAnimator class]]) {
        return ((CQBaseAnimator *)animationController).interactiveTransitioning;
    }
    return nil;
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC
{
    if(operation == UINavigationControllerOperationPush){
        CQPushAnimator *pushAnimator = [[CQPushAnimator alloc] init];
        pushAnimator.imgViewFrame = self.imgViewFrame;
        pushAnimator.bigView = self.bigView;
        self.imgView.frame = self.imgViewFrame;
        pushAnimator.imgView = self.imgView;
        return pushAnimator;
    } else if (operation == UINavigationControllerOperationPop) {
        CQPopAnimator *popAnimator = [[CQPopAnimator alloc] init];
        popAnimator.imgViewFrame = self.imgViewFrame;
        popAnimator.bigView = self.bigView;
        self.imgView.frame = self.imgViewFrame;
        popAnimator.imgView = self.imgView;
        return popAnimator;
    }
    return nil;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated withFrame:(CGRect)imgViewFrame {
    self.imgViewFrame = imgViewFrame;
    [super pushViewController:viewController animated:animated];
}
- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated withFrame:(CGRect)imgViewFrame {
    self.imgViewFrame = imgViewFrame;
    return [super popViewControllerAnimated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_W, kScreen_H)];
    bigView.hidden = YES;
    [self.view addSubview:bigView];
    self.bigView = bigView;
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"book"];
    imgView.layer.anchorPoint = CGPointMake(0, 0.5);
    [bigView addSubview:imgView];
    self.imgView = imgView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

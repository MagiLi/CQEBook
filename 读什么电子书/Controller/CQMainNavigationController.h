//
//  CQNavigationController.h
//  CQPayedDemo
//
//  Created by 李超群 on 2018/3/8.
//  Copyright © 2018年 wwdx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CQMainNavigationController : UINavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated withFrame:(CGRect)imgViewFrame;
- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated withFrame:(CGRect)imgViewFrame;
@end

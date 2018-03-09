//
//  CQPagerViewController.h
//  读什么电子书
//
//  Created by mac on 17/2/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CQPagerViewController;

@protocol CQPagerViewControllerDataSource <NSObject>

@required
/**
 设置返回需要滑动的控制器数量
 */
-(NSInteger)numberOfViewControllers;
/**
 给每一个控制器设置一个标题
 */
-(NSString *)pagerViewController:(CQPagerViewController *)pagerViewController withTitleIndex:(NSInteger)index;
/**
 用来设置当前索引下返回的控制器
 */
-(UIViewController *)pagerViewController:(CQPagerViewController *)pagerViewController withViewControllerIndex:(NSInteger)index;
@end

@interface CQPagerViewController : UIViewController

- (void)reloadData;

@property(nonatomic,weak)id<CQPagerViewControllerDataSource> dataSource;

@property(nonatomic,strong)UIView *alphaView;
@property(nonatomic,strong)UIView *bigView;
@end

//
//  CQPagerViewController.m
//  读什么电子书
//
//  Created by mac on 17/2/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQPagerViewController.h"
#import "UIView+Shadow.h"
#import "CQTitleView.h"
#import "CQPageScrollView.h"

#define TitleView_H 36.0
#define AlphaView_W 35.0

@interface CQPagerViewController ()<CQTitleViewDelegate, UIScrollViewDelegate>
@property(nonatomic,strong)CQTitleView *titleView;
@property(nonatomic,strong)CQPageScrollView *scrollView;

@property(nonatomic,strong)NSMutableArray *arrVC;
@end

@implementation CQPagerViewController {
    NSInteger _countOfController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.bigView];
    [self.bigView addSubview:self.scrollView];
    [self.bigView addSubview:self.alphaView];
}

- (void)reloadData {
    [self.titleView removeFromSuperview];
    self.titleView = nil;
    [self.bigView addSubview:self.titleView];
    [self.bigView insertSubview:self.titleView belowSubview:self.alphaView];
    
    if ([self.dataSource respondsToSelector:@selector(numberOfViewControllers)]) {
        _countOfController = [_dataSource numberOfViewControllers];
    }
    _titleView.titleCount = _countOfController;
    _scrollView.contentSize = CGSizeMake(self.scrollView.width * _countOfController, 0);
    [self.arrVC removeAllObjects];
    
    for (int i = 0; i < _countOfController; i++) {
        if ([self.dataSource respondsToSelector:@selector(pagerViewController:withTitleIndex:)]) {
            NSString *title = [self.dataSource pagerViewController:self withTitleIndex:i];
            [self.titleView creatTitleButtonWithTitle:title withTag:i];
        }
        if ([self.dataSource respondsToSelector:@selector(pagerViewController:withViewControllerIndex:)]) {
            UIViewController *viewController = [self.dataSource pagerViewController:self withViewControllerIndex:i];
            [self.arrVC addObject:viewController];
        }
    }
    
    UIViewController *viewController = self.arrVC[0];
    viewController.view.frame = CGRectMake(0, 0, self.scrollView.width, self.scrollView.height);
    [self addChildViewController:viewController];
    [self.scrollView addSubview:viewController.view];
}
- (void)setDataSource:(id<CQPagerViewControllerDataSource>)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}
#pragma mark -
#pragma mark - CQTitleViewDelegate
- (void)titleButtonCilcked:(UIButton *)sender {
    UIViewController *viewController = self.arrVC[sender.tag];
    self.scrollView.contentOffset = CGPointMake(self.scrollView.width * sender.tag, 0);
    if (viewController.isViewLoaded) return;
    
    viewController.view.frame = CGRectMake(sender.tag * self.scrollView.width, 0, self.scrollView.width, self.scrollView.height);
    [self addChildViewController:viewController];
    [self.scrollView addSubview:viewController.view];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger tag = [self getCurrentPage:scrollView];
    [self.titleView setTitleButtonSelectedWithTag:tag];
}
- (NSInteger)getCurrentPage:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    offsetX = offsetX + (scrollView.frame.size.width * 0.5);
    return offsetX / scrollView.frame.size.width;
}

- (NSMutableArray *)arrVC {
    if (!_arrVC) {
        _arrVC = [NSMutableArray array];
    }
    return _arrVC;
}

- (CQTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[CQTitleView alloc] initWithFrame:CGRectMake(0, self.bigView.height - TitleView_H, self.scrollView.width, TitleView_H)];
        _titleView.titleViewDlegate = self;
    }
    return _titleView;
}

- (CQPageScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[CQPageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bigView.width - AlphaView_W, self.bigView.height - TitleView_H)];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIView *)bigView {
    if (!_bigView) {
        _bigView = [[UIView alloc] initWithFrame:CGRectMake(-self.view.width, 0, self.view.width, self.view.height)];
    }
    return _bigView;
}
- (UIView *)alphaView {
    if (!_alphaView) {
        _alphaView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.scrollView.frame), 0, AlphaView_W, self.view.height)];
        [_alphaView setRectShadow:2.0 andShadowColor:[UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:0.9] andShadowRadius:2.0];
    }
    return _alphaView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

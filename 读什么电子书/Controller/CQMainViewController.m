//
//  ViewController.m
//  读什么电子书
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQMainViewController.h"
#import "CQPageCurlController.h"
#import "CQPageScrollController.h"
#import "CQMainCell.h"
#import "CQReadUtilty.h"
#import "CQIndicating.h"
#import "CQThemeConfig.h"
#import "ReadModel+CoreDataClass.h"
#import "CQMainNavigationController.h"

@interface CQMainViewController ()
@property(nonatomic,assign)UIPageViewControllerTransitionStyle transitionStyle;

@end

@implementation CQMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
//    self.transitionStyle = [[NSUserDefaults standardUserDefaults] integerForKey:ReaderTransitionStyle_Key];
//    NSString *rightTitle = self.transitionStyle ? @"scroll" : @"curl";
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightTitle style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked)];
    
    [CQThemeConfig sharedInstance]; // 初始化主题配置
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)rightBarButtonItemClicked {
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"curl"]) {
        self.navigationItem.rightBarButtonItem.title = @"scroll";
        self.transitionStyle = UIPageViewControllerTransitionStyleScroll;
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:ReaderTransitionStyle_Key];
    } else {
        self.navigationItem.rightBarButtonItem.title = @"curl";
        self.transitionStyle = UIPageViewControllerTransitionStylePageCurl;
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:ReaderTransitionStyle_Key];
    }
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 12;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [CQMainCell cellWithCollectionView:collectionView withIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CQMainCell *cell = (CQMainCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    CGRect imgViewFrame = CGRectMake(cell.x, cell.y - self.collectionView.contentOffset.y, cell.width, cell.height - 21.0);
    CQPageCurlController *pageCurlVC = [[CQPageCurlController alloc] init];
    pageCurlVC.imgViewFrame = imgViewFrame;
    pageCurlVC.indexPath = indexPath;
    [(CQMainNavigationController *)self.navigationController pushViewController:pageCurlVC animated:YES withFrame:imgViewFrame];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

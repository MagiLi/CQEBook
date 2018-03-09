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
//    self.view.userInteractionEnabled = NO;
    CQMainCell *cell = (CQMainCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    if (self.transitionStyle) { // scroll模式
//        [self openScrollEBookWithCell:cell withIndexPath:indexPath];
//    } else { // curl模式
        [self openCurlEBookWithCell:cell withIndexPath:indexPath];
//    }
}
//- (void)openScrollEBookWithCell:(CQMainCell *)cell withIndexPath:(NSIndexPath *)indexPath{
//    cell.hidden = YES;
//
//    CGRect imgViewFrame = CGRectMake(cell.x, cell.y - self.collectionView.contentOffset.y, cell.width, cell.height - 21.0);
//    CGFloat scaleY = kScreen_H / CGRectGetHeight(imgViewFrame);
//    CGFloat scaleX = kScreen_W / CGRectGetWidth(imgViewFrame);
//    CGFloat transformX1 = -CGRectGetMinX(imgViewFrame);
//    CGFloat transformY1 = (kScreen_H - CGRectGetHeight(imgViewFrame)) * 0.5 - CGRectGetMinY(imgViewFrame);
//    self.imgView.hidden = NO;
//    self.imgView.frame = imgViewFrame;
//
//    CQPageScrollController *pageScrollVC = [[CQPageScrollController alloc] init];
//    pageScrollVC.transformY = transformY1;
//    pageScrollVC.transformX = transformX1;
//    pageScrollVC.scaleY = scaleY;
//    pageScrollVC.scaleX = scaleX;
//    pageScrollVC.indexPath = indexPath;
//    pageScrollVC.delegate = self;
//    pageScrollVC.view.layer.anchorPoint = CGPointMake(0, 0.5);
//    pageScrollVC.view.frame = CGRectMake(0, 0, kScreen_W, kScreen_H);
//    pageScrollVC.view.layer.masksToBounds = YES;
//
//    CATransform3D pageViewTransform = CATransform3DIdentity;
//    pageViewTransform.m42 = -transformY1;
//    pageViewTransform.m41 = -transformX1;
//    pageScrollVC.view.layer.transform = CATransform3DScale(pageViewTransform, 1 / scaleX, 1 / scaleY, 1.0);
//    [self addChildViewController:pageScrollVC];
//    [self.view addSubview:pageScrollVC.view];
//    [self statusBarHiddenEvent:YES];
//
//    __block CATransform3D transform = CATransform3DIdentity;
//    [UIView animateWithDuration:OpenBookAnimationDuration animations:^{
//        transform.m34 = 4.5 / 2000;
//        transform.m11 = scaleX * 1.3;
//        transform.m22 = scaleY * 1.2;
//        transform.m42 = transformY1;
//        transform.m41 = transformX1;
//        self.imgView.layer.transform =  CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
//        pageScrollVC.view.layer.transform = CATransform3DIdentity;
//    } completion:^(BOOL finished) {
//        self.imgView.hidden = YES;
//        cell.hidden = NO;
//        self.view.userInteractionEnabled = YES;
//    }];
//}
- (void)openCurlEBookWithCell:(CQMainCell *)cell withIndexPath:(NSIndexPath *)indexPath{
//    cell.hidden = YES;
    
    CGRect imgViewFrame = CGRectMake(cell.x, cell.y - self.collectionView.contentOffset.y, cell.width, cell.height - 21.0);
    CQPageCurlController *pageCurlVC = [[CQPageCurlController alloc] init];
//    pageCurlVC.transformY = transformY1;
//    pageCurlVC.transformX = transformX1;
//    pageCurlVC.scaleY = scaleY;
//    pageCurlVC.scaleX = scaleX;
    pageCurlVC.imgViewFrame = imgViewFrame;
    pageCurlVC.indexPath = indexPath;
    [(CQMainNavigationController *)self.navigationController pushViewController:pageCurlVC animated:YES withFrame:imgViewFrame];
}
//- (void)openCurlEBookWithCell:(CQMainCell *)cell withIndexPath:(NSIndexPath *)indexPath{
//    cell.hidden = YES;
//
//    CGRect imgViewFrame = CGRectMake(cell.x, cell.y - self.collectionView.contentOffset.y, cell.width, cell.height - 21.0);
//    CGFloat scaleY = kScreen_H / CGRectGetHeight(imgViewFrame);
//    CGFloat scaleX = kScreen_W / CGRectGetWidth(imgViewFrame);
//    CGFloat transformX1 = -CGRectGetMinX(imgViewFrame);
//    CGFloat transformY1 = (kScreen_H - CGRectGetHeight(imgViewFrame)) * 0.5 - CGRectGetMinY(imgViewFrame);
//    self.imgView.hidden = NO;
//    self.imgView.frame = imgViewFrame;
//
//    CQPageCurlController *pageCurlVC = [[CQPageCurlController alloc] init];
//    pageCurlVC.transformY = transformY1;
//    pageCurlVC.transformX = transformX1;
//    pageCurlVC.scaleY = scaleY;
//    pageCurlVC.scaleX = scaleX;
//    pageCurlVC.indexPath = indexPath;
//    pageCurlVC.delegate = self;
//    pageCurlVC.view.layer.anchorPoint = CGPointMake(0, 0.5);
//    pageCurlVC.view.frame = CGRectMake(0, 0, kScreen_W, kScreen_H);
//    pageCurlVC.view.layer.masksToBounds = YES;
//
//    CATransform3D pageViewTransform = CATransform3DIdentity;
//    pageViewTransform.m42 = -transformY1;
//    pageViewTransform.m41 = -transformX1;
//    pageCurlVC.view.layer.transform = CATransform3DScale(pageViewTransform, 1 / scaleX, 1 / scaleY, 1.0);
//    [self addChildViewController:pageCurlVC];
//    [self.view addSubview:pageCurlVC.view];
//    [self statusBarHiddenEvent:YES];
//
//    __block CATransform3D transform = CATransform3DIdentity;
//    [UIView animateWithDuration:OpenBookAnimationDuration animations:^{
//        transform.m34 = 4.5 / 2000;
//        transform.m11 = scaleX * 1.3;
//        transform.m22 = scaleY * 1.2;
//        transform.m42 = transformY1;
//        transform.m41 = transformX1;
//        self.imgView.layer.transform =  CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
//        pageCurlVC.view.layer.transform = CATransform3DIdentity;
//    } completion:^(BOOL finished) {
//        self.imgView.hidden = YES;
//        cell.hidden = NO;
//        self.view.userInteractionEnabled = YES;
//    }];
//}

- (BOOL)prefersStatusBarHidden {
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

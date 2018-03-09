//
//  CQPageViewController.h
//  读什么电子书
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQPageCurlController : UIViewController
@property (nonatomic, assign)CGRect imgViewFrame;
@property(nonatomic,assign)CGFloat transformX;
@property(nonatomic,assign)CGFloat transformY;
@property(nonatomic,assign)CGFloat scaleX;
@property(nonatomic,assign)CGFloat scaleY;
@property(nonatomic,weak)NSIndexPath *indexPath;
@end

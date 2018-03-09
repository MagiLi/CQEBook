//
//  CQPageScrollController.h
//  读什么电子书
//
//  Created by mac on 17/3/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CQPageScrollControllerDelegate <NSObject>

- (void)statusBarHiddenEvent:(BOOL)hidden;

@end
@interface CQPageScrollController : UIViewController
@property(nonatomic,assign)CGFloat transformX;
@property(nonatomic,assign)CGFloat transformY;
@property(nonatomic,assign)CGFloat scaleX;
@property(nonatomic,assign)CGFloat scaleY;
@property(nonatomic,weak)NSIndexPath *indexPath;
@property(nonatomic,weak)id<CQPageScrollControllerDelegate> delegate;
@end

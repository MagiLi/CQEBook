//
//  CQColorMenuView.h
//  读什么电子书
//
//  Created by mac on 17/3/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ColorMenuView_H 135.0

@protocol CQColorMenuViewDelegate <NSObject>

- (void)fontButtonClicked:(UIButton *)sender;

- (void)colorButtonClicked:(UIButton *)sender;

@end

@interface CQColorMenuView : UIView

@property(nonatomic,weak)id<CQColorMenuViewDelegate> delegate;

@end

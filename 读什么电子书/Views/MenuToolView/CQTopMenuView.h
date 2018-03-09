//
//  CQTopMenuView.h
//  读什么电子书
//
//  Created by mac on 17/2/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TopMenuView_H 64.0

@protocol CQTopMenuViewDelegate <NSObject>

- (void)backButtonClicked;

@end

@interface CQTopMenuView : UIView

@property(nonatomic,weak)id<CQTopMenuViewDelegate> delegate;

@property(nonatomic,copy)NSString *title;

@end

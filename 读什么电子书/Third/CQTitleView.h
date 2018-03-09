//
//  CQTitleView.h
//  读什么电子书
//
//  Created by mac on 17/2/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CQTitleViewDelegate <NSObject>

- (void)titleButtonCilcked:(UIButton *)sender;

@end

@interface CQTitleView : UIScrollView

@property(nonatomic,assign)NSInteger titleCount;
@property(nonatomic,weak)id<CQTitleViewDelegate> titleViewDlegate;

- (void)creatTitleButtonWithTitle:(NSString *)title withTag:(NSInteger)tag;
- (void)setTitleButtonSelectedWithTag:(NSInteger)tag;
@end

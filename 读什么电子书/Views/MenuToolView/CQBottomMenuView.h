//
//  CQBottomMenuView.h
//  读什么电子书
//
//  Created by mac on 17/2/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BottomMenuView_H 79.0

@protocol CQBottomMenuViewDelegate <NSObject>

- (void)chapterListButtonClicked;
- (void)changeThemeBackgroundColor;
- (void)marksButtonClicked:(UIButton *)sender;
@end

@interface CQBottomMenuView : UIView
@property(nonatomic,assign)BOOL markBtnEnble;
@property(nonatomic,weak)id<CQBottomMenuViewDelegate> delegate;
@end

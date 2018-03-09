//
//  CQReadConfig.h
//  读什么电子书
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQThemeConfig : NSObject
+(instancetype)sharedInstance;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic) NSNumber *kernSpace;
@property (nonatomic) CGFloat lineSpace;
@property(nonatomic,assign)CGFloat firstLineHeadIndent;
@property (nonatomic,strong) UIColor *fontColor;
@property (nonatomic,strong) UIColor *theme;
@property(nonatomic,assign)BOOL isNight;


- (CGFloat)getFontSizeWithTag:(NSInteger)tag;
- (NSInteger)getFontTag;
- (NSInteger)getColorTag;
@end

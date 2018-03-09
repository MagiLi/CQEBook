//
//  CQReadParser.h
//  读什么电子书
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface CQReadParser : NSObject

/*
 * 选中文字区域范围
 * return 选中区域
 */
+ (CGRect)praserRectInView:(UIView *)view atPoint:(CGPoint)point selectedRange:(NSRange *)selectedRange ctFrame:(CTFrameRef)ctFrame;
/**
 *  根据触碰点获取默认选中区域
 *  @range 选中范围
 *  @return 选中区域的集合
 *  @direction 滑动方向 (0 -- 从左侧滑动 1-- 从右侧滑动)
 */
+ (NSArray *)parserRectsInView:(UIView *)view atPoint:(CGPoint)point range:(NSRange *)selectRange ctFrame:(CTFrameRef)ctFrame paths:(NSArray *)paths direction:(BOOL) direction;

/*
 * 根据选中文字区域范围
 * return 选中绘制区域集合
 */
+ (NSArray *)praserRectsSelectedRange:(NSRange)selectedRange ctFrame:(CTFrameRef)ctFrame;
@end

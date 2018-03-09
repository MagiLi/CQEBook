//
//  CQBattery.m
//  读什么电子书
//
//  Created by mac on 17/3/21.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQBattery.h"

@interface CQBattery ()

@end

@implementation CQBattery {
    CGRect _bgRect;
    CGRect _anodeRect;
    CGRect _fillRect;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, _bgRect);
    CGContextSetLineWidth(context, 2);
    [[UIColor lightGrayColor] setStroke];
    CGContextStrokePath(context);
    
    CGContextAddRect(context, _anodeRect);
    CGContextSetLineWidth(context, 2.0);
    [[UIColor lightGrayColor] setFill];
    CGContextFillPath(context);

    CGContextAddRect(context, _fillRect);
    CGContextSetLineWidth(context, 2.0);
    [[UIColor lightGrayColor] setFill];
    CGContextFillPath(context);
    
}
- (void)setBatteryLevel:(CGFloat)batteryLevel {
    _batteryLevel = batteryLevel;
    CGFloat fillBgW = batteryLevel * CGRectGetWidth(_bgRect);
    _fillRect = CGRectMake(CGRectGetMinX(_bgRect), CGRectGetMinY(_bgRect), fillBgW, CGRectGetHeight(_bgRect));
    [self setNeedsDisplay];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        CGFloat bgH = 10.0;
        CGFloat bgW = 27.0;
        CGFloat bgX = 1.0;
        CGFloat bgY = (CGRectGetHeight(frame) - bgH) * 0.5;
        _bgRect = CGRectMake(bgX, bgY, bgW, bgH);
        CGFloat anodeW = 2.0;
        CGFloat anodeH = 3.0;
        CGFloat anodeX = CGRectGetMaxX(_bgRect) + 1.0;
        CGFloat anodeY = bgY + (bgH - anodeH) * 0.5;
        _anodeRect = CGRectMake(anodeX, anodeY, anodeW, anodeH);

    }
    return self;
}

@end

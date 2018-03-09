//
//  CQMagnifierView.m
//  Modal
//
//  Created by mac on 16/10/8.
//  Copyright © 2016年 wwdx. All rights reserved.
//

#import "CQMagnifierView.h"

@implementation CQMagnifierView

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:CGRectMake(0, 0, 80, 80)]) {
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 40;
        self.layer.masksToBounds = YES;
    }
    return self;
}
- (void)setTouchPoint:(CGPoint)touchPoint {
    
    _touchPoint = touchPoint;
    self.center = CGPointMake(touchPoint.x, touchPoint.y - 70);
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext(); // 获取图形上下文
    CGContextTranslateCTM(context, self.frame.size.width*0.5,self.frame.size.height*0.5); // 设置要展示 哪个位置 的 内容
    CGContextScaleCTM(context, 1.5, 1.5); // 设置放大倍数
    CGContextTranslateCTM(context, -1 * (_touchPoint.x), -1 * (_touchPoint.y)); // 翻转坐标
    [self.displayView.layer renderInContext:context]; // 绘制图像
}


@end

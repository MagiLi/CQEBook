//
//  UIView+Shadow.m
//  ReadWhats
//
//  Created by mac on 16/4/15.
//  Copyright © 2016年 高永强. All rights reserved.
//

#import "UIView+Shadow.h"

@implementation UIView (Shadow)

- (void)setRectShadow:(CGFloat)addWH andShadowColor:(UIColor *)color andShadowRadius:(CGFloat)radius {

    self.layer.shadowColor = color.CGColor;//shadowColor阴影颜色
    self.layer.shadowOffset = CGSizeMake(0,0);//shadowOffset阴影偏移，默认(0, -3),这个跟shadowRadius配合使用
    self.layer.shadowOpacity = 1;//阴影透明度，默认0
    self.layer.shadowRadius = radius;//阴影半径，默认3
    
    //路径阴影
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    float x = self.bounds.origin.x;
    float y = self.bounds.origin.y;
    
    CGPoint topLeft = CGPointMake(x - addWH,y-addWH);
    CGPoint topMiddle = CGPointMake(x+5.0,y-addWH);
    CGPoint topRight = CGPointMake(x+width + addWH,y - addWH);
    
    CGPoint rightMiddle = CGPointMake(x+width+addWH,y+(height/2));
    
    CGPoint bottomRight = CGPointMake(x+width + addWH,y+height + addWH);
    CGPoint bottomMiddle = CGPointMake(x+(width/2),y+height+addWH);
    CGPoint bottomLeft = CGPointMake(x - addWH,y+height + addWH);
    
    
    CGPoint leftMiddle = CGPointMake(x-addWH,y+(height/2));
    
    [path moveToPoint:topLeft];
    //添加四个二元曲线
    [path addQuadCurveToPoint:topRight
                 controlPoint:topMiddle];
    [path addQuadCurveToPoint:bottomRight
                 controlPoint:rightMiddle];
    [path addQuadCurveToPoint:bottomLeft
                 controlPoint:bottomMiddle];
    [path addQuadCurveToPoint:topLeft
                 controlPoint:leftMiddle];
    //设置阴影路径
    self.layer.shadowPath = path.CGPath;
}

@end

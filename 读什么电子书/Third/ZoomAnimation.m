//
//  ZoomAnimation.m
//  ReadWhats
//
//  Created by 高永强 on 16/7/7.
//  Copyright © 2016年 高永强. All rights reserved.
//

#import "ZoomAnimation.h"

@interface ZoomAnimation ()

@property (nonatomic ,weak)UIView *bigView;

@property (nonatomic ,weak)UIView *smallView;

@end

@implementation ZoomAnimation

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:247.0 / 255.0 green:247.0 / 255.0 blue:247.0 / 255.0 alpha:1.0];
        
        UIView *bigVIew = [[UIView alloc]initWithFrame:CGRectMake((frame.size.width - 16) / 2, (frame.size.height - 16) / 2, 16, 16)];

        bigVIew.backgroundColor = [UIColor colorWithRed:87.0 / 255.0 green:173.0 / 255.0 blue:104.0 / 255.0 alpha:1.0];
        
        bigVIew.alpha = 0.5;
        
        bigVIew.layer.cornerRadius = 8;
        
        [self addSubview:bigVIew];
        
        self.bigView = bigVIew;
        
        UIView *smallView = [[UIView alloc]initWithFrame:self.bigView.frame];
        
        smallView.backgroundColor = [UIColor colorWithRed:87.0 / 255.0 green:173.0 / 255.0 blue:104.0 / 255.0 alpha:1.0];
        
        smallView.layer.cornerRadius = 8;
        
        [self addSubview:smallView];
        
        self.smallView = smallView;
    }
    
    return self;
}

- (void)startAnimation {
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = 1.2f;
    
    animation.repeatCount = MAXFLOAT;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.8, 1.8, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    
    [self.bigView.layer addAnimation:animation forKey:nil];
    
    [values replaceObjectAtIndex:1 withObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1.0)]];
    
    animation.values = values;
    
    [self.smallView.layer addAnimation:animation forKey:nil];
}

@end

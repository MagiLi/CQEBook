//
//  CQIndicating.m
//  读什么电子书
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQIndicating.h"

@interface CQIndicating ()
@property (nonatomic, strong) NSMutableSet *waitingIndicatorKeys;
@property (nonatomic, strong) UIControl *controlWaiting;
@end

@implementation CQIndicating
{
    UILabel *_lab;
}

+ (instancetype)sharedInstance
{
    static CQIndicating *indicating = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        indicating = [[CQIndicating alloc] init];
    });
    
    return indicating;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        /// 初始化
        
        self.waitingIndicatorKeys = [NSMutableSet setWithCapacity:20];
        {
            self.controlWaiting = [[UIControl alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
            [self.controlWaiting setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
            [self.controlWaiting setBackgroundColor:[UIColor clearColor]];
            
            UIView *viewFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 82)];
            [viewFrame setBackgroundColor:[UIColor colorWithWhite:0.f alpha:.8f]];
            [viewFrame.layer setMasksToBounds:YES];
            [viewFrame.layer setCornerRadius:3.f];
            [viewFrame setCenter:CGPointMake(self.controlWaiting.bounds.size.width/2, self.controlWaiting.bounds.size.height/2)];
            [viewFrame setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin];
            [self.controlWaiting addSubview:viewFrame];
            
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [indicator startAnimating];
            [indicator setCenter:CGPointMake(viewFrame.bounds.size.width/2, viewFrame.bounds.size.height/2 - 10)];
            [indicator setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin];
            [viewFrame addSubview:indicator];
            
            _lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 130, 32)];
            _lab.textAlignment = NSTextAlignmentCenter;
            _lab.font = [UIFont systemFontOfSize:12];
            _lab.textColor = [UIColor whiteColor];
            
            [viewFrame addSubview:_lab];
            
            [indicator setHidesWhenStopped:NO];
        }
    }
    
    return self;
}


- (void)setWaitingIndicatorShown:(BOOL)aShown withKey:(NSString *)aKey withText:(NSString *)text
{
    
    if (!aKey) {
        return;
    }
    
    if (aShown) {
        [self.waitingIndicatorKeys addObject:aKey];
    } else {
        [self.waitingIndicatorKeys removeObject:aKey];
    }
    
    if (self.waitingIndicatorKeys.count > 0) {
        
        _lab.text = text;
        
        [self.controlWaiting setFrame:[UIApplication sharedApplication].keyWindow.bounds];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.controlWaiting];
    } else {
        
        [self.controlWaiting removeFromSuperview];
    }
}
@end

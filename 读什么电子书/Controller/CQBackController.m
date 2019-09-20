//
//  CQBackController.m
//  读什么电子书
//
//  Created by 李超群 on 2019/9/20.
//  Copyright © 2019 mac. All rights reserved.
//

#import "CQBackController.h"
#import "CQThemeConfig.h"

@interface CQBackController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *backgroundImage;

- (UIImage *)captureView:(UIView *)view;
@end

@implementation CQBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.imageView];
    if ([CQThemeConfig sharedInstance].isNight) {
        self.view.backgroundColor = [UIColor blackColor];
    } else {
        self.view.backgroundColor = [CQThemeConfig sharedInstance].theme;
    }
    [_imageView setImage:_backgroundImage];
    [_imageView setAlpha:0.5];
}

- (void)updateWithViewController:(UIViewController *)viewController {
    self.backgroundImage = [self captureView:viewController.view];
}

- (UIImage *)captureView:(UIView *)view {
    CGRect rect = view.bounds;
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGAffineTransform transform = CGAffineTransformMake(-1.0, 0.0, 0.0, 1.0, rect.size.width, 0.0);
    CGContextConcatCTM(context,transform);
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

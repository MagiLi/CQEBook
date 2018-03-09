
#import <UIKit/UIKit.h>

@interface UIImage (CQExtern)

- (UIImage *)applyLightEffect;
- (UIImage *)applyExtraLightEffect;
- (UIImage *)applyDarkEffect;
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

// 绘制图片
- (UIImage *)creatRadiusImage:(CGSize)size strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor;
@end

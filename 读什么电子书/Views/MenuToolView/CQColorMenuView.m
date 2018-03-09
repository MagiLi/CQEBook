//
//  CQColorMenuView.m
//  读什么电子书
//
//  Created by mac on 17/3/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQColorMenuView.h"
#import "CQThemeConfig.h"

#define marginTop 25.0
#define marginLeft 13.0
#define btnH 33.0

@interface CQColorMenuView ()
@property(nonatomic,strong)UILabel *fontLab;
@property(nonatomic,strong)UILabel *themeLab;

@property(nonatomic,strong)NSArray *arrayFont;
@property(nonatomic,strong)NSArray *arrayColorTitle;
@property(nonatomic,strong)NSArray *arrayColor;

@property(nonatomic,weak)UIButton *selFontBtn;
@property(nonatomic,weak)UIButton *selColorBtn;
@end

@implementation CQColorMenuView {
    NSInteger _fontTag;
    NSInteger _colorTag;
    
    CGFloat _marginLabLeft;
    CGFloat _lableW;
}
- (void)fontBtnClicked:(UIButton *)sender {
    if (sender.selected) return;
    self.selFontBtn.layer.borderColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0].CGColor;
    self.selFontBtn.selected = NO;
    sender.selected = YES;
    self.selFontBtn = sender;
    sender.layer.borderColor = [UIColor colorWithRed:83.0 / 255.0 green:173.0 / 255.0 blue:101.0 / 255.0 alpha:1.0].CGColor;
    if ([self.delegate respondsToSelector:@selector(fontButtonClicked:)]) {
        [self.delegate fontButtonClicked:sender];
    }
}

- (void)colorBtnClicked:(UIButton *)sender {
    if ([CQThemeConfig sharedInstance].isNight) { // 夜间
        if (!sender.selected) {
            self.selColorBtn.layer.borderColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0].CGColor;
            self.selColorBtn.selected = NO;
            sender.selected = YES;
            self.selColorBtn = sender;
            sender.layer.borderColor = [UIColor colorWithRed:83.0 / 255.0 green:173.0 / 255.0 blue:101.0 / 255.0 alpha:1.0].CGColor;
        }
        if ([self.delegate respondsToSelector:@selector(colorButtonClicked:)]) {
            [self.delegate colorButtonClicked:sender];
        }
    } else { // 白天
        if (sender.selected) return;
        self.selColorBtn.layer.borderColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0].CGColor;
        self.selColorBtn.selected = NO;
        sender.selected = YES;
        self.selColorBtn = sender;
        sender.layer.borderColor = [UIColor colorWithRed:83.0 / 255.0 green:173.0 / 255.0 blue:101.0 / 255.0 alpha:1.0].CGColor;
        if ([self.delegate respondsToSelector:@selector(colorButtonClicked:)]) {
            [self.delegate colorButtonClicked:sender];
        }
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setData];
        [self setupSubView];
    }
    return self;
}

- (void)setData {
    _marginLabLeft = 13.0;
    _lableW = 45.0;
    _fontTag = [[CQThemeConfig sharedInstance] getFontTag];
    _colorTag = [[CQThemeConfig sharedInstance] getColorTag];
}

- (void)setupSubView {
    self.backgroundColor = [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:0.9];
    [self addSubview:self.fontLab];
    
    CGFloat fontCount = self.arrayFont.count;
    CGFloat fontBtnW = 80.0;
    CGFloat fontBtnMargin = (kScreen_W - fontBtnW * fontCount - _marginLabLeft - _lableW - 36.0) / (fontCount - 1.0);
    for (NSInteger j = 0; j < fontCount; j++) {
        CGFloat fontBtnX = _marginLabLeft + _lableW + (fontBtnMargin + fontBtnW) * j;
        UIButton *fontBtn = [[UIButton alloc] initWithFrame:CGRectMake(fontBtnX, marginTop, fontBtnW, btnH)];
        fontBtn.tag = j;
        [fontBtn setTitle:self.arrayFont[j] forState:UIControlStateNormal];
        [fontBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [fontBtn setTitleColor:[UIColor colorWithRed:83.0 / 255.0 green:173.0 / 255.0 blue:101.0 / 255.0 alpha:1.0] forState:UIControlStateSelected];
        [fontBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [fontBtn addTarget:self action:@selector(fontBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [fontBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        fontBtn.layer.cornerRadius = 5.0;
        fontBtn.layer.borderWidth = 1.0;
        fontBtn.layer.borderColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0].CGColor;
        if (j == _fontTag) {
            fontBtn.selected = YES;
            self.selFontBtn = fontBtn;
            fontBtn.layer.borderColor = [UIColor colorWithRed:83.0 / 255.0 green:173.0 / 255.0 blue:101.0 / 255.0 alpha:1.0].CGColor;
        }
        [self addSubview:fontBtn];
    }
    
    
    [self addSubview:self.themeLab];
    
    CGFloat colorCount = self.arrayColorTitle.count;
    CGFloat colorBtnW = 80.0;
    CGFloat colorBtnMargin = (kScreen_W - colorBtnW * colorCount - _marginLabLeft - _lableW - 36.0) / (colorCount - 1.0);
    CGFloat colorBtnY = CGRectGetMaxY(self.fontLab.frame) + 20.0;
    for (NSInteger i = 0; i < colorCount; i++) {
        CGFloat colorBtnX = _marginLabLeft + _lableW + (colorBtnMargin + fontBtnW) * i;
        UIButton *colorBtn = [[UIButton alloc] initWithFrame:CGRectMake(colorBtnX, colorBtnY, colorBtnW, btnH)];
        colorBtn.tag = i;
        
        [colorBtn setTitle:self.arrayColorTitle[i] forState:UIControlStateNormal];
        [colorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [colorBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        [colorBtn addTarget:self action:@selector(colorBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [colorBtn.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
        colorBtn.backgroundColor = self.arrayColor[i];
        colorBtn.layer.cornerRadius = 5.0;
        colorBtn.layer.borderWidth = 1.0;
        colorBtn.layer.borderColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0].CGColor;
        if (i == _colorTag) {
            colorBtn.selected = YES;
            self.selColorBtn = colorBtn;
            colorBtn.layer.borderColor = [UIColor colorWithRed:83.0 / 255.0 green:173.0 / 255.0 blue:101.0 / 255.0 alpha:1.0].CGColor;
        }
        [self addSubview:colorBtn];
    }

}

- (UILabel *)fontLab {
    if (!_fontLab) {
        _fontLab = [[UILabel alloc] initWithFrame:CGRectMake(_marginLabLeft, marginTop, _lableW, btnH)];
        _fontLab.text = @"字号";
        _fontLab.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
        _fontLab.font = [UIFont systemFontOfSize:15.0];
    }
    return _fontLab;
}
- (UILabel *)themeLab {
    if (!_themeLab) {
        _themeLab = [[UILabel alloc] initWithFrame:CGRectMake(_marginLabLeft, CGRectGetMaxY(_fontLab.frame) + 20.0, _lableW, btnH)];
        _themeLab.text = @"主题";
        _themeLab.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0];
        _themeLab.font = [UIFont systemFontOfSize:15.0];

    }
    return _themeLab;
}
- (NSArray *)arrayFont {
    if (!_arrayFont) {
        _arrayFont = @[@"小", @"中", @"大"];
    }
    return _arrayFont;
}
- (NSArray *)arrayColorTitle {
    if (!_arrayColorTitle) {
        _arrayColorTitle = @[@"白色", @"黄色", @"护眼"];
    }
    return _arrayColorTitle;
}
- (NSArray *)arrayColor {
    if (!_arrayColor) {
        _arrayColor = @[[UIColor colorWithRed:238.0 / 255.0 green:238.0 / 255.0 blue:238.0 / 255.0 alpha:1.0], [UIColor colorWithRed:246.0 / 255.0 green:239.0 / 255.0 blue:220.0 / 255.0 alpha:1.0], [UIColor colorWithRed:133.0 / 255.0 green:155.0 / 255.0 blue:134.0 / 255.0 alpha:1.0]];
    }
    return _arrayColor;
}
@end

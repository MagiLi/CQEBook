//
//  CQTitleView.m
//  读什么电子书
//
//  Created by mac on 17/2/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQTitleView.h"

#define Line_H 1.0

@interface CQTitleView ()
@property(nonatomic,weak)UIView *line;
@property(nonatomic,weak)UIView *bgLine;
@property(nonatomic,weak)UIButton *selectedBtn;
@end

@implementation CQTitleView {
    CGFloat _titleW;
    CGFloat _titleH;
    CGFloat _marginL;
    CGFloat _lineW;
}

- (void)setTitleButtonSelectedWithTag:(NSInteger)tag {

    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            if (view.tag == tag) {
                [self titleBtnClicked:(UIButton *)view];
                break;
            }
        }
    }
    
}

- (void)titleBtnClicked:(UIButton *)sender {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.line.x = sender.tag * _titleW + _marginL + (_titleW - _lineW) *0.5;
    } completion:^(BOOL finished) {
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
    }];
    
    if ([self.titleViewDlegate respondsToSelector:@selector(titleButtonCilcked:)]) {
        [self.titleViewDlegate titleButtonCilcked:sender];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        
        CGFloat scale = kScreen_W / 320.0;
        _titleW = 42.0 * scale;
        _titleH = self.height - Line_H;
        _lineW = scale * 31.0;
        [self addLines];
    }
    return self;
}
- (void)creatTitleButtonWithTitle:(NSString *)title withTag:(NSInteger)tag {
    UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(tag * _titleW + _marginL, Line_H, _titleW, _titleH)];
    [titleBtn setTitle:title forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor colorWithRed:83.0 / 255.0 green:173.0 / 255.0 blue:101.0 / 255.0 alpha:1.0] forState:UIControlStateSelected];
    [titleBtn addTarget:self action:@selector(titleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [titleBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    titleBtn.tag = tag;
    if (tag == 0) {
        titleBtn.selected = YES;
        self.selectedBtn = titleBtn;
    }
    [self addSubview:titleBtn];
}
- (void)setTitleCount:(NSInteger)titleCount {
    _titleCount = titleCount;
    self.contentSize = CGSizeMake(titleCount * _titleW, 0);
    _marginL = (self.width - _titleW * _titleCount) * 0.5;
    self.line.x = _marginL + (_titleW - _lineW) *0.5;
}

- (void)addLines {
    UIView *bgLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, Line_H)];
    bgLine.backgroundColor = [UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1.0];
    [self addSubview:bgLine];
    self.bgLine = bgLine;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _lineW, Line_H + 1.0)];
    line.backgroundColor = [UIColor colorWithRed:83.0 / 255.0 green:173.0 / 255.0 blue:101.0 / 255.0 alpha:1.0];
    [self addSubview:line];
    self.line = line;

}

@end

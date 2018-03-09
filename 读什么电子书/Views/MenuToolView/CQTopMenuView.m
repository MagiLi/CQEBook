//
//  CQTopMenuView.m
//  读什么电子书
//
//  Created by mac on 17/2/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQTopMenuView.h"

@interface CQTopMenuView ()
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIButton *shareBtn;
@property(nonatomic,strong)UILabel *titleLab;

@end

@implementation CQTopMenuView
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLab.text = title;
}
- (void)backBtnClicked {
    if ([self.delegate respondsToSelector:@selector(backButtonClicked)]) {
        [self.delegate backButtonClicked];
    }
}
- (void)shareBtnClicked:(UIButton *)sender {
//    if ([self.delegate respondsToSelector:@selector(marksButtonClicked:)]) {
//        [self.delegate marksButtonClicked:sender];
//    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:0.9];
        [self addChildrenViews];
    }
    return self;
}
- (void)addChildrenViews {
    [self addSubview:self.backBtn];
    [self addSubview:self.shareBtn];
    [self addSubview:self.titleLab];
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20.0, 50.0, TopMenuView_H-20.0)];
        [_backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:[UIImage imageNamed:@"backImage"] forState:UIControlStateNormal];
    }
    return _backBtn;
}
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 50.0, 20.0, 50.0, TopMenuView_H-20.0)];
        [_shareBtn setImage:[UIImage imageNamed:@"shareEbook"] forState:UIControlStateNormal];
        [_shareBtn setTintColor:[UIColor whiteColor]];
        [_shareBtn addTarget:self action:@selector(shareBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 20.0, self.width - 100.0, TopMenuView_H-20.0)];
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:18.0];
        _titleLab.textColor = [UIColor whiteColor];
    }
    return _titleLab;
}
@end

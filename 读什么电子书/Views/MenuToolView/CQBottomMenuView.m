//
//  CQBottomMenuView.m
//  读什么电子书
//
//  Created by mac on 17/2/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQBottomMenuView.h"

#define btn_W 50.0
#define btn_H 50.0

@interface CQBottomMenuView ()
@property(nonatomic,strong)UIButton *chapterListBtn;
@property(nonatomic,strong)UIButton *fontBtn;
@property(nonatomic,strong)UIButton *markBtn;
@end

@implementation CQBottomMenuView {
    CGFloat _btnY;
}

- (void)chapterListBtnClicked {
    if ([self.delegate respondsToSelector:@selector(chapterListButtonClicked)]) {
        [self.delegate chapterListButtonClicked];
    }
}

- (void)fontButtonClicked {
    if ([self.delegate respondsToSelector:@selector(changeThemeBackgroundColor)]) {
        [self.delegate changeThemeBackgroundColor];
    }

}

- (void)markBtnClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(marksButtonClicked:)]) {
        [self.delegate marksButtonClicked:sender];
    }
}
- (void)setMarkBtnEnble:(BOOL)markBtnEnble {
    _markBtnEnble = markBtnEnble;
    self.markBtn.enabled = markBtnEnble;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:0.9]];
        _btnY = (self.height - btn_H) * 0.5;
        [self addChildrenViews];
    }
    return self;
}
- (void)addChildrenViews {
    [self addSubview:self.chapterListBtn];
    [self addSubview:self.fontBtn];
    [self addSubview:self.markBtn];
}

- (UIButton *)chapterListBtn {
    if (!_chapterListBtn) {
        _chapterListBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _btnY, btn_W, btn_H)];
        [_chapterListBtn setImage:[UIImage imageNamed:@"reader_cover"] forState:UIControlStateNormal];
        [_chapterListBtn addTarget:self action:@selector(chapterListBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chapterListBtn;
}
- (UIButton *)fontBtn {
    if (!_fontBtn) {
        _fontBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.width - btn_W) * 0.5, _btnY, btn_W, btn_H)];
        [_fontBtn setTitle:@"Aa" forState:UIControlStateNormal];
        [_fontBtn.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
        [_fontBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_fontBtn addTarget:self action:@selector(fontButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fontBtn;
}
- (UIButton *)markBtn {
    if (!_markBtn) {
        _markBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - btn_W, _btnY, btn_W, btn_H)];
        [_markBtn setImage:[UIImage imageNamed:@"marks_yellow"] forState:UIControlStateNormal];
        [_markBtn setTintColor:[UIColor whiteColor]];
        [_markBtn addTarget:self action:@selector(markBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _markBtn;
}
@end

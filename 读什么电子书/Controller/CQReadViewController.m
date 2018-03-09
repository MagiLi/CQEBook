//
//  CQReadViewController.m
//  读什么电子书
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQReadViewController.h"
#import "CQReadView.h"
#import "CQReadParser.h"
#import "CQPageModel.h"
#import "CQThemeConfig.h"
#import "MarkModel+CoreDataClass.h"
#import "ThemeModel+CoreDataClass.h"
#import "CQBattery.h"


@interface CQReadViewController ()<CQReadViewDelegate>

@property(nonatomic,strong)CQReadView *readView;
@property(nonatomic,strong)CQBattery *battery;
@property(nonatomic,strong)UILabel *dateLb;
@property(nonatomic,strong)UILabel *labIndex;
@property(nonatomic,strong)UILabel *labTitle;
@property(nonatomic,strong)UIImageView *markImgView;
@end

@implementation CQReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([CQThemeConfig sharedInstance].isNight) {
        self.view.backgroundColor = [UIColor blackColor];
        self.readView.backgroundColor = [UIColor blackColor];
    } else {
        self.view.backgroundColor = [CQThemeConfig sharedInstance].theme;
        self.readView.backgroundColor = [CQThemeConfig sharedInstance].theme;
    }
    [self.view addSubview:self.readView];
    [self.view addSubview:self.labIndex];
    [self.view addSubview:self.battery];
    [self.view addSubview:self.labTitle];
    self.labIndex.hidden = !self.pageCountForAll;
    [self getMarkData];
}
- (void)getMarkData {
    NSMutableSet *markSet = self.chapterModel.chapter_mark;
    if (markSet.count) {
        for (MarkModel *markModel in markSet) {
            if (markModel.currentPage == _page) {
                [self addMark];
            }
        }
    }
}

- (void)addNoteContentBtnClicked:(NoteModel *)noteModel {
    if ([self.delegate respondsToSelector:@selector(addNoteContentEvent:)]) {
        [self.delegate addNoteContentEvent:noteModel];
    }
}
- (void)addMark {
    self.markShow = YES;
    [self.view addSubview:self.markImgView];
}
- (void)removeMark {
    [self.markImgView removeFromSuperview];
    self.markImgView = nil;
}

- (void)drawReadViewWithNoteModel:(NoteModel *)noteModel {

    [self.readView needDrawReadViewWithNoteModel:noteModel];
}
- (void)showLabIndex {
    _labIndex.hidden = NO;
    _labIndex.text = [NSString stringWithFormat:@"%zd / %zd", _chapterModel.chapterOffset + _page + 1, self.pageCountForAll];
}
- (BOOL)selectedState {
    return self.readView.pathArray.count;
}

- (void)setBatteryLevel:(CGFloat)batteryLevel {
    _batteryLevel = batteryLevel;
    self.battery.batteryLevel = batteryLevel;
}
- (CQReadView *)readView {
    if (!_readView) {
        CGFloat readViewH = kScreen_H - Title_H - PageIndex_H;
        CGRect frame = CGRectMake(0, Title_H, kScreen_W, readViewH);
        _readView = [[CQReadView alloc] initWithFrame:frame];
        _readView.pageModel = self.pageModel;
        _readView.chapter = _chapter;
        _readView.noteModelSet = self.chapterModel.chapter_note;
        _readView.delegate = self;
    }
    return _readView;
}

- (UILabel *)labIndex {
    if (!_labIndex) {
        _labIndex = [[UILabel alloc] initWithFrame:CGRectMake(LeftSpacing, kScreen_H - PageIndex_H, 100, PageIndex_H)];
        _labIndex.text = [NSString stringWithFormat:@"%zd / %zd", _chapterModel.chapterOffset + _page + 1, self.pageCountForAll];
        _labIndex.font = [UIFont systemFontOfSize:12];
        _labIndex.textColor = [UIColor lightGrayColor];
    }
    return _labIndex;
}
- (UILabel *)labTitle {
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] initWithFrame:CGRectMake(LeftSpacing, 0, kScreen_W - LeftSpacing*2.0, Title_H)];
        _labTitle.text = [_chapterModel title];
        _labTitle.font = [UIFont systemFontOfSize:12];
        _labTitle.textColor = [UIColor lightGrayColor];
    }
    return _labTitle;
}
- (UIImageView *)markImgView {
    if (!_markImgView) {
        _markImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - 50.0, .0, 50.0, Title_H)];
        [_markImgView setImage:[UIImage imageNamed:@"marks_yellow"]];
        _markImgView.contentMode = UIViewContentModeCenter;
        _markImgView.tintColor = [UIColor orangeColor];
    }
    return _markImgView;
}
- (CQBattery *)battery {
    if (!_battery) {
        _battery = [[CQBattery alloc] initWithFrame:CGRectMake(kScreen_W - 50.0, kScreen_H - PageIndex_H, 50.0, PageIndex_H)];
        _battery.batteryLevel = self.batteryLevel;
    }
    return _battery;
}

- (UILabel *)dateLb {
    if (!_dateLb) {
        _dateLb = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_W - 100.0, kScreen_H - PageIndex_H, 50.0, PageIndex_H)];
    }
    return _dateLb;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    NSLog(@"------------");
}

@end

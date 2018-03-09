//
//  CQNoteHeadFooterView.m
//  读什么电子书
//
//  Created by mac on 17/3/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQNoteHeadFooterView.h"
#import "ChapterModel+CoreDataClass.h"
#import "MarkModel+CoreDataClass.h"

@interface CQNoteHeadFooterView ()
@property(nonatomic,strong)UILabel *titleLab;

@end

@implementation CQNoteHeadFooterView

+ (CQNoteHeadFooterView *)headFooterViewWithTableView:(UITableView *)tableView withSection:(NSInteger)section withChapterModel:(ChapterModel *)chapterModel {
    CQNoteHeadFooterView *headFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:noteHeadFootCellID];
    headFooterView.titleLab.text = [NSString stringWithFormat:@"%zd.%@", chapterModel.currentChapter, chapterModel.title];
    return headFooterView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLab.frame = CGRectMake(17.0, 0, self.width - 34.0, self.height);
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:247.0 / 255.0 green:247.0 / 255.0 blue:247.0 / 255.0 alpha:1.0];
        [self.contentView addSubview:self.titleLab];
    }
    return self;
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0];
        _titleLab.font = [UIFont boldSystemFontOfSize:13.0];
    }
    return _titleLab;
}

@end

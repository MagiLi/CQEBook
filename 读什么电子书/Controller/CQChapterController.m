//
//  CQChapterController.m
//  读什么电子书
//
//  Created by mac on 17/2/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQChapterController.h"
#import "ReadModel+CoreDataClass.h"
#import "CQChapterListCell.h"

@interface CQChapterController ()
@property(nonatomic,strong)NSSet <ChapterModel *> *chapterModelSet;
@end

@implementation CQChapterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chapterModelSet = self.readModel.read_chapter;
    self.tableView.backgroundColor = [UIColor colorWithRed:247.0 / 255.0 green:247.0 / 255.0 blue:247.0 / 255.0 alpha:1.0];
    self.tableView.contentInset = UIEdgeInsetsMake(27.0, .0, 10.0, .0);
    self.tableView.rowHeight = 41.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *nib = [UINib nibWithNibName:@"CQChapterListCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:chapterListCellID];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chapterModelSet.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CQChapterListCell *cell = [CQChapterListCell cellWithTableView:tableView withIndexPath:indexPath withChapterSet:self.chapterModelSet];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.chapterDelegate respondsToSelector:@selector(chapterDidSelectedChapter:page:)]) {
        [self.chapterDelegate chapterDidSelectedChapter:indexPath.row page:0];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

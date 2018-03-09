//
//  CQMarksController.m
//  读什么电子书
//
//  Created by mac on 17/2/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQMarksController.h"
#import "ReadModel+CoreDataClass.h"
#import "MarkModel+CoreDataClass.h"
#import "NoteModel+CoreDataClass.h"
#import "CQNoteHeadFooterView.h"
#import "CQNoteCell.h"
#import "CQNoteCellLayout.h"
#import "CQReadUtilty.h"

@interface CQMarksController ()
@property(nonatomic,strong)NSMutableArray *arrayMark;
@end
static NSString *marksListCellID = @"marksListCellID";
@implementation CQMarksController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupMarkUI];
    [self setMarkData];
}
- (void)setMarkData {
    if (!self.isViewLoaded) return;
    
    [self.arrayMark removeAllObjects];
    NSSortDescriptor *desChapter = [NSSortDescriptor sortDescriptorWithKey:@"currentChapter" ascending:YES];
    NSSortDescriptor *desPage = [NSSortDescriptor sortDescriptorWithKey:@"currentPage" ascending:YES];
    NSArray *array = [self.readModel.read_mark sortedArrayUsingDescriptors:@[desChapter, desPage]];
    
    __block NSInteger currentChapter;
    [array enumerateObjectsUsingBlock:^(MarkModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            currentChapter = obj.currentChapter;
            
            NSMutableArray *arrayFirst = [NSMutableArray array];
            
            CQNoteCellLayout *layout = [[CQNoteCellLayout alloc] initWithMarkModel:obj];
            [arrayFirst addObject:layout];
            [self.arrayMark addObject:arrayFirst];
        } else {
            if (currentChapter == obj.currentChapter) {
                NSMutableArray *arrayLast = [self.arrayMark lastObject];
                CQNoteCellLayout *layout = [[CQNoteCellLayout alloc] initWithMarkModel:obj];
                [arrayLast addObject:layout];
            } else {
                NSMutableArray *arrayNew = [NSMutableArray array];
                CQNoteCellLayout *layout = [[CQNoteCellLayout alloc] initWithMarkModel:obj];
                [arrayNew addObject:layout];
                [self.arrayMark addObject:arrayNew];
                
                currentChapter = obj.currentChapter;
            }
        }
    }];
    [self.tableView reloadData];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView  {
    return self.arrayMark.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayMark[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CQNoteCell *cell = [CQNoteCell cellWithTableView:tableView withIndexPath:indexPath withMarkArray:self.arrayMark];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CQNoteCellLayout *layout = self.arrayMark[indexPath.section][indexPath.row];
    return layout.cellH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CQNoteCellLayout *layout = self.arrayMark[indexPath.section][indexPath.row];
    MarkModel *markModel = layout.markModel;
    if ([self.markDelegate respondsToSelector:@selector(markDidSelectedChapter:page:)]) {
        [self.markDelegate markDidSelectedChapter:markModel.currentChapter page:markModel.currentPage];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CQNoteCellLayout *layout = [self.arrayMark[section] firstObject];
    
    ChapterModel *chapterModel = [CQReadUtilty queryChapterModelWithReadModel:self.readModel withChapter:layout.markModel.currentChapter];
    CQNoteHeadFooterView *headerView = [CQNoteHeadFooterView headFooterViewWithTableView:tableView withSection:section withChapterModel:chapterModel];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"footerViewID"];
    footerView.contentView.backgroundColor = [UIColor colorWithRed:230.0 / 255.0 green:230.0 / 255.0 blue:230.0 / 255.0 alpha:1.0];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *arraySmall = self.arrayMark[indexPath.section];
    CQNoteCellLayout *layout = arraySmall[indexPath.row];
    MarkModel *markModel = layout.markModel;
//    [arraySmall removeObjectAtIndex:indexPath.row];
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];

    [[NSNotificationCenter defaultCenter] postNotificationName:DeleteMarkNotification_Key object:markModel];
}

- (void)setupMarkUI {
    self.tableView.backgroundColor = [UIColor colorWithRed:247.0 / 255.0 green:247.0 / 255.0 blue:247.0 / 255.0 alpha:1.0];
    self.tableView.contentInset = UIEdgeInsetsMake(27.0, .0, 10.0, .0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *nib = [UINib nibWithNibName:@"CQNoteCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:noteListCellID];
    [self.tableView registerClass:[CQNoteHeadFooterView class] forHeaderFooterViewReuseIdentifier:noteHeadFootCellID];
}

- (NSMutableArray *)arrayMark {
    if (!_arrayMark) {
        _arrayMark = [NSMutableArray array];
    }
    return _arrayMark;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end

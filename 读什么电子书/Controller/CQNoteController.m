//
//  CQNoteController.m
//  读什么电子书
//
//  Created by mac on 17/2/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQNoteController.h"
#import "CQNoteHeadFooterView.h"
#import "CQNoteCell.h"
#import "CQNoteCellLayout.h"
#import "ReadModel+CoreDataClass.h"
#import "NoteModel+CoreDataClass.h"
#import "CQReadUtilty.h"
#import "ChapterModel+CoreDataClass.h"

@interface CQNoteController ()
@property(nonatomic,strong)NSMutableArray *arrayNote;

@end

@implementation CQNoteController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNoteUI];
    [self setNoteData];
}

- (void)setNoteData {
    if (!self.isViewLoaded) return;
    [self.arrayNote removeAllObjects];
    NSSortDescriptor *desChapter = [NSSortDescriptor sortDescriptorWithKey:@"currentChapter" ascending:YES];
    NSSortDescriptor *desPage = [NSSortDescriptor sortDescriptorWithKey:@"currentPage" ascending:YES];
    NSArray *array = [self.readModel.read_note sortedArrayUsingDescriptors:@[desChapter, desPage]];
    
    __block NSInteger currentChapter;
    [array enumerateObjectsUsingBlock:^(NoteModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            currentChapter = obj.currentChapter;
            
            NSMutableArray *arrayFirst = [NSMutableArray array];
            
            CQNoteCellLayout *layout = [[CQNoteCellLayout alloc] initWithNoteModel:obj];
            [arrayFirst addObject:layout];
            [self.arrayNote addObject:arrayFirst];
        } else {
            if (currentChapter == obj.currentChapter) {
                NSMutableArray *arrayLast = [self.arrayNote lastObject];
                CQNoteCellLayout *layout = [[CQNoteCellLayout alloc] initWithNoteModel:obj];
                [arrayLast addObject:layout];
            } else {
                NSMutableArray *arrayNew = [NSMutableArray array];
                CQNoteCellLayout *layout = [[CQNoteCellLayout alloc] initWithNoteModel:obj];
                [arrayNew addObject:layout];
                [self.arrayNote addObject:arrayNew];
                
                currentChapter = obj.currentChapter;
            }
        }
    }];
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayNote.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayNote[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CQNoteCell *cell = [CQNoteCell cellWithTableView:tableView withIndexPath:indexPath withNoteArray:self.arrayNote];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CQNoteCellLayout *layout = self.arrayNote[indexPath.section][indexPath.row];
    return layout.cellH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CQNoteCellLayout *layout = self.arrayNote[indexPath.section][indexPath.row];
    NoteModel *noteMode = layout.noteModel;
    if ([self.noteDelegate respondsToSelector:@selector(noteDidSelectedChapter:page:)]) {
        [self.noteDelegate noteDidSelectedChapter:noteMode.currentChapter page:noteMode.currentPage];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CQNoteCellLayout *layout = [self.arrayNote[section] firstObject];
    
    ChapterModel *chapterModel = [CQReadUtilty queryChapterModelWithReadModel:self.readModel withChapter:layout.noteModel.currentChapter];
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
    NSMutableArray *arraySmall = self.arrayNote[indexPath.section];
    CQNoteCellLayout *layout = arraySmall[indexPath.row];
    NoteModel *noteMode = layout.noteModel;
//    [arraySmall removeObjectAtIndex:indexPath.row];
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DeleteNoteNotification_Key object:noteMode];
}

- (void)setupNoteUI {
    self.tableView.backgroundColor = [UIColor colorWithRed:247.0 / 255.0 green:247.0 / 255.0 blue:247.0 / 255.0 alpha:1.0];
    self.tableView.contentInset = UIEdgeInsetsMake(27.0, .0, 10.0, .0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib *nib = [UINib nibWithNibName:@"CQNoteCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:noteListCellID];
    [self.tableView registerClass:[CQNoteHeadFooterView class] forHeaderFooterViewReuseIdentifier:noteHeadFootCellID];
}

-(NSMutableArray *)arrayNote {
    if (!_arrayNote) {
        _arrayNote = [NSMutableArray array];
    }
    return _arrayNote;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end

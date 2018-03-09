//
//  CQNoteCell.m
//  读什么电子书
//
//  Created by mac on 17/3/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQNoteCell.h"
#import "NoteModel+CoreDataClass.h"
#import "MarkModel+CoreDataClass.h"
#import "CQNoteCellLayout.h"

@interface CQNoteCell ()
@property(nonatomic,weak)CQNoteCellLayout *layoutNote;
@property(nonatomic,weak)CQNoteCellLayout *layoutMark;
@property (weak, nonatomic) IBOutlet UILabel *labContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentConstant;
@property (weak, nonatomic) IBOutlet UILabel *labDate;
@property (weak, nonatomic) IBOutlet UILabel *pageLab;

@property (weak, nonatomic) IBOutlet UILabel *noteLab;
@property (weak, nonatomic) IBOutlet UILabel *noteContentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noteContentConstant;
@end

@implementation CQNoteCell

+ (CQNoteCell *)cellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withNoteArray:(NSArray *)array {
    CQNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:noteListCellID forIndexPath:indexPath];
    cell.layoutNote = array[indexPath.section][indexPath.row];
    return cell;
}

- (void)setLayoutNote:(CQNoteCellLayout *)layoutNote {
    _layoutNote = layoutNote;
    self.labDate.text = [self getStringDate:layoutNote.noteModel.date];
    self.pageLab.text = [NSString stringWithFormat:@"第%zd页", layoutNote.noteModel.currentPage + 1];
    self.labContent.text = layoutNote.noteModel.noteContent;
    
    self.noteContentLab.text = layoutNote.noteModel.noteTitle;
    self.contentConstant.constant = layoutNote.contentLabH;
    self.noteContentConstant.constant = layoutNote.noteTitleLabH;
    
    if (layoutNote.noteModel.type == 1.0) {
        self.noteLab.hidden = YES;
        self.noteContentLab.hidden = YES;
    } else {
        self.noteLab.hidden = NO;
        self.noteContentLab.hidden = NO;
    }
}

+ (CQNoteCell *)cellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withMarkArray:(NSArray *)array {
    CQNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:noteListCellID forIndexPath:indexPath];
    cell.layoutMark = array[indexPath.section][indexPath.row];
    return cell;
}

- (void)setLayoutMark:(CQNoteCellLayout *)layoutMark {
    _layoutMark = layoutMark;
    self.labDate.text = [self getStringDate:layoutMark.markModel.date];
    self.pageLab.text = [NSString stringWithFormat:@"第%zd页", layoutMark.markModel.currentPage + 1];
    self.labContent.text = layoutMark.markModel.markContent;
    self.contentConstant.constant = layoutMark.contentLabH;
}

- (NSString *)getStringDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss"];
    [dateFormatter setDefaultDate:date];
    return [dateFormatter stringFromDate:date];
}
@end

//
//  CQNoteCell.h
//  读什么电子书
//
//  Created by mac on 17/3/20.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *noteListCellID = @"noteListCellID";

@interface CQNoteCell : UITableViewCell
+ (CQNoteCell *)cellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withNoteArray:(NSArray *)array;

+ (CQNoteCell *)cellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withMarkArray:(NSArray *)array;
@end

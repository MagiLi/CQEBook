//
//  CQNoteHeadFooterView.h
//  读什么电子书
//
//  Created by mac on 17/3/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


static NSString *noteHeadFootCellID = @"noteHeadFootCellID";

@class ChapterModel;

@interface CQNoteHeadFooterView : UITableViewHeaderFooterView
+ (CQNoteHeadFooterView *)headFooterViewWithTableView:(UITableView *)tableView withSection:(NSInteger)section withChapterModel:(ChapterModel *)chapterModel;
@end

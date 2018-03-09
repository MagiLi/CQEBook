//
//  CQChapterListCell.h
//  读什么电子书
//
//  Created by mac on 17/3/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChapterModel+CoreDataClass.h"

static NSString *chapterListCellID = @"chapterListCellID";
@interface CQChapterListCell : UITableViewCell
+ (CQChapterListCell *)cellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withChapterSet:(NSSet <ChapterModel *>*)chapterSet;
@end

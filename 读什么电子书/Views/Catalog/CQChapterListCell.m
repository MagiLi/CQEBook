//
//  CQChapterListCell.m
//  读什么电子书
//
//  Created by mac on 17/3/23.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQChapterListCell.h"
#import "CQReadUtilty.h"

@interface CQChapterListCell ()
@property(nonatomic,weak)ChapterModel *chapterModel;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@end

@implementation CQChapterListCell

+ (CQChapterListCell *)cellWithTableView:(UITableView *)tableView withIndexPath:(NSIndexPath *)indexPath withChapterSet:(NSSet<ChapterModel *> *)chapterSet {
    CQChapterListCell *cell = [tableView dequeueReusableCellWithIdentifier:chapterListCellID forIndexPath:indexPath];
    ChapterModel *chapterModel = [CQReadUtilty queryChapterModelWithChapterSet:chapterSet withChapter:indexPath.row];
    cell.chapterModel = chapterModel;
    cell.numLab.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    return cell;
}

- (void)setChapterModel:(ChapterModel *)chapterModel {
    _chapterModel = chapterModel;
    
    self.titleLab.text = chapterModel.title;
}
@end

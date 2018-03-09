//
//  CQMainCell.m
//  读什么电子书
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQMainCell.h"

@interface CQMainCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bookCoverImgView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLab;

@end

@implementation CQMainCell
+ (CQMainCell *)cellWithCollectionView:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath {
    CQMainCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        cell.bookTitleLab.text = [NSString stringWithFormat:@"text-%zd", indexPath.item];
    } else {
        cell.bookTitleLab.text = [NSString stringWithFormat:@"EPUB-%zd", indexPath.item];
    }
    return cell;
}


@end

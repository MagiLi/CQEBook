//
//  CQMainCell.h
//  读什么电子书
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const reuseIdentifier = @"Cell";

@interface CQMainCell : UICollectionViewCell

+ (CQMainCell *)cellWithCollectionView:(UICollectionView *)collectionView withIndexPath:(NSIndexPath *)indexPath;

@end

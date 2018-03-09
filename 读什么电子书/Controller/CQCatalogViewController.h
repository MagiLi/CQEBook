//
//  CQCatalogViewController.h
//  读什么电子书
//
//  Created by mac on 17/2/8.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQPagerViewController.h"
#import "CQReadUtilty.h"
#import "ReadModel+CoreDataClass.h"

@protocol CQCatalogViewControllerDelegate <NSObject>

- (void)openChapter:(NSInteger)chapter page:(NSInteger)page;

@end

@interface CQCatalogViewController : CQPagerViewController
@property(nonatomic,strong)ReadModel *model;
@property(nonatomic,weak)id<CQCatalogViewControllerDelegate> catalogDelegate;
- (void)hiddenAnimation;
- (void)showAnimation;

- (void)reloadNoteData;
- (void)reloadMarkData;
@end

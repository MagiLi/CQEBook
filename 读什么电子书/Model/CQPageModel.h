//
//  CQPageModel.h
//  读什么电子书
//
//  Created by mac on 17/2/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "CoverModel+CoreDataClass.h"

@interface CQPageModel : NSObject
@property(nonatomic,assign)NSUInteger location;// 当前偏移量(相对于章节)
@property(nonatomic,assign)NSUInteger currentLength;// 当前页的长度
@property(nonatomic,assign)NSUInteger currentPageForChapter;// 当前页数(相对于单个章节)
@property(nonatomic,copy)NSString *pageContent;

@property (nonatomic,assign) CTFrameRef ctFrame;
@property(nonatomic,strong)CoverModel *coverModel;
@property(nonatomic,assign)BOOL markAdded; // 有没有添加标签

- (void)calculateCoverData; // 计算封皮的数据
@end

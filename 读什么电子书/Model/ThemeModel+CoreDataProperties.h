//
//  ThemeModel+CoreDataProperties.h
//  读什么电子书
//
//  Created by mac on 17/3/22.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "ThemeModel+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ThemeModel (CoreDataProperties)

+ (NSFetchRequest<ThemeModel *> *)fetchRequest;

@property (nonatomic) float firstLineHeadIndent;
@property (nonatomic) int16_t fontColorTag;
@property (nonatomic) float fontSize;
@property (nonatomic) int16_t kernSpace;
@property (nonatomic) float lineSpace;
@property (nonatomic) int16_t themeTag;

@end

NS_ASSUME_NONNULL_END

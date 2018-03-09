//
//  CQFrameSetterParser.h
//  读什么电子书
//
//  Created by mac on 17/3/15.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

typedef enum : NSUInteger {
    NSAttributedStringDefault   = 0,
    NSAttributedStringTitle     = 1,
    NSAttributedStringTitleH1   = 2,
    NSAttributedStringTitleH2   = 3,
} NSAttributedStringType;

@interface CQFrameSetterParser : NSObject
// 获取属性字符串
+ (NSAttributedString *)parseAttributedContentWithType:(NSAttributedStringType)stringType withContent:(NSString *)content;
// 获取占位符
+ (NSAttributedString *)getPlaceholderStringWithDictionary:(NSDictionary *)dict;
@end

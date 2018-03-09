//
//  CQFrameSetterParser.m
//  读什么电子书
//
//  Created by mac on 17/3/15.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQFrameSetterParser.h"
#import "ChapterModel+CoreDataClass.h"
#import "CQThemeConfig.h"

static CGFloat ascentCallback(void * __nullable refCon) {
    
    CGFloat height = [(NSNumber *)[(__bridge NSDictionary *)refCon objectForKey:@"height"] floatValue];
    return height;
}

static CGFloat descentCallback(void * __nullable refCon) {
    return 0;
}

static CGFloat widthCallback(void * __nullable refCon) {
    

    CGFloat width = [(NSNumber *)[(__bridge NSDictionary *)refCon objectForKey:@"width"] floatValue];
    return width;
}

@implementation CQFrameSetterParser
+ (CTFrameRef)getFrameWithFrameSetter:(CTFramesetterRef)frameSetter withCurrentOffset:(NSUInteger)currentOffset {
    CGPathRef pathRef = CGPathCreateWithRect(CGRectMake(0, 0, kScreen_W, kScreen_H - Title_H - PageIndex_H), NULL);
    CTFrameRef frameRef = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentOffset, 0), pathRef, NULL);
    CFRelease(pathRef);
    return frameRef;
}

#pragma mark -  获取属性字符串
+ (NSAttributedString *)parseAttributedContentWithType:(NSAttributedStringType)stringType withContent:(NSString *)content {
    NSDictionary *attributes;
    if (stringType == NSAttributedStringTitle) {
        attributes = [self parserAttributeTitle:[CQThemeConfig sharedInstance] addFontSize:2.0 withTextAlignment:kCTTextAlignmentJustified];
    } else if (stringType == NSAttributedStringTitleH1) {
        attributes = [self parserAttributeTitle:[CQThemeConfig sharedInstance] addFontSize:1.0 withTextAlignment:kCTTextAlignmentCenter];
    } else if (stringType == NSAttributedStringTitleH2) {
        attributes = [self parserAttributeTitle:[CQThemeConfig sharedInstance] addFontSize:1.0 withTextAlignment:kCTTextAlignmentCenter];
    } else {
        attributes = [self parserAttribute:[CQThemeConfig sharedInstance]];
    }
    return [[NSAttributedString alloc] initWithString:content attributes:attributes];
}
+ (NSDictionary *)parserAttributeTitle:(CQThemeConfig *)config addFontSize:(CGFloat)fontSize withTextAlignment:(CTTextAlignment)alignment {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    CGFloat maximumLineSpacing = config.lineSpace + 10.0;
    CGFloat minimumLineSpace = config.lineSpace + 10.0;
    CGFloat headIndent = LeftSpacing;
    CGFloat tailIndent = kScreen_W - LeftSpacing;
    CGFloat firstLineHeadIndent = 10.0;
    
    const CFIndex kNumberOfSettings = 6;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierAlignment,sizeof(alignment),&alignment},
        {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(CGFloat),&maximumLineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(CGFloat),&minimumLineSpace},
        {kCTParagraphStyleSpecifierFirstLineHeadIndent,sizeof(CGFloat),&firstLineHeadIndent},
        {kCTParagraphStyleSpecifierHeadIndent,sizeof(CGFloat),&headIndent},
        {kCTParagraphStyleSpecifierTailIndent,sizeof(CGFloat),&tailIndent}
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    dict[(id)kCTKernAttributeName] = @([config.kernSpace integerValue] + 5);
    dict[(id)kCTForegroundColorAttributeName] = config.fontColor;
    dict[(id)kCTFontAttributeName] = [UIFont boldSystemFontOfSize:config.fontSize + fontSize];
    return [dict copy];
}
+ (NSDictionary *)parserAttribute:(CQThemeConfig *)config {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    CTTextAlignment alignment = kCTTextAlignmentJustified;
    CGFloat maximumLineSpacing = config.lineSpace;
    CGFloat minimumLineSpace = config.lineSpace;
    CGFloat firstLineHeadIndent = config.firstLineHeadIndent;
    CGFloat headIndent = LeftSpacing;
    CGFloat tailIndent = kScreen_W - LeftSpacing;
    
    const CFIndex kNumberOfSettings = 6;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierAlignment,sizeof(alignment),&alignment},
        {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(CGFloat),&maximumLineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(CGFloat),&minimumLineSpace},
        {kCTParagraphStyleSpecifierFirstLineHeadIndent,sizeof(CGFloat),&firstLineHeadIndent},
        {kCTParagraphStyleSpecifierHeadIndent,sizeof(CGFloat),&headIndent},
        {kCTParagraphStyleSpecifierTailIndent,sizeof(CGFloat),&tailIndent}
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    dict[(id)kCTKernAttributeName] = config.kernSpace;
    dict[(id)kCTForegroundColorAttributeName] = config.fontColor;
    dict[(id)kCTFontAttributeName] = [UIFont systemFontOfSize:config.fontSize];
    return [dict copy];
}
+ (NSDictionary *)parserAttributeImg:(CQThemeConfig *)config {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    CTTextAlignment alignment = kCTTextAlignmentCenter;
    CGFloat headIndent = LeftSpacing;
    CGFloat tailIndent = kScreen_W - LeftSpacing;
    CGFloat maximumLineSpacing = config.lineSpace;
    CGFloat minimumLineSpace = config.lineSpace;
    
    const CFIndex kNumberOfSettings = 5;
    CTParagraphStyleSetting theSettings[kNumberOfSettings] = {
        {kCTParagraphStyleSpecifierHeadIndent,sizeof(CGFloat),&headIndent},
        {kCTParagraphStyleSpecifierTailIndent,sizeof(CGFloat),&tailIndent},
        {kCTParagraphStyleSpecifierMaximumLineSpacing,sizeof(CGFloat),&maximumLineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing,sizeof(CGFloat),&minimumLineSpace},
        {kCTParagraphStyleSpecifierAlignment,sizeof(alignment),&alignment}
    };
    
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSettings);
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    return [dict copy];
}

#pragma mark -
#pragma mark - 获取带回调的占位符
+ (NSAttributedString *)getPlaceholderStringWithDictionary:(NSDictionary *)dict {
    CTRunDelegateCallbacks callbacks;
    // memset将已开辟内存空间 callbacks 的首 n 个字节的值设为值 0, 相当于对CTRunDelegateCallbacks内存空间初始化
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void *)dict);// dict：回调的参数
    unichar placeChar = 0xFFFC;// 占位符
    NSString *content = [NSString stringWithCharacters:&placeChar length:1];
    
    NSDictionary *attributes = [self parserAttributeImg:[CQThemeConfig sharedInstance]];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", content] attributes:attributes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(1, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}
@end

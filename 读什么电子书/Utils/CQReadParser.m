//
//  CQReadParser.m
//  读什么电子书
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQReadParser.h"

@implementation CQReadParser

+ (NSArray *)praserRectsSelectedRange:(NSRange)selectedRange ctFrame:(CTFrameRef)ctFrame; {
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CFIndex lineCount = CFArrayGetCount(lines);
    NSMutableArray *arrayPath = [NSMutableArray array];
    if (!lineCount) return arrayPath;
    // 获得每一行的origin坐标
    CGPoint origins[lineCount];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), origins);

    for (int i = 0; i < lineCount; i++){
        CGPoint baselineOrigin = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat ascent,descent,linegap; //声明字体的上行高度和下行高度和行距
        CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
        CFRange stringRange = CTLineGetStringRange(line);
        NSRange drawRange = [self selectRange:selectedRange lineRange:NSMakeRange(stringRange.location, stringRange.length)];
        if (drawRange.length) {
            CGFloat xStart = CTLineGetOffsetForStringIndex(line, drawRange.location, NULL);
            CGFloat xEnd = CTLineGetOffsetForStringIndex(line, drawRange.location+drawRange.length, NULL);
            
            CGRect rect = CGRectMake(xStart+baselineOrigin.x, baselineOrigin.y-descent, fabs(xStart-xEnd), ascent+descent);
            if (rect.size.width ==0 || rect.size.height == 0) continue;
            [arrayPath addObject:NSStringFromCGRect(rect)];
        }
    }
    return arrayPath;
}
+ (CGRect)praserRectInView:(UIView *)view atPoint:(CGPoint)point selectedRange:(NSRange *)selectedRange ctFrame:(CTFrameRef)ctFrame {
    CFIndex index = -1;
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    if (!lines) return CGRectZero;
    CFIndex count = CFArrayGetCount(lines);
    if (!count) return CGRectZero;
    
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), origins);
    
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
    CGRect flippedRect = CGRectZero; // 翻转后的坐标
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i]; // 每一行的起始位置
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        // 获得每一行的rect信息
        CGFloat ascent = 0.0f, descent = 0.0f, linegap = 0.0f;
        CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
        CGFloat height = ascent + descent;
        CGRect tempRect = CGRectMake(linePoint.x, linePoint.y, width, height);
        CGRect rect = CGRectApplyAffineTransform(tempRect, transform); // 翻转坐标系
        if (CGRectContainsPoint(rect, point)) {
            CFRange stringRange = CTLineGetStringRange(line);
            // 将点击的坐标转化为相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect) - 8, CGRectGetMinY(rect));
            // 获取当前点击坐标对应的字符串偏移量
            index = CTLineGetStringIndexForPosition(line, relativePoint);
            
            CGFloat xStart = CTLineGetOffsetForStringIndex(line, index, NULL); // current line's offset of touch string
            
            CGFloat xEnd;
            //默认选中两个单位
            if (index > stringRange.location+stringRange.length - 2) {
                xEnd = xStart;
                xStart = CTLineGetOffsetForStringIndex(line,index-2,NULL);
                (*selectedRange).location = index-2;
            } else{
                xEnd = CTLineGetOffsetForStringIndex(line,index+2,NULL);
                (*selectedRange).location = index;
            }
            (*selectedRange).length = 2;
            
            flippedRect = CGRectMake(linePoint.x+xStart,linePoint.y-descent,fabs(xStart-xEnd), ascent+descent);
            break;
        }
    }
    return flippedRect;
}

+(NSArray *)parserRectsInView:(UIView *)view atPoint:(CGPoint)point range:(NSRange *)selectRange ctFrame:(CTFrameRef)ctFrame paths:(NSArray *)paths direction:(BOOL) direction {
//    if (!ctFrame) return paths;
    CFIndex index = -1;
    CFArrayRef lines = CTFrameGetLines(ctFrame);
    NSMutableArray *muArr = [NSMutableArray array];
    CFIndex lineCount = CFArrayGetCount(lines);
    // 获得每一行的origin坐标
    CGPoint origins[lineCount];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, 0), origins);
    //    CGPoint *origins = malloc(lineCount * sizeof(CGPoint)); //给每行的起始点开辟内存
    
    // 翻转坐标系
    CGAffineTransform transform = CGAffineTransformMakeTranslation(0, view.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.0f, -1.0f);
    for (int i = 0; i < lineCount; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        // 获得每一行的rect信息
        CGFloat ascent, descent, linegap;
        CGFloat width = CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
        CGFloat height = ascent + descent;
        CGRect tempRect = CGRectMake(linePoint.x, linePoint.y, width, height);
        CGRect rect = CGRectApplyAffineTransform(tempRect, transform);
        if (CGRectContainsPoint(rect,point)){
            // 将点击的坐标转化为相对于当前行的坐标
            CGPoint relativePoint = CGPointMake(point.x - CGRectGetMinX(rect) - 8, CGRectGetMinY(rect));
            index = CTLineGetStringIndexForPosition(line, relativePoint);
            break;
        }
        
    }
    if (index == -1) return paths;
    
    if (direction) {//从右侧滑动
        if (!(index>(*selectRange).location)) { // 判断当前点是在选中区域的前面还是后面
            (*selectRange).length = (*selectRange).location-index+(*selectRange).length;
            (*selectRange).location = index;
        }
        else{ // 后面
            (*selectRange).length = index-(*selectRange).location;
        }
    } else {//从左侧滑动
        if (!(index>(*selectRange).location+(*selectRange).length)) {
            (*selectRange).length = (*selectRange).location-index+(*selectRange).length;
            (*selectRange).location = index;
        }
    }
    
    for (int i = 0; i<lineCount; i++){
        CGPoint baselineOrigin = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CGFloat ascent,descent,linegap; //声明字体的上行高度和下行高度和行距
        CTLineGetTypographicBounds(line, &ascent, &descent, &linegap);
        CFRange stringRange = CTLineGetStringRange(line);
        NSRange drawRange = [self selectRange:NSMakeRange((*selectRange).location, (*selectRange).length) lineRange:NSMakeRange(stringRange.location, stringRange.length)];
        if (drawRange.length) {
            CGFloat xStart = CTLineGetOffsetForStringIndex(line, drawRange.location, NULL);
            CGFloat xEnd = CTLineGetOffsetForStringIndex(line, drawRange.location+drawRange.length, NULL);
            
            CGRect rect = CGRectMake(xStart+baselineOrigin.x, baselineOrigin.y-descent, fabs(xStart-xEnd), ascent+descent);
            if (rect.size.width ==0 || rect.size.height == 0) continue;
            [muArr addObject:NSStringFromCGRect(rect)];
        }
    }
    
    return muArr;
}

+(NSRange)selectRange:(NSRange)selectRange lineRange:(NSRange)lineRange {

    NSRange range = NSMakeRange(NSNotFound, 0);
    if (selectRange.location<lineRange.location) {
        NSRange tmp = lineRange;
        lineRange = selectRange;
        selectRange = tmp;
    }
    if (selectRange.location<lineRange.location+lineRange.length) {
        range.location = selectRange.location;
        NSUInteger end = MIN(selectRange.location+selectRange.length, lineRange.location+lineRange.length);
        range.length = end-range.location;
    }
    return range;
}
@end

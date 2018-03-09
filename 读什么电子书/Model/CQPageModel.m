//
//  CQPageModel.m
//  读什么电子书
//
//  Created by mac on 17/2/6.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQPageModel.h"

@implementation CQPageModel
- (void)setCoverModel:(CoverModel *)coverModel {
    _coverModel = coverModel;
    [self calculateCoverData];
}
- (void)calculateCoverData {
    if (!self.coverModel) return;
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctFrame);
    NSUInteger lineCount = lines.count;
    // 每行的起始坐标
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, 0), lineOrigins);
    
    int imageIndex = 0;
    for (int i = 0; i < lineCount; i++) {
        if (imageIndex > 0) break;
        CTLineRef line = (__bridge CTLineRef)(lines[i]);
        NSArray *runObjectArray = (NSArray *)CTLineGetGlyphRuns(line);
        /*
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CFIndex runCount = CFArrayGetCount(runs);
        CTRunRef run = CFArrayGetValueAtIndex(runs, k);
        */
        for (id runObject in runObjectArray) {
            CTRunRef run = (__bridge CTRunRef)(runObject);
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)([runAttributes valueForKey:(id)kCTRunDelegateAttributeName]);
            // 如果delegate是空，表明不是图片
            if (!delegate) continue;
            // 回调参数的类型
            NSDictionary *metaDict = CTRunDelegateGetRefCon(delegate);
            if (![metaDict isKindOfClass:[NSDictionary class]]) continue;
            
            // 确定图片run的frame
            CGRect runBounds;
            CGFloat ascent,descent;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL); // 得到run的width
            runBounds.size.height = ascent + descent;
            
            // 计算出图片相对于每行起始位置x方向上面的偏移量
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            self.coverModel.stringRect = NSStringFromCGRect(runBounds);
            imageIndex++;// 拿到第一个delegate（也就是图片的位置） 直接退出循环
            break;
        }
    }
    
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.location forKey:@"location"];
    [aCoder encodeInteger:self.currentLength forKey:@"currentLength"];
    [aCoder encodeInteger:self.currentPageForChapter forKey:@"currentPageForChapter"];
    [aCoder encodeBool:_markAdded forKey:@"markAdded"];
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.location = [aDecoder decodeIntegerForKey:@"location"];
        self.currentLength = [aDecoder decodeIntegerForKey:@"currentLength"];
        self.currentPageForChapter = [aDecoder decodeIntegerForKey:@"currentPageForChapter"];
        self.markAdded = [aDecoder decodeBoolForKey:@"markAdded"];
    }
    return self;
}

- (void)setCtFrame:(CTFrameRef)ctFrame {
    if (_ctFrame != ctFrame) {
        if(_ctFrame != nil) {
            CFRelease(_ctFrame);
        }
        
        CFRetain(ctFrame);
        _ctFrame = ctFrame;
    }
}
@end

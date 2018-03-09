//
//  CQReadConfig.m
//  读什么电子书
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "CQThemeConfig.h"
#import "ThemeModel+CoreDataClass.h"

@interface CQThemeConfig ()
@property(nonatomic,strong)ThemeModel *themeModel;

@property(nonatomic,strong)NSArray *arrayThemeColor;
@property(nonatomic,strong)NSArray *arrayTextColor;
@end

@implementation CQThemeConfig
+(instancetype)sharedInstance {
    static CQThemeConfig *themeConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        themeConfig = [[self alloc] init];
    });
    return themeConfig;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        NSEntityDescription *bookDescription = [NSEntityDescription entityForName:@"ThemeModel" inManagedObjectContext:[CQCoreDataTools sharedCoreDataTools].managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:bookDescription];
        NSArray *bookAry = [[CQCoreDataTools sharedCoreDataTools].managedObjectContext executeFetchRequest:request error:nil];
        
        if (bookAry.count) {
            ThemeModel *themeModel = [bookAry firstObject];
            _firstLineHeadIndent = themeModel.firstLineHeadIndent;
            _fontSize = themeModel.fontSize;
            _kernSpace = @(themeModel.kernSpace);
            _lineSpace = themeModel.lineSpace;
            _fontColor = self.arrayTextColor[themeModel.fontColorTag];
            _isNight = themeModel.fontColorTag;
            _theme = self.arrayThemeColor[themeModel.themeTag];
            self.themeModel = themeModel;
        } else {
            
            ThemeModel *themeModel = [NSEntityDescription insertNewObjectForEntityForName:@"ThemeModel" inManagedObjectContext:[CQCoreDataTools sharedCoreDataTools].managedObjectContext];
            themeModel.firstLineHeadIndent = 28.0;
            themeModel.fontColorTag = 0; // 文字的颜色tag
            themeModel.fontSize = 18.0;
            themeModel.kernSpace = 2.0;
            themeModel.lineSpace = 6.0;
            themeModel.themeTag = 0;
            [[CQCoreDataTools sharedCoreDataTools].managedObjectContext save:NULL];
            
            
            _firstLineHeadIndent = 28.0;
            _fontSize = 18.0f;
            _kernSpace = @(2.0);
            _lineSpace = 6.0f;
            _fontColor = [self.arrayTextColor firstObject];
            _theme = self.arrayThemeColor[0];
            _isNight = NO;
            self.themeModel = themeModel;
        }
    }
    return self;
}
- (void)setTheme:(UIColor *)theme {
    _theme = theme;
    self.themeModel.themeTag = [self getColorTag];
    [[CQCoreDataTools sharedCoreDataTools].managedObjectContext save:NULL];
}
- (void)setFontSize:(CGFloat)fontSize {
    _fontSize = fontSize;
    _lineSpace = fontSize / 3.0;
    _kernSpace = @((fontSize - 15.0) / 3.0 + 1.0);
    _firstLineHeadIndent = (fontSize - 15.0) + 25.0;

    self.themeModel.fontSize = fontSize;
    self.themeModel.lineSpace = _lineSpace;
    self.themeModel.kernSpace = (fontSize - 15.0) / 3.0 + 1.0;
    self.themeModel.firstLineHeadIndent = _firstLineHeadIndent;
    [[CQCoreDataTools sharedCoreDataTools].managedObjectContext save:NULL];
}
- (void)setIsNight:(BOOL)isNight {
    _isNight = isNight;
    if (isNight) {
        self.themeModel.fontColorTag = 1; // 夜间
        self.fontColor = self.arrayTextColor[1];
    } else {
        self.themeModel.fontColorTag = 0; // 白天
        self.fontColor = self.arrayTextColor[0];
    }
    [[CQCoreDataTools sharedCoreDataTools].managedObjectContext save:NULL];
}

- (CGFloat)getFontSizeWithTag:(NSInteger)tag {
    CGFloat fontsize;
    switch (tag) {
        case 0:
            fontsize = 18.0;
            break;
        case 1:
            fontsize = 24.0;
            break;
        case 2:
            fontsize = 30.0;
            break;
        default:
            fontsize = 24.0;
            break;
    }
    return fontsize;
}

- (NSInteger)getFontTag{
    if (_fontSize == 18.0) {
        return 0;
    } else if (_fontSize == 24.0) {
        return 1;
    } else if (_fontSize == 30.0) {
        return 2;
    }
    return 0;
}
- (NSInteger)getColorTag {
    if ([_theme isEqual:self.arrayThemeColor[0]]) {
        return 0;
    } else if ([_theme isEqual:self.arrayThemeColor[1]]) {
        return 1;
    } else if ([_theme isEqual:self.arrayThemeColor[2]]) {
        return 2;
    }
    return 0;
}
- (NSArray *)arrayThemeColor {
    if (!_arrayThemeColor) {
        _arrayThemeColor = @[[UIColor colorWithRed:238.0 / 255.0 green:238.0 / 255.0 blue:238.0 / 255.0 alpha:1.0], [UIColor colorWithRed:246.0 / 255.0 green:239.0 / 255.0 blue:220.0 / 255.0 alpha:1.0], [UIColor colorWithRed:133.0 / 255.0 green:155.0 / 255.0 blue:134.0 / 255.0 alpha:1.0]];
    }
    return _arrayThemeColor;
}
- (NSArray *)arrayTextColor {
    if (!_arrayTextColor) {
        _arrayTextColor = @[[UIColor blackColor], [UIColor lightGrayColor]];
    }
    return _arrayTextColor;
}
@end

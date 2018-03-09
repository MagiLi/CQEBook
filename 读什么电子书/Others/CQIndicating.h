//
//  CQIndicating.h
//  读什么电子书
//
//  Created by mac on 17/2/3.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQIndicating : NSObject
+ (instancetype)sharedInstance;

- (void)setWaitingIndicatorShown:(BOOL)aShown withKey:(NSString *)aKey withText:(NSString *)text;
@end

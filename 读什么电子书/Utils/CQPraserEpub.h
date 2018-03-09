//
//  CQPraserEpub.h
//  读什么电子书
//
//  Created by mac on 17/3/14.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ReadModel;
@interface CQPraserEpub : NSObject
+ (ReadModel *)insertReadModelWithUserID:(NSNumber *)userID withBookID:(NSNumber *)bookID withBookName:(NSString *)bookName withFilePath:(NSString *)filePath;
@end

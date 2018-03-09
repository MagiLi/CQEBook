//
//  ReadModel+CoreDataClass.h
//  读什么电子书
//
//  Created by mac on 17/2/24.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ChapterModel, MarkModel, NoteModel, RecorderModel;

NS_ASSUME_NONNULL_BEGIN

@interface ReadModel : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "ReadModel+CoreDataProperties.h"

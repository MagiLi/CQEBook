//
//  CQCoreDataTools.h
//  ReadWhats
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 高永强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CQCoreDataTools : NSObject

+ (instancetype)sharedCoreDataTools;

/**
 *  使用模型名称&数据库名称初始化Core Data Stack
 */
- (void)setupCoreDataWithModelName:(NSString *)modelName dbName:(NSString *)dbName;

/**
 *  被管理对象的上下文
 */
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

///**
// *  阅读包、单本解读
// */
//- (void)insertDataWithModel:(MySelectedRead *)model withPagenum:(NSInteger)pagenum;
//- (NSArray *)queryDataWithPagenum:(NSInteger)pagenum;
//
///**
// *  专栏订阅
// */
//- (void)insertCSDataWithModel:(CSPayedModel *)model withPagenum:(NSInteger)pagenum; // 插入
//- (NSArray *)queryCSDataWithPagenum:(NSInteger)pagenum withType:(NSNumber *)type; // 查询
//
///**
// *  阅读状态
// */
//- (BOOL)insertReadType_Status:(NSNumber *)type chapter_ID:(NSNumber *)chapter_ID;
//- (ReadType_Status *)queryReadType_Status:(NSNumber *)type chapter_ID:(NSNumber *)chapter_ID;

@end

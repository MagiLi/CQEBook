//
//  CQCoreDataTools.m
//  ReadWhats
//
//  Created by mac on 16/9/13.
//  Copyright © 2016年 高永强. All rights reserved.
//

#import "CQCoreDataTools.h"

@implementation CQCoreDataTools

+ (instancetype)sharedCoreDataTools {
    
    static CQCoreDataTools *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)setupCoreDataWithModelName:(NSString *)modelName dbName:(NSString *)dbName {
    
    // 1. 实例化数据模型
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    // 2. 实例化持久化存储调度器
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    // 3. 指定保存的数据库文件，以及类型
    // 数据库保存的URL
    NSString *dbPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    dbPath = [dbPath stringByAppendingPathComponent:dbName];
    NSURL *dbURL = [NSURL fileURLWithPath:dbPath];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    NSError *error;
    if(![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:dbURL options:options error:&error]) {
    }
    
    // 4. 被管理对象的上下文
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:psc];
}
/*
#pragma mark -
#pragma mark - 阅读包、单本解读
- (void)insertDataWithModel:(MySelectedRead *)model withPagenum:(NSInteger)pagenum {
    
    NSEntityDescription *bookDescription = [NSEntityDescription entityForName:@"HundredRead" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:bookDescription];
    //构造查询条件，相当于where子句
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userid=%@&&contentid=%@", [[CQAccountTool sharedInstance] getUserUserid], model.contentid];
    //把查询条件放进去
    [request setPredicate:predicate];
    //执行查询
    NSArray *bookAry = [_managedObjectContext executeFetchRequest:request error:nil];
    HundredRead *hunderRead;
    if (bookAry.count) {// 表里已经存在
        hunderRead = [bookAry firstObject];
    } else { // 表里没有
        hunderRead = [NSEntityDescription insertNewObjectForEntityForName:@"HundredRead" inManagedObjectContext:_managedObjectContext];
    }
    hunderRead.userid = [[CQAccountTool sharedInstance] getUserUserid];
    hunderRead.cover = model.cover;
    hunderRead.title = model.title;
    hunderRead.contentid = model.contentid;
    hunderRead.type = [NSNumber numberWithInteger:[model.type integerValue]];
    hunderRead.pagenum = @(pagenum);
    hunderRead.indate = model.indate;
    hunderRead.price = model.price;
    [_managedObjectContext save:NULL];
}

- (NSArray *)queryDataWithPagenum:(NSInteger)pagenum
{
    NSEntityDescription *bookDescription = [NSEntityDescription entityForName:@"HundredRead" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:bookDescription];
    //构造查询条件，相当于where子句
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userid=%@&&pagenum=%@", [[CQAccountTool sharedInstance] getUserUserid], @(pagenum)];
    [request setPredicate:predicate];

    NSArray *bookAry = [_managedObjectContext executeFetchRequest:request error:nil];
    NSMutableArray *arrM = [NSMutableArray array];
    if (bookAry.count) {
        for (HundredRead *hunderRead in bookAry) {
            MySelectedRead *model = [[MySelectedRead alloc] init];
            model.cover = hunderRead.cover;
            model.title = hunderRead.title;
            model.contentid = hunderRead.contentid;
            model.type = [hunderRead.type stringValue];
            model.price = hunderRead.price;
            model.indate = hunderRead.indate;
            [arrM addObject:model];
        }
    }
    return arrM;
}
#pragma mark -
#pragma mark - 专栏订阅
- (void)insertCSDataWithModel:(CSPayedModel *)model withPagenum:(NSInteger)pagenum{
    NSEntityDescription *bookDescription = [NSEntityDescription entityForName:@"CSPayedTable" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:bookDescription];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userid=%@&&product_id=%@&&type=%@", [[CQAccountTool sharedInstance] getUserUserid], model.product_id, model.type];
    [request setPredicate:predicate];
    NSArray *bookAry = [_managedObjectContext executeFetchRequest:request error:nil];
    CSPayedTable *payedTable;
    if (bookAry.count) {// 表里已经存在
        payedTable = [bookAry firstObject];
    } else { // 表里没有
        payedTable = [NSEntityDescription insertNewObjectForEntityForName:@"CSPayedTable" inManagedObjectContext:_managedObjectContext];
    }
    payedTable.userid = [[CQAccountTool sharedInstance] getUserUserid];
    payedTable.product_img = model.product_img;
    payedTable.product_name = model.product_name;
    payedTable.product_id = model.product_id;
    payedTable.type = model.type;
    payedTable.pagenum = @(pagenum);
    payedTable.pay_time = model.create_time;
    payedTable.price = [NSString stringWithFormat:@"%@",model.price];
    [_managedObjectContext save:NULL];

}

- (NSArray *)queryCSDataWithPagenum:(NSInteger)pagenum withType:(NSNumber *)type{
    NSEntityDescription *bookDescription = [NSEntityDescription entityForName:@"CSPayedTable" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:bookDescription];
    //构造查询条件，相当于where子句
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userid=%@&&pagenum=%@&&type=%@", [[CQAccountTool sharedInstance] getUserUserid], @(pagenum), type];
    //把查询条件放进去
    [request setPredicate:predicate];
    //执行查询
    NSArray *bookAry = [_managedObjectContext executeFetchRequest:request error:nil];
    //    return bookAry;
    NSMutableArray *arrM = [NSMutableArray array];
    if (bookAry.count) {
        for (CSPayedTable *payedTable in bookAry) {
            CSPayedModel *model = [[CSPayedModel alloc] init];
            model.product_img = payedTable.product_img;
            model.product_name = payedTable.product_name;
            model.product_id = payedTable.product_id;
            model.type = payedTable.type;
            model.price = payedTable.price;
            model.create_time = payedTable.pay_time;
            [arrM addObject:model];
        }
    }
    return arrM;

}

#pragma mark -
#pragma mark - 阅读状态
- (BOOL)insertReadType_Status:(NSNumber *)type chapter_ID:(NSNumber *)chapter_ID {
    NSEntityDescription *bookDescription = [NSEntityDescription entityForName:@"ReadType_Status" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:bookDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chapter_ID=%@&&read_Type=%@", chapter_ID, type];
    [request setPredicate:predicate];
    NSArray *bookAry = [_managedObjectContext executeFetchRequest:request error:nil];

    if (bookAry.count) {// 表里已经存在
        return NO;
    } else { // 表里没有
        ReadType_Status *model = [NSEntityDescription insertNewObjectForEntityForName:@"ReadType_Status" inManagedObjectContext:_managedObjectContext];
        model.userid = [[CQAccountTool sharedInstance] getUserUserid];
        model.read_Type = type;
        model.chapter_ID = chapter_ID;
        model.read_Status = @1;
        [_managedObjectContext save:NULL];
        return YES;
    }
}
- (ReadType_Status *)queryReadType_Status:(NSNumber *)type chapter_ID:(NSNumber *)chapter_ID {
    NSEntityDescription *bookDescription = [NSEntityDescription entityForName:@"ReadType_Status" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:bookDescription];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chapter_ID=%@&&read_Type=%@", chapter_ID,type];
    [request setPredicate:predicate];

    NSArray *bookAry = [_managedObjectContext executeFetchRequest:request error:nil];
    ReadType_Status *model = [bookAry firstObject];
    return model;

}
*/
@end

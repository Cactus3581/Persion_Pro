//
//  FMDBTools.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/5/12.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "FMDBTools.h"
#import "FMDB.h"

static FMDBTools *sharedManager=nil;

@implementation FMDBTools

+ (FMDBTools *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[FMDBTools alloc]init];
    });
    return sharedManager;
}

- (instancetype)init{
    if (self = [super init]) {
        NSFileManager * fmManger = [NSFileManager defaultManager];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *dbPath = [path stringByAppendingPathComponent:DB_NAME];        
        if (![fmManger fileExistsAtPath:dbPath]) {
            [fmManger createFileAtPath:dbPath contents:nil attributes:nil];
        }
        _dbQueue  = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        // 1-更新问题
//        [self updateDbVersion:DB_NEWVERSION];
        [self executeSQL:DB_CREATE_SCHOOL actionType:ST_DB_UPDATE withBlock:^(BOOL bRet, FMResultSet *rs, NSString *msg) {
            NSLog(@"%d",bRet);
            
        }];
    }
    return self;
}

/*
 无事务：单条sql，增删改查
 */
-(void)executeSQL:(NSString *)sqlStr actionType:(ST_DB_ActionType)actionType withBlock:(void(^)(BOOL bRet, FMResultSet *rs, NSString *msg))block {
    [_dbQueue inDatabase:^(FMDatabase *db) {
        if (actionType == ST_DB_SELECT) {
            //查询语句 需要返回记录集
            FMResultSet * rs = [db executeQuery:sqlStr];
            if ([db hadError]) {
                block(NO,rs,[db lastErrorMessage]);
                NSLog(@"executeSQL_quary error %d:  %@",[db lastErrorCode],[db lastErrorMessage]);
            }else{
                block(YES,rs,nil);
            }
        }else{
            //更新操作 只关心操作是否执行成功，不关心记录集  返回布尔值  无执行结果
            BOOL ret = [db executeUpdate:sqlStr];
            if ([db hadError]) {
                block(NO,nil,[db lastErrorMessage]);
                NSLog(@"executeSQL_update error %d:  %@",[db lastErrorCode],[db lastErrorMessage]);
            }else{
                block(ret,nil,nil);
            }
        }
    }];
}

/*
 无事务；sql数组；update
 */
- (void)executeUpdateSQLList:(NSArray *)sqlStrList withBlock:(void(^)(BOOL bRet, NSString *msg))block{
    __block BOOL bRet = NO;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        for (NSString * sql in sqlStrList) {
            bRet = [db executeUpdate:sql];
            if ([db hadError]) {
                block(bRet,[db lastErrorMessage]);
                NSLog(@"executeUpdateSQLList Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
                break;
            }
        }
    }];
    block(bRet,nil);
}

/*
 事务；单条sql；update
 */
-(void)executeUpdateTransactionSql:(NSString *)sql withBlock:(void(^)(BOOL bRet, NSString *msg, BOOL *bRollback))block {
    __block BOOL bRet = NO;
    [_dbQueue  inTransaction:^(FMDatabase *db, BOOL *rollback){
        bRet = [db executeUpdate:sql];
        if ([db hadError]) {
            block(bRet, [db lastErrorMessage], rollback);
            NSLog(@"executeUpdateTransactionSql Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        block(bRet, nil, rollback);
    }];
}

/*
 事务；sql数组；update
 */
-(void)executeUpdateTransactionSqlList:(NSArray *)sqlStrArr withBlock:(void(^)(BOOL bRet, NSString *msg, BOOL *bRollback))block {
    __block BOOL bRet = NO;
    [_dbQueue  inTransaction:^(FMDatabase *db, BOOL *rollback){
        for (NSString *sqlStr in sqlStrArr) {
            bRet = [db executeUpdate:sqlStr];
            if ([db hadError]) {
                block(bRet, [db lastErrorMessage], rollback);
                NSLog(@"executeUpdateTransactionSqlList Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
                break;
            }
        }
        block(bRet, nil, rollback);
    }];
}

/*
 事务；单条sql；query
 */
-(void)executeQueryTransactionSql:(NSString *)sql withBlock:(void(^)(BOOL bRet,FMResultSet *rs, NSString *msg, BOOL *bRollback))block {
    [_dbQueue  inTransaction:^(FMDatabase *db, BOOL *rollback){
        //查询语句 需要返回记录集
        FMResultSet * rs = [db executeQuery:sql];
        if ([db hadError]) {
            block(NO,rs,[db lastErrorMessage],rollback);
            NSLog(@"executeQueryTransactionSql error %d:  %@",[db lastErrorCode],[db lastErrorMessage]);
        }else{
            block(YES,rs,nil,rollback);
        };
    }];
}



// 根据查询到的model，删除／修改或者插入；不用事务，update，数组
//根据查询结果 确定是更新还是新增操作，无事务处理，sqlList[0]查询select语句 sqList[1]update更新语句 sqlList[2] insert into 插入语句
- (void)executeRelevanceSql:(NSArray *)sqlList withBlock:(void(^)(BOOL ret,NSString * errMsg))block{
    __block BOOL ret;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sqlList[0]];
        if ([db hadError]) {
            block(NO,[db lastErrorMessage]);
            NSLog(@"da_error_%@",[db lastErrorMessage]);
        }
        int nCount = 0;
        if ([rs next]) {
            //获取查询数据的个数
            nCount = [rs intForColumnIndex:0];
        }
        [rs close];
        
        NSString * nextSqlString = nil;
        if (nCount > 0) {
            //查询到了结果  执行update操作
            nextSqlString = sqlList[1];
        }else{
            //查询无结果  执行 insert into 操作
            nextSqlString = sqlList[2];
        }
        
        ret = [db executeUpdate:nextSqlString];
        if ([db hadError]) {
            block(NO,[db lastErrorMessage]);
            NSLog(@"da_error_%@",[db lastErrorMessage]);
        }else{
            block(ret, nil);
        }
    }];
    
}

// 根据查询到的model，删除／修改或者插入
//用事务，update，数组。根据查询结果 确定是更新还是新增操作，sqlList 是一个二维数组，每一个成员包含三个sql语句，分别是查询，更新，插入，并且根据查询结果返回是执行更新 还是 插入操作
//sql语句数组，sqlArr[i][0]：查询语句；sqlArr[i][1]：update语句；sqlArr[i][2]：insert into语句
- (void)executeDbQueue2RelevanceTransactionSqlList:(NSArray *)sqlList withBlock:(void(^)(BOOL bRet, NSString *msg, BOOL *bRollback))block{
    __block BOOL ret = NO;
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (NSArray * singleSqlList in sqlList ) {
            FMResultSet * rs = [db executeQuery:singleSqlList[0]];
            if ([db hadError]) {
                block(NO,[db lastErrorMessage],rollback);
                NSLog(@"da_error_%@",[db lastErrorMessage]);
            }else{
                int nCount = 0;
                while ([rs next]){
                    nCount  = [rs intForColumnIndex:0];
                }
                [rs close];
                
                NSString * nextSqlString = nil;
                if (nCount > 0){
                    //执行更新
                    nextSqlString = singleSqlList[1];
                }
                else{
                    //执行插入
                    nextSqlString = singleSqlList[2];
                }
                
                ret = [db executeUpdate:nextSqlString];
                if ([db hadError])
                {
                    block(NO, [db lastErrorMessage], rollback);
                    NSLog(@"executeSql Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
                }
            }
        }
        block(ret, nil, rollback);
    }];
}

//更新数据库
//注意：因为队列是串行执行的，因此inDatabase的block并不能嵌套使用，这样会导致错误。

- (void)updateDbVersion:(NSInteger)newVersion{
    //执行数据库更新
    [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [self getCurrentDbVersion:db withBlock:^(BOOL bRet, int version) {
            if (bRet && (newVersion > version || newVersion == 0) ) {
                //如果本地数据库版本需要升级
                [self executeUpdateSQLList:[self setSqliArray] withBlock:^(BOOL bRet, NSString *msg) {
                    if (bRet) {
                        //设置数据库版本号
                        [self setNewDbVersion:newVersion db:db withBlock:^(BOOL bRet) {
                            if (bRet)
                            {
                                NSLog(@"set new db version successfully!");
                            }
                        }];
                    }
                }];
            }
        }];
    }];
}

- (void)getCurrentDbVersion:(FMDatabase *)db withBlock:(void(^)(BOOL bRet,int version))block{
    NSString * sql = [NSString stringWithFormat:@"PRAGMA user_version"];
    FMResultSet * rs = [db executeQuery:sql];
    int nVersion = 0;
    while ([rs next]) {
        nVersion = [rs intForColumn:@"user_version"];
    }
    [rs close];
    if ([db hadError]) {
        NSLog(@"get db version Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        block(NO,-1);
        return;
    }
    block(YES,nVersion);
}

-(void)setNewDbVersion:(NSInteger)newVersion withBlock:(void(^)(BOOL bRet))block
{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"PRAGMA user_version = %ld",(long)newVersion];
        
        BOOL ret = [db executeUpdate:sql];
        
        if ([db hadError])
        {
            NSLog(@"get db version Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        }
        
        block(ret);
    }];
}

-(void)setNewDbVersion:(NSInteger)newVersion db:(FMDatabase *)db withBlock:(void(^)(BOOL bRet))block
{
    NSString *sql = [NSString stringWithFormat:@"PRAGMA user_version = %ld",(long)newVersion];
    
    BOOL ret = [db executeUpdate:sql];
    
    if ([db hadError])
    {
        NSLog(@"get db version Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }
    
    block(ret);
}

//插入创建表数组
- (NSArray *)setSqliArray{
    NSMutableArray * sqlList = @[].mutableCopy;
    [sqlList addObject:DB_CREATE_SCHOOL];
    return sqlList;
}


@end


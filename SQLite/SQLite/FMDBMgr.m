//
//  FMDBMgr.m
//  SQLite
//

#import "FMDBMgr.h"

#import <FMDB/FMDB.h>

FMDatabase *_db = nil;

NSString *dbDoc = @"DBDOC";
NSString *dbName = @"DataBase.db";
NSString *columnKeyStr = @"stringHistory";


@implementation FMDBMgr

// 获取数据库操作对象
+ (FMDatabase* )getDatabase{
    if (_db == nil)
    {
        _db = [FMDatabase databaseWithPath:[self createPathWithDataBase]];
        [_db open];
    }
    return _db;
}

#pragma mark - 创建数据库的路径--return path
+ (NSString *)createPathWithDataBase{
    NSString *Documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    NSString *path = [NSString stringWithFormat:@"%@/%@",Documents,dbDoc];
    
    // 创建存放原始图的文件夹--->Documents
    NSFileManager * fm = [NSFileManager defaultManager];
    //    判断有无文件夹
    if (![fm fileExistsAtPath:path]) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //    获取数据库path路径 -- xxx.db 为格式
    NSString *dbFilePath = [path stringByAppendingPathComponent:dbName];
    return dbFilePath;
}


#pragma mark - 数据库中建表
+ (void)createDBTableWithDBPath{
    _db = [self getDatabase];
    if ([_db open])
    {
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT NOT NULL, '%@'  VARCHAR(255));",dbName,columnKeyStr];
        [_db executeUpdate:sql];
        
    }
    [_db close];
}

#pragma mark - 插入数据
+ (BOOL)insertDataInfo:(NSString *)infod
{
    BOOL result=NO;
    if ([[self getDatabase] open])
    {
        NSString *updateStr = [NSString stringWithFormat:@"insert into %@ ('%@') values ('%@')",dbName,columnKeyStr,infod];
        if (![[self getDatabase] executeUpdate:updateStr]){
            result = NO;
            
        }else{
            result = YES;
        }
    }
    [[self getDatabase] close];
    return result;
}

#pragma mark - 查询All数据
+ (NSMutableArray *)getallMember
{
    NSMutableArray *allArr = [NSMutableArray array];
    
    if ([[self getDatabase] open])
    {
        NSString *sql = [NSString stringWithFormat:@"SELECT * from %@", dbName];
        FMResultSet *resultSet = [[self getDatabase] executeQuery:sql];
        while (resultSet.next)
        {
            NSString *str = [resultSet stringForColumn:[NSString stringWithFormat:@"%@",columnKeyStr]]; // 查询的数据与上面插入数据的key做对应
            
            [allArr addObject:str];
         
        }
    }
    [[self getDatabase] close];
    return allArr;
}

#pragma mark - 删除某个数据
+ (BOOL)deleteDBWith:(NSString *)uuid
{
    BOOL result = NO;
    if ([[self getDatabase] open])
    {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %@", dbName, columnKeyStr, uuid];
        result = [[self getDatabase] executeUpdate:sql];
    }
    [[self getDatabase] close];
    return result;
}
#pragma mark - 删除数据库
+ (BOOL)deleteDB
{
    BOOL result = NO;
    if  ([[self getDatabase] open])
    {
        NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@",dbName];
        if (![[self getDatabase] executeUpdate:sqlstr])
        {
            result = NO;
        }
        NSLog(@"删除表成功");
        result = YES;
    }
    [[self getDatabase] close];
    return result;
}


#pragma mark - 修改数据
+ (BOOL)updateDataInDB:(NSString *)uuid{
    BOOL result = NO;
    if  ([[self getDatabase] open]){
        NSString *sql = [NSString stringWithFormat:@"update %@ set %@ = '%@', where %@ = %@", dbName,@"Key",@"value", columnKeyStr, uuid];
        result = [[self getDatabase] executeUpdate:sql];
    }
    [[self getDatabase] close];
    return result;
}


//#pragma mark - 指定uuid查询
//+ (Member *)selectMember:(NSInteger)memid
//{
//    if ([[self getDatabase] open])
//    {
//        NSString *sql = [NSString stringWithFormat:@"select * from %@ where %@ = %lu", dbName ,columnKeyStr, uuid;
//
//        FMResultSet *resultSet = [_db executeQuery:sql];
//        while (resultSet.next)
//        {
//            Member *mem = [[Member alloc] initWithDic:
//                           @{@"memid":@([resultSet intForColumn:ID]),
//                             @"name":[resultSet stringForColumn:NAME],
//                             @"sex":[resultSet stringForColumn:SEX],
//                             @"qq":[resultSet stringForColumn:QQ],
//                             @"tel":[resultSet stringForColumn:TEL]
//                             }];
//            return mem;
//        }
//    }
//     [[self getDatabase] close];
//    return nil;
//}

@end




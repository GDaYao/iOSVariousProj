//
//  ViewController.m
//  SQLite
//


#import "ViewController.h"

#import <sqlite3.h>


static sqlite3 *_db; //是指向数据库的指针,我们其他操作都是用这个指针来完成

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}


#pragma mark -  Sqlite
// 1. 打开数据库
- (void)openSqlite{
    
    //1.打开数据库(如果指定的数据库文件存在就直接打开，不存在就创建一个新的数据文件)
    //参数1:需要打开的数据库文件路径(iOS中一般将数据库文件放到沙盒目录下的Documents下)
    NSString *nsPath = [NSString stringWithFormat:@"%@/Documents/Test.db", NSHomeDirectory()];
    const char *path = [nsPath UTF8String];
    
    //参数2:指向数据库变量的指针的地址
    //返回值:数据库操作结果
    int ret = sqlite3_open(path, &_db);
    
    //判断执行结果
    if (ret == SQLITE_OK) {
        NSLog(@"打开数据库成功");
    }else{
        NSLog(@"打开数据库失败");
    }
    
}


// 2. create table
- (void)createTable{
    //1.设计创建表的sql语句
    const char * sql = "CREATE TABLE IF NOT EXISTS t_Student(id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, score real DEFAULT 0, sex text DEFAULT '不明');";
    
    //2.执行sql语句
    //通过sqlite3_exec方法可以执行创建表、数据的插入、数据的删除以及数据的更新操作；但是数据查询的sql语句不能使用这个方法来执行
    //参数1:数据库指针(需要操作的数据库)
    //参数2:需要执行的sql语句
    //返回值:执行结果
    int ret = sqlite3_exec(_db, sql, NULL, NULL, NULL);
    
    //3.判断执行结果
    if (ret == SQLITE_OK) {
        NSLog(@"创建表成功");
    }else{
        NSLog(@"创建表失败");
    }
    
}


// 删除表格
- (void)deleteTable{
    const char *sql = "DROP TABLE if EXISTS t_Student;";
    int ret = sqlite3_exec(_db, sql, NULL, NULL, NULL);
    if (ret == SQLITE_OK) {
        NSLog(@"删除表格成功");
    } else {
        NSLog(@"删除表格失败");
    }
}

@end




//
//  UnionViewController.m
//  RemoteNoticAndYouMeng
//

#import "UnionViewController.h"

/*   UMeng使用   */
#import <UMAnalytics/MobClick.h> // UMeng统计

@interface UnionViewController ()

@end

@implementation UnionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
}

#pragma mark - 友盟调用封装使用方法

#pragma mark 页面时长统计
/*  页面时长统计    */
+ (void)UMengBeginLogPageViewWithName:(NSString *)pageName{
    if (pageName == nil || pageName.length == 0) {
        [MobClick beginLogPageView:NSStringFromClass(self)];
        
        return;
    }
    [MobClick beginLogPageView:pageName];
}
+ (void)UMengEndLogPageViewWithName:(NSString *)pageName{
    if (pageName == nil || pageName.length == 0) {
        [MobClick endLogPageView:NSStringFromClass(self)];
        
        return;
    }
    [MobClick endLogPageView:pageName];
}

#pragma mark 页面Crash收集统计
/*   页面Crash收集统计   */
+ (void)UMengSetCrashCollect:(BOOL)startOrClose{
    // SDK默认开启Crash收集机制，set NO 关闭收集
    [MobClick setCrashReportEnabled:startOrClose];
}

#pragma mark 账号统计
/*  账号统计 -- 若需要统计应用自身账号       */
+ (void)UMengCountStatistic{
    // PUID：用户账号ID.长度小于64字节
    // Provider：账号来源。不能以下划线"_"开头，使用大写字母和数字标识，长度小于32 字节 ;
    // 两种API任选其一接口：
    
    [MobClick profileSignInWithPUID:@"UserID"];
    
    //[MobClick profileSignInWithPUID:@"UserID" provider:@"WB"];
}
+ (void)UMengSendCountContent{
    // Signoff调用后，不再发送账号内容。
    [MobClick profileSignOff];
}


#pragma mark 自定义事件
/*  自定义事件
 
 
 id， ts， du是保留字段，不能作为event id及key的名称
 // 计数事件 -- 使用计数事件需要在后台添加事件时选择“计数事件”
 // 计算事件 -- 使用计算事件需要在后台添加事件时选择“计算事件”。
 **/


// 统计发生次数 -- eventId 为当前统计的事件ID。
+ (void)UMengStatisticsEvent:(NSString *)eventId{
    [MobClick event:eventId];
}
// 统计点击行为各属性被触发的次数
+ (void)UMengStatisticsActionTraggerEvent:(NSString *)eventId withAttributes:(NSDictionary *)attributes{
    [MobClick event:eventId attributes:attributes];
    /** ex
    NSDictionary *dict = @{@"type" : @"book", @"quantity" : @"3"};
    [MobClick event:@"purchase" attributes:dict];
     */
}

// 统计数值型变量的值的分布
+ (void)UMengStatisticsNumVariableEvent:(NSString *)eventId withAttributes:(NSDictionary *)attributes withCounter:(int)num{
    
    [MobClick event:eventId attributes:attributes counter:num];
    /** ex
     购买《Swift Fundamentals》这本书，花了110元
     [MobClick event:@"pay" attributes:@{@"book" : @"Swift Fundamentals"} counter:110];
     */
}
//统计点击次数及各属性触发次数
+ (void)UMengStatisticsTapCountAndActionTriggerCount:(NSString *)event{
    
}

// 事件属性 -- 注：属性中的key－value必须为String类型, 每个应用至多添加500个自定义事件，key不能超过10个.
+ (void)UMengStaticsticsEvnetAttributes{
    
    /** ex
     
     // 例如下面代码pruchase为事件ID，而type，quantity为属性信息。
     NSDictionary *dict = @{@"type" : @"book", @"quantity" : @"3"};
     [MobClick event:@"purchase" attributes:dict];
     
     // [MobClick event:@"pay" attributes:@{@"book" : @"Swift Fundamentals"} counter:110];
     */
}












/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/







@end






//
//  WeChatPayViewController.m
//  PaymentRealization

#import "WeChatPayViewController.h"

#import "WXApi.h"


#import <GDYSDK/NetworkMgr.h>

#define WeChatPay_URL @"http://www.baidu.com"

static NSString *WXReturnSucceedPayNotification = @"WXReturnSucceedPayNotification";
static NSString *WXReturnFailedPayNotification = @"WXReturnFailedPayNotification";

@interface WeChatPayViewController ()

@end

@implementation WeChatPayViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}


#pragma mark - config ui
- (void)configUI{
    UIButton *alipayBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 100, 200, 50)];
    [self.view addSubview:alipayBtn];
    [alipayBtn setTitle:@"微信支付" forState:UIControlStateNormal];
    [alipayBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [alipayBtn addTarget:self action:@selector(weChatPay) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 微信支付封装请求

- (void)weChatPay {
    
    // 1.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderid"] = @"";   //  // 获得订单号
    params[@"userIp"] =  @"" ;  // // 获取当前设备的ip
    
    // 2.发送请求
    [NetDataMgr AFHttpDataTaskPostMethodWithURLString:WeChatPay_URL parameters:params success:^(id  _Nullable responseObject) {
        NSLog(@"log--微信支付返回参数接口 请求成功-%@",responseObject);
        if ([responseObject[@"success"] isEqual:@(YES)]) {
            // json[@"data"];
            NSMutableDictionary *wechatDic = @{@"":@"", @"":@"", @"":@"", }.mutableCopy;
            
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = [wechatDic objectForKey:@"mch_id"]; // 商家向财付通申请的商家id
            request.prepayId= [wechatDic objectForKey:@"prepay_id"]; // 支付订单
            request.package = @"Sign=WXPay"; // Sign=WXPay 商家根据财付通文档填写的数据和签名
            request.nonceStr= [wechatDic objectForKey:@"nonce_str"]; // 随机串，防重发
            request.timeStamp= [[wechatDic objectForKey:@"timestamp"] intValue]; //时间戳，防重发
            request.sign = [wechatDic objectForKey:@"sign2"]; // 商家根据微信开放平台文档对数据做的签名 二次签名
            
            if ([WXApi sendReq:request]) {
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wechatPaySuccessed) name:WXReturnSucceedPayNotification object:nil];
                [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(wechatPayFailed) name:WXReturnFailedPayNotification object:nil];
            } else {
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"支付失败" message:@"未安装微信客户端,请使用其他支付方式" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        }else{
            NSLog(@"log--showError:%@",responseObject[@"errorMessage"]);
        }
        
    } failure:^(NSError * _Nullable error) {
        NSLog(@"log--微信支付返回参数接口 请求失败-%@",error);
    }];
}

- (void)wechatPaySuccessed{
    NSLog(@"log--微信支付成功");
}
- (void)wechatPayFailed{
    NSLog(@"log--微信支付失败");
}

//
//#pragma mark - 微信支付主要请求方法
//- (void)wechatPayRequest{
//    // 调起微信支付
//    PayReq *request = [[PayReq alloc] init];
//    /** 微信分配的公众账号ID -> APPID */
//    request.partnerId = @"你的APPID";
//    /** 预支付订单 从服务器获取 */
//    request.prepayId = @"1101000000140415649af9fc314aa427";
//    /** 商家根据财付通文档填写的数据和签名 <暂填写固定值Sign=WXPay>*/
//    request.package = @"Sign=WXPay";
//    /** 随机串，防重发 */
//    request.nonceStr= @"a462b76e7436e98e0ed6e13c64b4fd1c";
//    /** 时间戳，防重发 */
//    request.timeStamp= 1397527777;
//    /** 商家根据微信开放平台文档对数据做的签名, 可从服务器获取，也可本地生成*/
//    request.sign= @"582282D72DD2B03AD892830965F428CB16E7A256";
//    /* 调起支付 */
//    [WXApi sendReq:request];
//}







@end



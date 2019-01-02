//
//  AliPayViewController.m
//  PaymentRealization

#import "AliPayViewController.h"
#import <AlipaySDK/AlipaySDK.h>


#import <GDYSDK/NetworkMgr.h>



// macro define
#define AliReturnSucceedPayNotification @"AliReturnSucceedPayNotification"
#define AliReturnFailedPayNotification @"AliReturnFailedPayNotification"


#define AlipayURL @"http://www.baidu.com"
#define AppScheme @"alisdkdemo"

@interface AliPayViewController ()

@end

@implementation AliPayViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self configUI];
}


#pragma mark - config ui
- (void)configUI{
    UIButton *alipayBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 100, 200, 50)];
    [self.view addSubview:alipayBtn];
    [alipayBtn setTitle:@"支付宝支付" forState:UIControlStateNormal];
    [alipayBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    [alipayBtn addTarget:self action:@selector(alipayUse) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - Alipay
- (void)alipayUse{
    //    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //params[@"orderNo"] = @"xxxx-订单号"; // 订单号
    //params[@"realAmt"] =  [NSString stringWithFormat:@"%.2lf", @"xxxx-金额"]; // 金额
    NSDictionary *params = @{@"orderNo":@"订单号",
                                    @"realAmt":@"100.0"
                                    };
    // network request
    [NetDataMgr AFHttpDataTaskPostMethodWithURLString:AlipayURL parameters:params success:^(id  _Nullable responseObject) {
        
        if ([responseObject[@"success"] isEqual:@(YES)]) {
            NSDictionary *json = responseObject[@"data"];
            
            // 返回生成订单信息及签名
            NSString *orderInfoEncoded = json[@"orderInfo"];
            NSString *signedString = json[@"sign"];
            
            // NOTE: 如果加签成功，则继续执行支付
            if (signedString != nil) {
                // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
                NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                         orderInfoEncoded, signedString, @"RSA"];

                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService]payOrder:orderString fromScheme:AppScheme callback:^(NSDictionary *resultDic) {
                    if([resultDic[@"resultStatue"] intValue] == 9000) {
                        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alipaySuccessed) name:AliReturnSucceedPayNotification object:nil];
                    }else{
                        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(alipayFailed) name:AliReturnFailedPayNotification object:nil];
                    }
                }];
                
            }
            
        } else {
            NSLog(@"log--showError:%@",responseObject[@"errorMessgae"]);
        }
        
    } failure:^(NSError * _Nullable error) {
        NSLog(@"log--支付宝支付错误-%@",error);
    }];
}


#pragma mark 支付成功
- (void)alipaySuccessed{
    NSLog(@"log--支付成功");
}
#pragma mark 支付失败
- (void)alipayFailed{
    NSLog(@"log--支付失败");
}











@end





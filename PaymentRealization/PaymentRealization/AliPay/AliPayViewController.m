//
//  AliPayViewController.m
//  PaymentRealization

#import "AliPayViewController.h"
#import <AlipaySDK/AlipaySDK.h>


@interface AliPayViewController ()

@end

@implementation AliPayViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - config ui
- (void)configUI{
    
}


#pragma mark - Alipay
- (void)alipayUse{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = self.orderNo; // 订单号
    params[@"realAmt"] =  [NSString stringWithFormat:@"%.2lf", self.realAmt]; // 金额
    
    __weak __typeof(self) weakSelf = self;
    [HttpTool post:QTX_aliPay_url params:params success:^(id json) {
        QTXLog(@"支付宝支付返回参数接口 请求成功-%@", json);
        
        if ([json[@"success"] isEqual:@(YES)]) {
            
            // 返回生成订单信息及签名
            NSString *signedString = json[@"data"][@"sign"];
            NSString *orderInfoEncoded = json[@"data"][@"orderInfo"];
            
            // NOTE: 如果加签成功，则继续执行支付
            if (signedString != nil) {
                // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
                //                NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@&sign_type=RSA", orderInfoEncoded, signedString];
                NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                         orderInfoEncoded, signedString, @"RSA"];
                
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:XHHAppScheme callback:^(NSDictionary *resultDic) {
                    QTXLog(@"reslut = %@",resultDic);
                    
                    if ([resultDic[@"resultStatus"] intValue] == 9000) {
                        
                        [QTXNotificationCenter addObserver:self selector:@selector(paySucceed) name:QTXWXReturnSucceedPayNotification object:nil];
                    } else {
                        
                        [QTXNotificationCenter addObserver:self selector:@selector(payFailed) name:QTXWXReturnFailedPayNotification object:nil];
                    }
                }];
                
            }
            
        } else {
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@", json[@"errorMessage"]]];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:@"暂无网络，稍后再试"];
        QTXLog(@"支付宝支付返回参数接口 请求失败-%@", error);
    }];
    
    
}




@end

//
//  WXApiMgr.m
//  PaymentRealization

#import "WXApiMgr.h"
#import "WXApi.h"


static NSString *WXReturnSucceedPayNotification = @"WXReturnSucceedPayNotification";
static NSString *WXReturnFailedPayNotification = @"WXReturnFailedPayNotification";

@interface WXApiMgr () <WXApiDelegate>

@end

@implementation WXApiMgr

//单例类的静态实例对象，因对象需要唯一性，故只能是static类型
static WXApiMgr *defaultManager = nil;
+ (WXApiMgr *)sharedManager{
    static dispatch_once_t token;
     dispatch_once(&token, ^{
        if(defaultManager == nil)
            {
                defaultManager = [[self alloc] init];
            }
        });
    return defaultManager;
}



#pragma mark - Wechat  delegate method
/*
 *  是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
 */
- (void) onReq:(BaseReq*)reqonReq{
    
}
/**
 * 如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
 */
- (void) onResp:(BaseResp*)resp{
    
    /**
     *  支付 call
     * 注意:  一定不能以客户端返回作为用户支付的结果，应以服务器端的接收的支付通知或查询API返回的结果为准
     * 0    成功    展示成功页面
     * -1    错误    可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等。
     * -2    用户取消    无需处理。发生场景：用户不支付了，点击取消，返回APP。
     */
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response = (PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                // 发通知带出支付成功结果
                [[NSNotificationCenter defaultCenter] postNotificationName:WXReturnSucceedPayNotification object:resp];
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                // 发通知带出支付失败结果
                [[NSNotificationCenter defaultCenter] postNotificationName:WXReturnFailedPayNotification object:resp];
                break;
        }
    } // if pay case.
    
}



@end

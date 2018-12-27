//
//  WeiboSDKVCDelegate.m
//  iOSLogin
//


#import "WeiboSDKVCDelegate.h"



#import "WeiboSDK.h"

@interface WeiboSDKVCDelegate () <WeiboSDKDelegate>

@end

@implementation WeiboSDKVCDelegate




/**
 收到一个来自微博客户端程序的请求
 
 收到微博的请求后，第三方应用应该按照请求类型进行处理，处理完后必须通过 [WeiboSDK sendResponse:] 将结果回传给微博
 @param request 具体的请求对象
 */
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{ //向微博发送请求
    NSLog(@" %@",request.class);
}

#pragma mark - didReceiveWeiboResponse
/**
 微博分享  与 微博登录，成功与否都会走这个方法。 用户根据自己的业务进行处理。
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    NSLog(@"log--didReceiveWeiboResponse:%@",response);

        // 此代理方法不可使用 -- 由于AppDelegate中的调用对象和被回调控制器中的对象属于同一个类但不同属于同一对象造成
//        if ([_weiboDelegate respondsToSelector:@selector(weiboLoginByResponse:)]) {
//            [_weiboDelegate weiboLoginByResponse:response];
//        }
    
    // 分享时回调使用
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"didReceiveWeiboWBSendMessageToWeiboResponse" object:response];
        
//        NSString *title = NSLocalizedString(@"发送结果", nil);
//        NSString *message = [NSString stringWithFormat:@"%@: %d\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode, NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil),response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        WBSendMessageToWeiboResponse* sendMessageToWeiboResponse = (WBSendMessageToWeiboResponse*)response;
//        NSString* accessToken = [sendMessageToWeiboResponse.authResponse accessToken];
//        if (accessToken)
//        {
//            self.wbtoken = accessToken;
//        }
//        NSString* userID = [sendMessageToWeiboResponse.authResponse userID];
//        if (userID) {
//            self.wbCurrentUserID = userID;
//        }
//        [alert show];
            
    } // 登录时回调使用
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        
        // 发送登录成功或者失败或者某种情况的通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"didReceiveWeiboResponseInWBAuthorizeResponse" object:response];
        
        //        NSString *title = NSLocalizedString(@"认证结果", nil);
        //
        //        // request/response string
        //        NSString *message = [NSString stringWithFormat:@"%@: %d\nresponse.userId: %@\nresponse.accessToken: %@\n%@: %@\n%@: %@", NSLocalizedString(@"响应状态", nil), (int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken],  NSLocalizedString(@"响应UserInfo数据", nil), response.userInfo, NSLocalizedString(@"原请求UserInfo数据", nil), response.requestUserInfo];
        // alert show
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//
//        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"出现错误"
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
}





@end



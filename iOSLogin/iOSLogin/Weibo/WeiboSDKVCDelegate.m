//
//  WeiboSDKVCDelegate.m
//  iOSLogin
//


#import "WeiboSDKVCDelegate.h"



@interface WeiboSDKVCDelegate () 

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

/**
 
 微博分享  与 微博登录，成功与否都会走这个方法。 用户根据自己的业务进行处理。
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    if ([response isKindOfClass:WBAuthorizeResponse.class])  //用户登录的回调
    {
        
        if ([_weiboDelegate respondsToSelector:@selector(weiboLoginByResponse:)]) {
            [_weiboDelegate weiboLoginByResponse:response];
        }
    }
}



@end



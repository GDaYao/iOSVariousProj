//
//  WeiboSDKVCDelegate.h
//  iOSLogin
//


#import <Foundation/Foundation.h>

#import "WeiboSDK.h"

@protocol WeiboSDKVCDelegateDelegate <NSObject>

//登录的代理
-(void)weiboLoginByResponse:(WBBaseResponse *)response;
//分享的代理
-(void)weiboShareSuccessCode:(NSInteger)shareResultCode;
@end



NS_ASSUME_NONNULL_BEGIN

@interface WeiboSDKVCDelegate : NSObject <WeiboSDKDelegate>


@property (weak  , nonatomic) id<WeiboSDKVCDelegateDelegate> weiboDelegate;

@end

NS_ASSUME_NONNULL_END





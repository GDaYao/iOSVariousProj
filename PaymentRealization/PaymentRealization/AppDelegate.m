//
//  AppDelegate.m
//  PaymentRealization


#import "AppDelegate.h"

#import "WXApiMgr.h"
#import <AlipaySDK/AlipaySDK.h>


static NSString *AliReturnSucceedPayNotification = @"AliReturnSucceedPayNotification";
static NSString *AliReturnFailedPayNotification = @"AliReturnFailedPayNotification";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //向微信注册
    [WXApi registerApp:@"wxd930ea5d5a258f4f"]; // Wechat app id.
    
    
    return YES;
}



#pragma mark - Wechat use
/**
 这里处理微信/支付宝支付完成之后跳转回来
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    // 微信的支付回调
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:[WXApiMgr sharedManager]];
    }
    
    // 支付宝
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"支付宝客户端支付结果result = %@",resultDic);
            if (resultDic && [resultDic objectForKey:@"resultStatus"] && ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000)) {
                
                // 发通知带出支付成功结果
                [[NSNotificationCenter defaultCenter] postNotificationName:AliReturnSucceedPayNotification object:resultDic];
            } else {
                
                // 发通知带出支付失败结果
                [[NSNotificationCenter defaultCenter] postNotificationName:AliReturnFailedPayNotification object:resultDic];
            }
            
        }];
    }
    
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"支付宝网页版result = %@",resultDic);
            if (resultDic && [resultDic objectForKey:@"resultStatus"] && ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000)) {
                
                // 发通知带出支付成功结果
                [[NSNotificationCenter defaultCenter] postNotificationName:AliReturnSucceedPayNotification object:resultDic];
            } else {
                
                // 发通知带出支付失败结果
                [[NSNotificationCenter defaultCenter] postNotificationName:AliReturnFailedPayNotification object:resultDic];
            }
        }];
    }
    
    return YES;
}
// 注意: iOS 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // 微信的支付回调
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:[WXApiMgr sharedManager]];
    }
    
    /**
     支付宝
     */
    //如果极简 SDK 不可用,会跳转支付宝钱包进行支付,需要将支付宝钱包的支付结果回传给 SDK
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"支付宝客户端支付结果result = %@",resultDic);
            if (resultDic && [resultDic objectForKey:@"resultStatus"] && ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000)) {
                
                // 发通知带出支付成功结果
                [[NSNotificationCenter defaultCenter] postNotificationName:AliReturnSucceedPayNotification object:resultDic];
            } else {
                
                // 发通知带出支付失败结果
                [[NSNotificationCenter defaultCenter] postNotificationName:AliReturnFailedPayNotification object:resultDic];
            }
        }];
    }
    
    if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回 authCode
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"支付宝网页版result = %@",resultDic);
            if (resultDic && [resultDic objectForKey:@"resultStatus"] && ([[resultDic objectForKey:@"resultStatus"] intValue] == 9000)) {
                
                // 发通知带出支付成功结果
                [[NSNotificationCenter defaultCenter] postNotificationName:AliReturnSucceedPayNotification object:resultDic];
            } else {
                
                // 发通知带出支付失败结果
                [[NSNotificationCenter defaultCenter] postNotificationName:AliReturnFailedPayNotification object:resultDic];
            }
        }];
    }
    
    
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

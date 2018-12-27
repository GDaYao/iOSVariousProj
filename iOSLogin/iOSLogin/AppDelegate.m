//
//  AppDelegate.m
//  iOSLogin


#import "AppDelegate.h"

/* QQ */
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "QQApiShareEntry.h"

/*  weibo   */

// 1. import
#import "WeiboSDK.h"
#import "WeiboSDKVCDelegate.h"

/*  wechat    */
#import "WXApi.h"
#import "WeChatHandleURLDelegate.h"


#define kSinaweiboAppKey @"596217426" // App secret: 5a58656b9c7d38f684cecfb00f282976
//#define kSinaweiboAppKey @"2045436852"  //weibo Demo 测试

@interface AppDelegate ()

@end



@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    
    /*   register  weibo   */
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kSinaweiboAppKey];
    
    /*   register  wechat   */
    [WXApi registerApp:@"wxd930ea5d5a258f4f"];
    
    
    return YES;
}

#pragma mark - QQ 登录
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    NSLog(@"log-- xxx openURL:xxx");
    
    /*  微博登录和分享    */
    if ([WeiboSDK handleOpenURL:url delegate:(id<WeiboSDKDelegate>)[WeiboSDKVCDelegate class]]) {
        return YES;
    }
    
    /*  QQ登录和分享    */
    if (YES == [TencentOAuth CanHandleOpenURL:url])
    {
        [QQApiInterface handleOpenURL:url delegate:[[QQApiShareEntry alloc]init] ];  // (id<QQApiInterfaceDelegate>)[QQApiShareEntry class]
        
        // 可以处理返回的URL请求 -- 和登录成功和分享成功没有关系
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Where from" message:url.description delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alertView show];
        return [TencentOAuth HandleOpenURL:url];
    }
    return YES;
}

#pragma mark - 微博登录 + 微信登录 使用
/*  微博登录使用 -- 必须使用下面方法 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"log-- xxx openURL:xxx sourceApplication:xxx annotation:xxx");
    
    /*  微信登录和分享    */
    if ([WXApi handleOpenURL:url delegate:[[WeChatHandleURLDelegate alloc]init]]) {
        return YES;
    }
    
    
    /*  微博登录和分享    */
    if ([WeiboSDK handleOpenURL:url delegate:[[WeiboSDKVCDelegate alloc]init]]) {
        return YES;
    }
 
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    NSLog(@"log-- xxx handleOpenURL:xxx");
    
    /*  微信登录和分享    */
    if ([WXApi handleOpenURL:url delegate:[[WeChatHandleURLDelegate alloc]init]]) {
        return YES;
    }
    
    /*  微博登录和分享    */
    if ([WeiboSDK handleOpenURL:url delegate:[[WeiboSDKVCDelegate alloc]init]]) {
        return YES;
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

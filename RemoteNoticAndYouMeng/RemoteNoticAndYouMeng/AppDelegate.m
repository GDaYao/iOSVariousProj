//
//  AppDelegate.m
//  RemoteNoticAndYouMeng
//

#import "AppDelegate.h"

#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()

@end

@implementation AppDelegate




#pragma mark - didFinishLaunchingWithOptions
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    /*   本地通知+远程通知-1-注册+处理杀死应用下的通知       */
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 8.0) {
        // 向服务器发请求，要注册推送功能，以此获取到服务器返回的deviceToken
        // type 用来说明 支持的通知形式
        // 如: 横幅 声音  角标
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge| UIUserNotificationTypeSound|UIUserNotificationTypeAlert  categories:nil];
        [application registerUserNotificationSettings:settings];
        // 申请使用远程通知
        [application registerForRemoteNotifications];
        
        // 进行通知的相应处理
        [self initNoticWithDic:launchOptions];
    }
    
    
    NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 40, 300, 200);
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:24];
    label.backgroundColor = [UIColor blueColor];
    label.text =[NSString stringWithFormat:@"%@",userInfo];
    [self.window.rootViewController.view addSubview:label];
    
    NSLog(@"log--didFinishLaunchingWithOptions");
    
    return YES;
}

#pragma mark - 通知的初始化和 `点击通知` 的逻辑调用 --- 在程序被杀死的情况下调用否则未被杀死调用下面的方法
- (void)initNoticWithDic:(NSDictionary *)launchOptions{
// Method--1
    if ([[launchOptions allKeys]containsObject:UIApplicationLaunchOptionsRemoteNotificationKey]) {
        // 判断发送远程通知点击进入
    }else if ([[launchOptions allKeys]containsObject:UIApplicationLaunchOptionsLocalNotificationKey]) {
        // 通过本地通知点击进入
    }else{
        // 正常进入程序
    }
    
// Method--2--UNUserNotificationCenter另一种注册通知方法的使用
    if(@available(iOS 10.0,*)){
        UNUserNotificationCenter *noticCenter = [UNUserNotificationCenter currentNotificationCenter];
        [noticCenter requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"notic-通知开启");
            } else {
                NSLog(@"notic-关闭通知");
            }
        }];
        [noticCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"notic-settings-%@", settings);
        }];
    }
    
}

/**
 *  1. 查看注册成功的通知类型
 *  2. 拿到注册结果进行自定义操作（获取发送通知权限失败予以提示）
 */
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    // 如果点击允许发送通知则 `notificationSettings.type`有值，否则其值为0
    if (notificationSettings.types && UIUserNotificationTypeBadge) {
        NSLog(@"Badge Nofitication type is allowed");
    }
    if (notificationSettings.types && UIUserNotificationTypeAlert) {
        NSLog(@"Alert Notfication type is allowed");
    }
    if (notificationSettings.types && UIUserNotificationTypeSound) {
        NSLog(@"Sound Notfication type is allowed");
    }
    
}


#pragma mark -

//只要获取到用户同意，则服务器端返回deviceToken
//会自动执行下面的方法
//  dcb06206 6c4f2df5 448a033f 21464cc7 0e3b17e5 0edfdad5 ee09b56c 7559c4b1
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"log--didRegisterForRemoteNotificaionWith:%@",deviceToken);
}


/*
 用户点击了通知，进入到应用程序中，需要捕获到这个时机
 从而决定这一次的进入应用程序，到底要显示或执行什么动作，下面的方法就会在点击通知时自动调用
 */
/*
 1.应用程序在前台时：通知到，该方法自动执行
 2.应用程序在后台且没有退出时：通知到，只有点击了通知查看时，该方法自动执行
 3.应用程序退出：通知到，点击查看通知，不会执行下面的didReceive方法，而是只执行didFinishLauncing方法
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"log--didReceiveRemote:%@",userInfo);
    
    //为了测试在应用程序退出后，该方法是否执行
    //所以往第一个界面上添加一个label，看标签是否会显示一些内容
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 250, 300, 200);
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:24];
    label.backgroundColor = [UIColor grayColor];
    label.text =[NSString stringWithFormat:@"%@",userInfo];
    [self.window.rootViewController.view addSubview:label];
}

/*
 此方法是新的用于响应远程推送通知的方法
 1.如果应用程序在后台，则通知到，点击查看，该方法自动执行
 2.如果应用程序在前台，则通知到，该方法自动执行
 3.如果应用程序被关闭，则通知到，点击查看，先执行didFinish方法，再执行该方法
 4.可以开启后台刷新数据的功能
 step1：点击target-->Capabilities-->Background Modes-->Remote Notification勾上
 step2：在给APNs服务器发送的要推送的信息中，添加一组字符串如：
 {"aps":{"content-available":"999","alert":"bbbbb.","badge":1}}
 其中content-availabel就是为了配合后台刷新而添加的内容，999可以随意定义
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"log--didReceiveRemoteNotification");
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, 250, 300, 200);
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:24];
    label.backgroundColor = [UIColor grayColor];
    label.text =[NSString stringWithFormat:@"%@",userInfo];
    [self.window.rootViewController.view addSubview:label];
    //NewData就是使用新的数据 更新界面，响应点击通知这个动作
    completionHandler(UIBackgroundFetchResultNewData);
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

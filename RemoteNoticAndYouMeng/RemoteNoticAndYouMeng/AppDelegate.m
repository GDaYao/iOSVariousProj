//
//  AppDelegate.m
//  RemoteNoticAndYouMeng
//

#import "AppDelegate.h"

#import <UserNotifications/UserNotifications.h>


// 极光推送

// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

/*
 // 如果需要使用 idfa 功能所需要引入的头文件（可选）
 */
 #import <AdSupport/AdSupport.h>


/// test config
static NSString *appKey = @"192f62b7fcda8ad8de342db2";
static NSString *channel = @"APP Store";

#ifdef DEBUG
// 开发 极光FALSE为开发环境
static BOOL const  isProduction = FALSE;
#else
// 生产 极光TRUE为生产环境
static BOOL const  isProduction = TRUE;
#endif




@interface AppDelegate () <JPUSHRegisterDelegate,JPUSHGeofenceDelegate>

@end

@implementation AppDelegate




#pragma mark - didFinishLaunchingWithOptions
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSLog(@"log--didFinishLaunchingWithOptions");


    /*   本地通知+远程通知-1-注册+处理杀死应用下的通知
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
     */
    

/*  极光推送    */
    // 极光推送-1. 添加初始化 APNs 代码
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //      NSSet<UNNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
        //    else {
        //      NSSet<UIUserNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
    }
    // 设置代理
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService registerLbsGeofenceDelegate:self withLaunchOptions:launchOptions];
    
    /** 极光推送-2. 添加初始化 JPush 代码
     */
    
    // Optional
    // 获取 IDFA
    // 如需使用 IDFA 功能请添加此代码并在初始化方法的 advertisingIdentifier 参数中填写对应值
    // 如不需要使用IDFA，advertisingIdentifier 可为nil
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    // 如需继续使用 pushConfig.plist 文件声明 appKey 等配置内容，请依旧使用 [JPUSHService setupWithOption:launchOptions] 方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil]; // advertisingId
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
            
        }
        else{
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    
    
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
    
    /* 极光推送-3  Required - 注册 DeviceToken*/
    [JPUSHService registerDeviceToken:deviceToken];
    
    
}

// 实现注册 APNs 失败接口（可选)
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"log--did Fail To Register For Remote Notifications With Error: %@", error);
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
    
    /*  极光推送-4  fetchCompletionHandler  */
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
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
    
   /*   极光推送-5  Required, For systems with less than or equal to iOS 6   */
    [JPUSHService handleRemoteNotification:userInfo];
    
}




#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}


#pragma mark - Application life cycle

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

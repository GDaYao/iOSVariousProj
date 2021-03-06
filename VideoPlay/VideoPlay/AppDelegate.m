//
//  AppDelegate.m
//  VideoPlay

#import "AppDelegate.h"

#import "ViewController.h"

// import AVFoundation to play in background mode.
#import <AVFoundation/AVFoundation.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    ViewController *vc = [[ViewController alloc]init];
    UINavigationController *mainNav = [[UINavigationController alloc]initWithRootViewController:vc];
    self.window.rootViewController = mainNav;
    [self.window makeKeyAndVisible];
    
    /// TODO: 1-4 set background play mode + 设置 Info.plist + 设置 Capabilities 
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];  // AVAudioSessionCategoryPlayback 不可与其它App同时播放
    [audioSession setActive:YES error:nil];         // 静音状态下播放
    // 用于出现系统服务直接中断当前进程进行相应的程序处理。
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appAVAudioPlayInterruptted:) name:@"AVAudioSessionInterruptionNotification" object:nil];
    
    
    
    return YES;
}
//  support interface
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskAll;
}


#pragma mark - 2-4-remote control event -- 外部控制接收事件
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"RemoteControlReceivedEvent" object:nil userInfo:@{@"event":event}];
}
- (void)appAVAudioPlayInterruptted:(NSNotification *)notification{
//    UIEvent *event = notification.userInfo[@"xxx"];
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





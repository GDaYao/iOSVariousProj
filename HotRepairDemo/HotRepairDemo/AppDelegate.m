////  AppDelegate.m
//  HotRepairDemo
//
//  Created on 2020/1/12.
//  Copyright © 2020 dayao. All rights reserved.
//

#import "AppDelegate.h"
#import "HotTestViewController.h"


//  TODO: lua-wax use
#import <wax/wax.h>


@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // TODO: wax-use wax hot repair
    wax_start("nil", nil);
    // blow two line code to debug.
    extern void luaopen_mobdebug_scripts(void *L);
    //luaopen_mobdebug_scripts(wax_currentLuaState());
    
    
    
    // TODO: main window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    HotTestViewController *testVC = [[HotTestViewController alloc]init];
    
    self.window.rootViewController = testVC;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}





/*
#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}
*/

@end

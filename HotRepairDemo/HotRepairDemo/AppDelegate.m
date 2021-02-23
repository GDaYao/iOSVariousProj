////  AppDelegate.m
//  HotRepairDemo
//
//  Created on 2020/1/12.
//  Copyright © 2020 dayao. All rights reserved.
//

#import "AppDelegate.h"
#import "HotTestViewController.h"

#import <wax/wax.h>

@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    
    // TODO: main window
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    
    // TODO: init lua wax
    [self initLuaWax];
    
    HotTestViewController *testVC = [[HotTestViewController alloc]init];
    self.window.rootViewController = testVC;
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


#pragma mark - lua-wax
- (void)initLuaWax {
    
    wax_start(nil, nil);
    
    //
    NSString *path = [[NSBundle mainBundle]pathForResource:@"HotPatchTest" ofType:@"lua"];
    int result = wax_runLuaFile([path UTF8String]);
    NSLog(@"log-result-%d",result);
    if (result) {
        NSLog(@"log-error=%s",lua_tostring(wax_currentLuaState(), -1));
    }
    
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

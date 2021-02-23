////  HotTestViewController.m
//  HotRepairDemo
//
//  Created on 2020/5/14.
//  Copyright © 2020 dayao. All rights reserved.
//

#import "HotTestViewController.h"



// TODO: wax-lua
#import <wax/wax.h>


// To add wax with extensions,use this line instead.
#import <wax/wax_http.h>
#import <wax/wax_json.h>
#import <wax/wax_filesystem.h>




@interface HotTestViewController ()



@end

@implementation HotTestViewController


- (void)viewDidLoad {
    [super viewDidLoad];


    [self setUpUi];
    
    [self createUIInVC];
}



#pragma mark - createUIInVC
- (void)createUIInVC {

    //[self initWax];
    
    //[self addWaxCodeTest];
    
    //[self runLuaFileScript];

}

#pragma mark - set up ui
- (void)setUpUi {
    self.view.backgroundColor = [UIColor redColor];
    
}


#pragma mark -
#pragma mark - init wax
- (void)initWax {
    
    wax_start(nil, nil);
    
    //
    //
    
    // blow two line code to debug.
    extern void luaopen_mobdebug_scripts(void *L);
    //luaopen_mobdebug_scripts(wax_currentLuaState());
}

#pragma mark wax add wax file test
- (void)addWaxCodeTest {
    
//    wax_start("init.lua", nil);
//    // blow two line code to debug.
//    extern void luaopen_mobdebug_scripts(void *L);
//    luaopen_mobdebug_scripts(wax_currentLuaState());
    
    wax_runLuaString("print('hello wax')");
    
    
    NSLog(@"log-调用-%s",__func__);
    
    
}

#pragma mark run lua file scripts -- 使用wax_runLuaFile执行脚本
- (void)runLuaFileScript {
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"HotTestViewControllerLuaWax.lua" ofType:@""];
    
    int i = wax_runLuaFile(path.UTF8String);
    if (i) {
        NSLog(@"log-error=%s",lua_tostring(wax_currentLuaState(), -1));
    }
}







@end

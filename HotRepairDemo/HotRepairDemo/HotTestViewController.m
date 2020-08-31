////  HotTestViewController.m
//  HotRepairDemo
//
//  Created on 2020/5/14.
//  Copyright © 2020 dayao. All rights reserved.
//

#import "HotTestViewController.h"


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
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self createUIInVC];
}




#pragma mark - createUIInVC
- (void)createUIInVC {
    

    [self addWaxCodeTest];
    
}




#pragma mark - add wax file test
- (void)addWaxCodeTest {
    
    // TODO:start
    wax_start("init.lua", nil);
    
    wax_runLuaString("print('hello wax')");
    
    
    //
    
    
    
    
    
    NSLog(@"log-调用-%s",__func__);
    
    
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end

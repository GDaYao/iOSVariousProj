////  ViewController.m
//  AlphaVideoPlayExport
//
//  Created on 2020/8/28.
//  Copyright © 2020 dayao. All rights reserved.
//

#import "ViewController.h"


#import "AlphaVideoPlayExportViewController.h"

@interface ViewController ()

@end

@implementation ViewController


#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"点击" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    nextBtn.layer.borderColor = [UIColor redColor].CGColor;
    nextBtn.layer.borderWidth = 1.0;
    [self.view addSubview:nextBtn];
    nextBtn.frame = CGRectMake(50, 100, 80, 80);
    [nextBtn addTarget:self action:@selector(tapNextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}



#pragma mark - action
- (void)tapNextBtnAction {

    
    AlphaVideoPlayExportViewController *nextAlphaPlayVC = [[AlphaVideoPlayExportViewController alloc]init];

    
    NSString *srcPath = [[NSBundle mainBundle]bundlePath];
    
    // 资源路径
    nextAlphaPlayVC.unzipVideoPath  = srcPath;  // ~/Documents/TempleDes/xxxx
//    nextAlphaPlayVC.mvColorStr = [srcPath stringByAppendingPathComponent:kVideoColorStr];
//    nextAlphaPlayVC.mvMaskStr = [srcPath stringByAppendingPathComponent:kVideoMaskStr];
//    nextAlphaPlayVC.mvJsonPath = [srcPath stringByAppendingPathComponent:kVideoJsonStr];
    nextAlphaPlayVC.mvColorStr = [[NSBundle mainBundle]pathForResource:kVideoColorStr ofType:@""];
    nextAlphaPlayVC.mvMaskStr = [[NSBundle mainBundle]pathForResource:kVideoMaskStr ofType:@""];
    nextAlphaPlayVC.mvJsonPath = [[NSBundle mainBundle]pathForResource:kVideoJsonStr ofType:@""];
    
    nextAlphaPlayVC.fileName = @"chunnuanhuakai";
    
    
    
    [self.navigationController pushViewController:nextAlphaPlayVC animated:YES];
    
}


#pragma mark - --- path ---
// ---- get iOS-App some file path ----
- (NSString *)getDocumentFilePath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}



@end

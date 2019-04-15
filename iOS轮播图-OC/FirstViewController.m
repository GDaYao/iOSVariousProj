//  FirstViewController.m
//  iOS轮播图-OC
//
//  Created by GDaYao on 2017/4/28.
//  Copyright © 2017年 GDaYao. All rights reserved.
//
//这个视图控制器主要实现，在底部的scrollView视图中加入几个继承自UIView的视图，轮播实现。

#import "FirstViewController.h"

#import "HeritView.h"
#import "cycleVC.h"

@interface FirstViewController ()<FirstVCNextPageDelegate>

@property(nonatomic,strong)HeritView *heritView;
@end

@implementation FirstViewController
- (void)loadView{
    HeritView *heritView = [[HeritView alloc]init];
    self.heritView = heritView;
    self.view = heritView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.heritView.delegate = self;
}

#pragma mark - heritView delegate
- (void)firstVCNextPage{
    cycleVC *cyclevc=[[cycleVC alloc]init];
    [self presentViewController:cyclevc animated:YES completion:nil];
}


#pragma mark - did receive momory warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end

//  cycleVC.m
//  iOS轮播图-OC
//
//  Created by GDaYao on 2017/4/29.
//  Copyright © 2017年 GDaYao. All rights reserved.
//

#import "cycleVC.h"
#import "cycleView.h"


@interface cycleVC ()

@property(nonatomic,strong)cycleView *cycleview;
@end

@implementation cycleVC

- (void)loadView{
    cycleView *cycleview=[[cycleView alloc]init];
    self.view=cycleview;
    self.cycleview=cycleview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

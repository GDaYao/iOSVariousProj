////  CircleAnimationViewController.m
//  AnimationEffect
//
//  Created on 2019/10/31.
//  Copyright © 2019 Dayao. All rights reserved.
//

#import "CircleAnimationViewController.h"
#import "CircleAnimationView.h"

@interface CircleAnimationViewController ()

@end

@implementation CircleAnimationViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createCustomizeView];

    
}


#pragma mark - create customize view
- (void)createCustomizeView {
    
    CircleAnimationView *circleView = [[CircleAnimationView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:circleView];

}











@end

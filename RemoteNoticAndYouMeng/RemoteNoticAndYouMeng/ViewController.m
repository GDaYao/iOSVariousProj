//
//  ViewController.m
//  RemoteNoticAndYouMeng
//





#import "ViewController.h"

#import "UnionViewController.h"


@interface ViewController ()






@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *unionBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:unionBtn];
    unionBtn.frame = CGRectMake(50, 100, 100, 100);
    unionBtn.layer.borderWidth = 2.0f;
    unionBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    [unionBtn addTarget:self action:@selector(tapComUnionVC) forControlEvents:(UIControlEventTouchUpInside)];
    
}


- (void)tapComUnionVC{
    
    UnionViewController *unionVC = [[UnionViewController alloc]init];
    [self presentViewController:unionVC animated:YES completion:nil];
    
}





@end





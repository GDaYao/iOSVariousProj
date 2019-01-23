//
//  CallViewController.m
//  ContactCallMessage
//


#import "CallViewController.h"

@interface CallViewController ()

@end

@implementation CallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
    
}

- (void)createUI{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(50, 50, 200, 50);
    [btn setTitle:@"点击打电话" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 2.0f;
    [btn addTarget:self action:@selector(triggerCall) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 打电话方法
- (void)triggerCall{
    // 调用打电话前会自动给个提示
    NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",@"10086"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}









@end





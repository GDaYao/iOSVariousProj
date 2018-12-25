//
//  WeiboViewController.m
//  iOSLogin
//



#import "WeiboViewController.h"

#import "WeiboSDK.h"
#import "WeiboSDKVCDelegate.h"



@interface WeiboViewController () <WeiboSDKVCDelegateDelegate>

@end



@implementation WeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self configUI];
    
}

- (void)configUI{
    // 微博 登录
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2,100,100);
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    btn.layer.borderWidth = 2.0f;
    [btn setTitle:@"点击使用微博登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
 
    [btn addTarget:self action:@selector(configWeiboSDKUse) forControlEvents:UIControlEventTouchUpInside];
    
}



#pragma mark - weibo sdk use
- (void)configWeiboSDKUse{
    
    WeiboSDKVCDelegate *delgate = [[WeiboSDKVCDelegate alloc]init];
    delgate.weiboDelegate = self;
    
    
    /*    SSO 微博客户端授权认证  */
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = @"https://api.weibo.com/oauth2/default.html"; // 这里的redirectURL 需要与微博开放平台创建的应用的重定向地址一致
    request.scope = @"all";

//    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    
    [WeiboSDK sendRequest:request];
    
    
}


#pragma mark - delegate
//登录的代理
- (void)weiboLoginByResponse:(WBBaseResponse *)response{
    
    NSLog(@"log--微博登录代理:%@",response);
    
}
//分享的代理
- (void)weiboShareSuccessCode:(NSInteger)shareResultCode{
    
    NSLog(@"log--微博登录代理:%ld",(long)shareResultCode);
    
}





@end

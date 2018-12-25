//
//  QQViewController.m
//  iOSLogin
//


#import "QQViewController.h"


/* QQ 登录 */
#import <TencentOpenAPI/TencentOAuth.h> // must

#import <TencentOpenAPI/QQApiInterfaceObject.h> // 分享使用
#import <TencentOpenAPI/QQApiInterface.h>


@interface QQViewController () <TencentSessionDelegate>

@property (nonatomic,strong)TencentOAuth *loginOAuth;

@end

@implementation QQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self createUIButton];
}

- (void)createUIButton{
    // QQ 登录
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2,100,100);
    btn.layer.borderColor = [UIColor blueColor].CGColor;
    btn.layer.borderWidth = 2.0f;
    [btn setTitle:@"点击QQ登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    // QQ分享给好友
    UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:friendBtn];
    friendBtn.frame = CGRectMake(btn.frame.origin.x,btn.frame.origin.y+btn.frame.size.height+10,100,100);
    friendBtn.layer.borderColor = [UIColor blueColor].CGColor;
    friendBtn.layer.borderWidth = 2.0f;
    [friendBtn setTitle:@"QQ分享给好友" forState:UIControlStateNormal];
    [friendBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    friendBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    
    // QQ分享到空间
    UIButton *spaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:spaceBtn];
    spaceBtn.frame = CGRectMake(friendBtn.frame.origin.x,friendBtn.frame.origin.y+friendBtn.frame.size.height+10,100,100);
    spaceBtn.layer.borderColor = [UIColor blueColor].CGColor;
    spaceBtn.layer.borderWidth = 2.0f;
    [spaceBtn setTitle:@"QQ分享到空间" forState:UIControlStateNormal];
    [spaceBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    spaceBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    
    
    [btn addTarget:self action:@selector(triggerQQLogin) forControlEvents:UIControlEventTouchUpInside];
    [friendBtn addTarget:self action:@selector(qqShareURL) forControlEvents:UIControlEventTouchUpInside];
    [spaceBtn addTarget:self action:@selector(qqShareQQSpace) forControlEvents:UIControlEventTouchUpInside];
    
    
}

#pragma mark - 触发登录处理
- (void)triggerQQLogin{
    
    // you can have other operation
    [self qqLogin];

}



#pragma mark - QQ登录
- (void)qqLogin{
    /* 调用TencentApi --> 出现QQ登录页面
     appID是在腾讯开放平台创建应用所分配的
     在注册完成后应用未提交审核时也已经提供了一个AppId可以使用
     未经过测试不清楚是否是所有账号都可以实现登录
     */
    NSString *appIDStr = @"xxx";    //appID;
    TencentOAuth *loginOAuth = [[TencentOAuth alloc] initWithAppId:appID andDelegate:self];
    NSArray *permissions = @[kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, kOPEN_PERMISSION_ADD_SHARE, kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO];
    [loginOAuth authorize:permissions];
    self.loginOAuth = loginOAuth;
}

#pragma mark - QQ login call
/* 登录成功的回调 */
- (void)tencentDidLogin{
    NSLog(@"log--登录成功");
    // 判断是否获取到Access Token凭证，用于后续访问各开发接口，例如：发表说说到QQ空间、获取用户QQ控件相册列表等
    if (self.loginOAuth.accessToken && 0 != [self.loginOAuth.accessToken length]) {
        // 获取用户信息
        [self.loginOAuth getUserInfo];
    }else{
        NSLog(@"log--登录不成功 没有获取到accesstoken");
    }
}
/* 登录成功获取用户信息  */
- (void)getUserInfoResponse:(APIResponse *)response{
    NSLog(@"log--用户信息：%@",response);

// 获取到某些用户信息
//    [_oauth accessToken] ;
//    [_oauth openId] ;
//    [_oauth getCachedOpenID] ;
//    [_oauth getCachedToken] ;
}
/* 登录失败后的回调 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled){
        NSLog(@"log--用户取消登录");
        //⽤户取消登录
    }else{
        NSLog(@"log--用户登录失败");
        //登录失败
    }
}
/* 登录网络有问题回调 */
- (void)tencentDidNotNetWork{
    NSLog(@"log--登录时网络有问题");
}

/*  QQ登录成功后获取用户信息
 {
 "ret": 0,
 "msg": "",
 "is_lost":0,
 "nickname": "",
 "gender": "男",
 "province": "",
 "city": "",
 "year": "",
 "constellation": "",
 "figureurl": "http:\/\/qza8067470\/A2CB033B4B3BC6DEFB21DF4B5E8747F7\/30",
 "figureurl_1": "http:\/\/qza108067470\/A2CB033B4B3BC6DEFB21DF4B5E8747F7\/50",
 "figureurl_2": "http:\/\/qzapp.qlogo.cn3B4B3BC6DEFB21DF4B5E8747F7\/100",
 "figureurl_qq_1": "http:\/\/thirdqq.qlogo.cn\/qqapp\CB033B4B3BC6DEFB21DF4B5E8747F7\/40",
 "figureurl_qq_2": "http:\/\/thirdqq.qlogo.cn\\/A2CB033B4B3BC6DEFB21DF4B5E8747F7\/100",
 "is_yellow_vip": "0",
 "vip": "0",
 "yellow_vip_level": "0",
 "level": "0",
 "is_yellow_year_vip": "0"
 }
 
 **/


#pragma mark - QQ分享
/* 分享UR+预览图L给好友  */
- (void)qqShareURL{
    self.loginOAuth = [[TencentOAuth alloc] initWithAppId:appID andDelegate:self];
    QQApiURLObject *urlObject = [QQApiURLObject objectWithURL:[NSURL URLWithString:@"www.baidu.com"] title:@"分享百度链接" description:@"听说很好用的哦" previewImageData:UIImageJPEGRepresentation([UIImage imageNamed:@"QQTestImg.png"],1) targetContentType:QQApiURLTargetTypeNews];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:urlObject];
    // 分享给好友
    [QQApiInterface sendReq:req];
    NSLog(@"log--qqShareURL");
}
/* 分享到QQ空间 */
- (void)qqShareQQSpace{
    self.loginOAuth = [[TencentOAuth alloc] initWithAppId:appID andDelegate:self];
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:@"通过App分享测试使用"];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    NSLog(@"log--qqShareQQSpace:%d",sent);
}





@end

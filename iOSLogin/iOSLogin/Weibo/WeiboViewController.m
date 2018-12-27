//
//  WeiboViewController.m
//  iOSLogin
//



#import "WeiboViewController.h"

#import "WeiboSDK.h"

#import "LinkToWeiboViewController.h"

@interface WeiboViewController () <WBHttpRequestDelegate,WBMediaTransferProtocol> // 登出, 分享消息

// share message
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *textSwitch;
@property (nonatomic, strong) UISwitch *imageSwitch;
@property (nonatomic, strong) UISwitch *mediaSwitch;
@property (nonatomic, strong) UISwitch *videoSwitch;
@property (nonatomic, strong) UISwitch *storySwitch;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) WBMessageObject *messageObject;

// request ==> response --> user info
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

@end



@implementation WeiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self configUI];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weiboLoginByResponseInWBAuthorize:) name:@"didReceiveWeiboResponseInWBAuthorizeResponse" object:nil];
    
}

- (void)configUI{
    // 微博 登录
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 3;
    [self.view addSubview:self.titleLabel];
    self.titleLabel.text = NSLocalizedString(@"微博SDK示例", nil);
    
    UILabel *loginTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, 290, 20)];
    loginTextLabel.text = NSLocalizedString(@"登录:", nil);
    loginTextLabel.backgroundColor = [UIColor clearColor];
    loginTextLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:loginTextLabel];
    
    UIButton *ssoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ssoButton setTitle:NSLocalizedString(@"请求微博认证（SSO授权）", nil) forState:UIControlStateNormal];
    [ssoButton addTarget:self action:@selector(ssoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    ssoButton.frame = CGRectMake(20, 90, 280, 40);
    [self.view addSubview:ssoButton];
    
    UIButton *ssoOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ssoOutButton setTitle:NSLocalizedString(@"登出", nil) forState:UIControlStateNormal];
    [ssoOutButton addTarget:self action:@selector(ssoOutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    ssoOutButton.frame = CGRectMake(20, 130, 280, 40);
    [self.view addSubview:ssoOutButton];
    
    UILabel *shareTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 170, 290, 20)];
    shareTextLabel.text = NSLocalizedString(@"分享:", nil);
    shareTextLabel.backgroundColor = [UIColor clearColor];
    shareTextLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:shareTextLabel];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 80, 30)];
    textLabel.text = NSLocalizedString(@"文字", nil);
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    self.textSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 200, 120, 30)];
    [self.view addSubview:textLabel];
    [self.view addSubview:self.textSwitch];
    
    UILabel *imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 240, 80, 30)];
    imageLabel.text = NSLocalizedString(@"图片", nil);
    imageLabel.backgroundColor = [UIColor clearColor];
    imageLabel.textAlignment = NSTextAlignmentCenter;
    self.imageSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 240, 120, 30)];
    [self.view addSubview:imageLabel];
    [self.view addSubview:self.imageSwitch];
    
    UILabel *mediaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 280, 80, 30)];
    mediaLabel.text = NSLocalizedString(@"多媒体", nil);
    mediaLabel.backgroundColor = [UIColor clearColor];
    mediaLabel.textAlignment = NSTextAlignmentCenter;
    self.mediaSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 280, 120, 30)];
    [self.view addSubview:mediaLabel];
    [self.view addSubview:self.mediaSwitch];
    
    UILabel *videoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 320, 80, 30)];
    videoLabel.text = NSLocalizedString(@"视频", nil);
    videoLabel.backgroundColor = [UIColor clearColor];
    videoLabel.textAlignment = NSTextAlignmentCenter;
    self.videoSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 320, 120, 30)];
    [self.view addSubview:videoLabel];
    [self.view addSubview:self.videoSwitch];
    
    UILabel *storyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 360, 80, 30)];
    storyLabel.text = NSLocalizedString(@"story开关", nil);
    storyLabel.backgroundColor = [UIColor clearColor];
    storyLabel.textAlignment = NSTextAlignmentCenter;
    self.storySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100, 360, 120, 30)];
    [self.view addSubview:storyLabel];
    [self.view addSubview:self.storySwitch];
    
    self.shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.shareButton.titleLabel.numberOfLines = 2;
    self.shareButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.shareButton setTitle:NSLocalizedString(@"分享消息到微博", nil) forState:UIControlStateNormal];
    self.shareButton.frame = CGRectMake(210, 200, 90, 110);
    [self.view addSubview:self.shareButton];
    
    UILabel *linkWeiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 400, 290, 20)];
    linkWeiboLabel.text = NSLocalizedString(@"链接到微博API:", nil);
    linkWeiboLabel.backgroundColor = [UIColor clearColor];
    linkWeiboLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:linkWeiboLabel];
    UIButton *linkWeiboButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [linkWeiboButton setTitle:NSLocalizedString(@"链接到微博API Demo", nil) forState:UIControlStateNormal];
    linkWeiboButton.frame = CGRectMake(20, 430, 280, 40);
    [self.view addSubview:linkWeiboButton];
    
    
    
    // target
    [ssoButton addTarget:self action:@selector(ssoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [ssoOutButton addTarget:self action:@selector(ssoOutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.shareButton addTarget:self action:@selector(shareButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [linkWeiboButton addTarget:self action:@selector(linkToWeiboAPI) forControlEvents:UIControlEventTouchUpInside];
    
}



#pragma mark - weibo sdk login
- (void)ssoButtonPressed{
    
    /*    SSO 授权认证（有客户端跳转,有网页打开）  */
    WBAuthorizeRequest *request = [WBAuthorizeRequest request]; //
    request.redirectURI = @"https://api.weibo.com/oauth2/default.html"; // 这里的redirectURL 需要与微博开放平台创建的应用的重定向地址一致
    request.scope = @"all";

    // request.userInfo 可不传  -- 在登录完成后会在回调中返回这里的数据，若未填写
    request.userInfo = @{@"ShareMessageFrom": @"WeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    
    [WeiboSDK sendRequest:request];
}


#pragma mark NSNotification delegate login use
//登录的代理
- (void)weiboLoginByResponseInWBAuthorize:(NSNotification *)userInfo{
    
    WBAuthorizeResponse *response = userInfo.object;
    
    NSLog(@"log--微博登录代理:%@",response);
    
    // 可能需要使用到的参数
    NSString *wbtoken = [response accessToken];
    NSString *wbRefreshToken = [response refreshToken];
    NSString *wbCurrentUserID = [response userID];
    
    // 赋值
    self.wbtoken = wbtoken;
}
- (void)weiboWBSendMessageToWeiboResponse:(NSNotification *)userInfo{
    WBSendMessageToWeiboResponse *response = userInfo.object;
    
    NSString *accessToken = [response.authResponse accessToken];
    NSString *weCurrentUserID = [response.autoContentAccessingProxy userID];
}

#pragma mark - weibo sdk log out
- (void)ssoOutButtonPressed
{
    if (self.wbtoken.length !=0 && self.wbtoken) {
        // 需要登录成功是时返回的token
        [WeiboSDK logOutWithToken:self.wbtoken delegate:self withTag:@"testUser"];
        
        // 在退出成功清空
        // 点击退出登录wbtoken清空
    }else{
        NSLog(@"您还未登录");
    }
    
}


#pragma mark WBHttpRequestDelegate -- log out use
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSString *trueStr = @"{\"result\":\"true\"}";
    if ([result isEqualToString:trueStr]) {
        self.wbtoken = nil; // 点击退出登录wbtoken清空
    }
    
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"收到网络回调", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",result]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}

- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    
    title = NSLocalizedString(@"请求异常", nil);
    alert = [[UIAlertView alloc] initWithTitle:title
                                       message:[NSString stringWithFormat:@"%@",error]
                                      delegate:nil
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:nil];
    [alert show];
}

#pragma mark - weibo share message
- (void)shareButtonPressed{
    // 判断各种情况下是否可以发送 || 在实际使用中可以判定特定的对象是否为空来决定是否执行此次的分享功能
    if (!self.textSwitch.on && !self.imageSwitch.on && !self.mediaSwitch.on && !self.videoSwitch.on && !self.storySwitch.on) {
        return;
    }
    
    
    if ((self.textSwitch.on || self.mediaSwitch.on) && (!self.imageSwitch.on && !self.videoSwitch.on) && self.storySwitch.on) {
        // self.storySwitch.on 打开无意思作用
        //只有文字和多媒体的时候打开分享到story开关，只会呼起发布器，没有意义
        return;
    }
    self.messageObject = [self getMessageObject];
    
    if (!self.imageSwitch.on && !self.videoSwitch.on) {
        [self messageShare];
    }else
    {
        if (!_indicatorView) {
            _indicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
            _indicatorView.center = self.view.center;
            [self.view addSubview:_indicatorView];
            _indicatorView.color = [UIColor blueColor];
        }
        
        [_indicatorView startAnimating];
        [_indicatorView setHidesWhenStopped:YES];
    }
    
}

- (WBMessageObject *)getMessageObject{
    WBMessageObject *message = [WBMessageObject message];
    
    if (self.textSwitch.on)
    {
        message.text = NSLocalizedString(@"这是测试一条通过WeiboSDK发送文字到微博--testDemo!", nil);
    }
    
    if (self.imageSwitch.on)
    {
        //        WBImageObject *image = [WBImageObject object];
        //        image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_1" ofType:@"jpg"]];
        //        message.imageObject = image;
        
        UIImage *image = [UIImage imageNamed:@"WeiboSDK.bundle/images/empty_failed.png"];
        UIImage *image1 = [UIImage imageNamed:@"WeiboSDK.bundle/images/common_button_white.png"];
        UIImage *image2 = [UIImage imageNamed:@"WeiboSDK.bundle/images/common_button_white_highlighted.png"];
        NSArray *imageArray = [NSArray arrayWithObjects:image,image1,image2, nil];
        WBImageObject *imageObject = [WBImageObject object];
        if (self.storySwitch.on) {
            imageObject.isShareToStory = YES;
            imageArray = [NSArray arrayWithObject:image];
        }
        imageObject.delegate = self;
        [imageObject addImages:imageArray];
        message.imageObject = imageObject;
    }
    
    if (self.mediaSwitch.on)
    {
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = @"identifier1";
        webpage.title = NSLocalizedString(@"分享网页标题", nil);
        webpage.description = [NSString stringWithFormat:NSLocalizedString(@"分享网页内容简介-%.0f", nil), [[NSDate date] timeIntervalSince1970]];
        webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"image_2" ofType:@"jpg"]];
        webpage.webpageUrl = @"http://weibo.com/p/1001603849727862021333?rightmod=1&wvr=6&mod=noticeboard";
        message.mediaObject = webpage;
    }
    
    if (self.videoSwitch.on) {
        WBNewVideoObject *videoObject = [WBNewVideoObject object];
        if (self.storySwitch.on) {
            videoObject.isShareToStory = YES;
        }
        NSURL *videoUrl = [NSURL URLWithString:[[NSBundle mainBundle] pathForResource:@"apm" ofType:@"mov"]];
        videoObject.delegate = self;
        [videoObject addVideo:videoUrl];
        message.videoObject = videoObject;
    }
    
    return message;
}

-(void)messageShare
{
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"https://api.weibo.com/oauth2/default.html";
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:self.messageObject authInfo:authRequest access_token:self.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"WeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:456],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    if (![WeiboSDK sendRequest:request]) {
        [_indicatorView stopAnimating];
    }
}

#pragma mark WBMediaTransferProtocol -- share message use
-(void)wbsdk_TransferDidReceiveObject:(id)object
{
    [_indicatorView stopAnimating];
    [self messageShare];
}

-(void)wbsdk_TransferDidFailWithErrorCode:(WBSDKMediaTransferErrorCode)errorCode andError:(NSError*)error
{
    [_indicatorView stopAnimating];
}

#pragma mark - Link weibo

- (void)linkToWeiboAPI
{
    LinkToWeiboViewController* linkToWeiboVC = [[LinkToWeiboViewController alloc] init];
    [self presentViewController:linkToWeiboVC animated:YES completion:nil];
    
}




#pragma mark - dealloc
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end



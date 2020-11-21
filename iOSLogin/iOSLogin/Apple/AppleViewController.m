////  AppleViewController.m
//  iOSLogin
//
//  Created on 2020/11/21.
//  Copyright © 2020 Dayao. All rights reserved.
//

#import "AppleViewController.h"


// Apple 登录
#import <AuthenticationServices/AuthenticationServices.h>



@interface AppleViewController ()  <ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding>

@end

@implementation AppleViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self createUIInAppleVC];
    
    
    
}

- (void)createUIInAppleVC {
    
    /*
    UIButton *appleLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [appleLoginBtn setBackgroundImage:[UIImage imageNamed:@"appleid_button"] forState:UIControlStateNormal];
    appleLoginBtn.frame = CGRectMake(0, 0, 200, 50.0);
    [self.view addSubview:appleLoginBtn];
    
    [appleLoginBtn addTarget:self action:@selector(tapAppleLoginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    */

    
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDButton *appleIDButton = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleBlack];
        appleIDButton.frame = CGRectMake(50, 50, 200, 50.0);
        appleIDButton.cornerRadius = 5.0;
        
        
        [appleIDButton addTarget:self action:@selector(userAppleIdLogin:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:appleIDButton];
        
    } else {
        // Fallback on earlier versions
    }
    
    
}


#pragma mark - app login logic
- (void)userAppleIdLogin:(ASAuthorizationAppleIDButton *)appleLoginButton  API_AVAILABLE(ios(13.0)){
    
    if (@available(iOS 13.0,*)) {
        
        // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
       ASAuthorizationAppleIDProvider *appleIdProvider = [[ASAuthorizationAppleIDProvider alloc] init];
       // 创建新的AppleID 授权请求
       ASAuthorizationAppleIDRequest *request = appleIdProvider.createRequest;
        // 在用户授权期间请求的联系信息
       request.requestedScopes = @[ASAuthorizationScopeEmail,ASAuthorizationScopeFullName];
       
        //需要考虑用户已经登录过，可以直接使用keychain密码来进行登录-这个很智能 (但是这个有问题)
//        ASAuthorizationPasswordProvider *appleIDPasswordProvider = [[ASAuthorizationPasswordProvider alloc] init];
//        ASAuthorizationPasswordRequest *passwordRequest = appleIDPasswordProvider.createRequest;
       
       // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
       ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        // 设置授权控制器通知授权请求的成功与失败的代理
       controller.delegate = self;
       // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
       controller.presentationContextProvider = self;
        // 在控制器初始化期间启动授权流
       [controller performRequests];
        
    }else{
        
        NSLog(@"log-iOS system is lower");
    }
    
}


#pragma mark - ASAuthorizationControllerDelegate
#pragma mark - 授权成功的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)) {
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        NSString *user = credential.user;
        NSData *identityToken = credential.identityToken;
        NSLog(@"fullName -     %@",credential.fullName);
        //授权成功后，你可以拿到苹果返回的全部数据，根据需要和后台交互。
        NSLog(@"user   -   %@  %@",user,identityToken);
        //保存apple返回的唯一标识符
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"userIdentifier"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *psdCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString *user = psdCredential.user;
        NSString *psd = psdCredential.password;
        NSLog(@"psduser -  %@   %@",psd,user);
    } else {
       NSLog(@"授权信息不符");
    }
}

#pragma mark - 授权回调失败
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
    
     NSLog(@"错误信息：%@", error);
     NSString *errorMsg;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            NSLog(@"errorMsg -   %@",errorMsg);
            break;
            
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            NSLog(@"errorMsg -   %@",errorMsg);
            break;
            
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            NSLog(@"errorMsg -   %@",errorMsg);
            break;
            
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            NSLog(@"errorMsg -   %@",errorMsg);
            break;
            
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            NSLog(@"errorMsg -   %@",errorMsg);
            break;
                        
        default:
            break;
    }
}

- (void)getAuthorizationButtonProperty:(ASAuthorizationAppleIDButton *)button API_AVAILABLE(ios(13.0)) {
    NSLog(@"log-getAuthorizationButtonProperty");
    
//    unsigned int count = 0;
//    Ivar *ivars = class_copyIvarList([ASAuthorizationAppleIDButton class], &count);
//    for (NSInteger i = 0; i < count; i ++) {
//        Ivar ivar = ivars[i];
//        NSLog(@"name    %s  \n  %s",ivar_getName(ivar),ivar_getTypeEncoding(ivar));
//    }
}
    


- (void)monitorSignInWithAppleStateChanged:(NSNotification *)notification {
    NSLog(@"state CHANGE -  %@",notification);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
}


#pragma mark - 监听apple登录的状态
- (void)monitorSignInWithAppleState {
    if (@available(iOS 13.0,*)) {
        NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIdentifier"];
        NSLog(@"user11 -     %@",user);
        ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
        __block NSString *errorMsg;
        [provider getCredentialStateForUserID:user completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
            if (!error) {
                switch (credentialState) {
                    case ASAuthorizationAppleIDProviderCredentialRevoked:
                        NSLog(@"Revoked");
                        errorMsg = @"苹果授权凭证失效";
                        break;
                        
                    case ASAuthorizationAppleIDProviderCredentialAuthorized:
                        NSLog(@"Authorized");
                        errorMsg = @"苹果授权凭证状态良好";
                        break;
                        
                    case ASAuthorizationAppleIDProviderCredentialNotFound:
                        NSLog(@"NotFound");
                        errorMsg = @"未发现苹果授权凭证";
                        break;
                        
                    case ASAuthorizationAppleIDProviderCredentialTransferred:
                        NSLog(@"CredentialTransferred");
                        errorMsg = @"未发现苹果授权凭证";
                        break;
                        
                    default:
                        break;
                }
            } else {
                NSLog(@"state is failure");
            }
        }];
    }
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

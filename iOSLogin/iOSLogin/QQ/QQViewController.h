//
//  QQViewController.h
//  iOSLogin
//


// QQ login realization
/**
 *
 *  腾讯开放平台: https://wiki.open.qq.com/wiki/%E9%A6%96%E9%A1%B5
 *
 *  QQ互联:  https://connect.qq.com/index.html
 *
 *  应用创建接入--QQ登录、分享实现 <===
 *
 *  在QQ互联页面注册后填写开发者完善资料后，就可以在注册页面获得需要可以使用的AppId和AppSecert
 *  如果需要上线后可供使用，必须提交此应用以供审核通过后方可使用。
 *
 *  
 * *  需要校验并填写Universal Link: 如: https://<xxx>//qq_conn/<AppId>/ （AppId为QQ互联应用id）
 *
 *  https://<xxxxx>/.well-known/apple-app-site-association
 *
 *
 */





#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define appID [[NSBundle mainBundle]objectForInfoDictionaryKey:@"TencentAppID"] // 

@interface QQViewController : UIViewController








@end






NS_ASSUME_NONNULL_END



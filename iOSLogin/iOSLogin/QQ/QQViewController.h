//
//  QQViewController.h
//  iOSLogin
//


// QQ login realization
/**
 *  应用创建接入--QQ登录、分享实现:  https://connect.qq.com/index.html
 *  在QQ互联页面注册后填写开发者完善资料后，就可以在注册页面获得需要可以使用的AppId和AppSecert
 *  如果需要上线后可供使用，必须提交此应用以供审核通过后方可使用。
 */





#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define appID [[NSBundle mainBundle]objectForInfoDictionaryKey:@"TencentAppID"] // 

@interface QQViewController : UIViewController








@end






NS_ASSUME_NONNULL_END



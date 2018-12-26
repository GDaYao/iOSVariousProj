//
//  WeiboViewController.h
//  iOSLogin
//


// Weibo login realization

/**
 *  微博开放平台: https://open.weibo.com/
 *  微博iOS-SDK文档 （具体使用可看微博SDK开发文档）: https://github.com/sinaweibosdk/weibo_ios_sdk
 *  移动端接入+SDK功能特性: http://open.weibo.com/wiki/%E7%A7%BB%E5%8A%A8%E5%AE%A2%E6%88%B7%E7%AB%AF%E6%8E%A5%E5%85%A5
 
 如果还不是微博开发者，需先注册成为微博开发者，然后在按照微博教程实现相关的功能。
  在进行邮箱验证时，如果使用手机进行邮件查看可能会出现验证不成功，请使用浏览器再次进入邮箱进行相关验证即可。
 
 应用AppSecret可重置，在“我的应用”-->"高级信息"-->“重置AppSecret”
 
 注意: 按照官方文档还缺少一个 `photos.framework`Linked Frameworkes  and Libraries. ++ 还有添加白名单
 其它有问题，请参照weibo-sdk的Demo.
 */


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeiboViewController : UIViewController





@end

NS_ASSUME_NONNULL_END

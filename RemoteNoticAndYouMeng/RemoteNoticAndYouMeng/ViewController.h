//
//  ViewController.h
//  RemoteNoticAndYouMeng
//

// func: 远程通知实现 （此Demo或控制器主要介绍远程通知的实现过程 以及 使用极光推送的官网操作步骤或链接）

/** 快速集成极光推送使用:
 
 *  到极光推送官方网站注册开发者帐号 --- https://www.jiguang.cn/accounts/register
 *  登录进入管理控制台，创建应用程序，得到 Appkey（SDK 与服务器端通过 Appkey 互相识别）--- https://www.jiguang.cn/dev/#/app/list#dev
 *  在推送设置中给 Android 设置包名、给 iOS 上传证书、启用 WinPhone，根据你的需求进行选择； -- 极光证书导出使用: https://docs.jiguang.cn/jpush/client/iOS/ios_cer_guide/#p12
 
 *  下载 SDK 集成到 App 里,按照步骤实现需要的功能。
 *  极光SDK集成指南: https://docs.jiguang.cn/jpush/client/iOS/ios_guide_new/
 
 
 极光推送管理控制台: https://www.jiguang.cn/jpush/#/app/192f62b7fcda8ad8de342db2/push/notification
 
 按照此   `AppDelegate.m`中文件所写同步即可实现远程通知功能发送。
 （在实际测试中，请勿和注册本地通知的代码一起出现否则远程通知功能会失效，可能是远程通知注册失败）
 
 
 ** 远程通知实现只需直接在 `AppDelegate`文件中添加代码即可实现该功能 **
 
 
 */


/**
 集成步骤:
 
 1. 导入lib文件夹
 2. 添加Framework
     CFNetwork.framework
     CoreFoundation.framework
     CoreTelephony.framework
     SystemConfiguration.framework
     CoreGraphics.framework
     Foundation.framework
     UIKit.framework
     Security.framework
     libz.tbd（Xcode 7 以下版本是 libz.dylib）
     AdSupport.framework（获取 IDFA 需要；如果不使用 IDFA，请不要添加）
     UserNotifications.framework（Xcode 8 及以上）
     libresolv.tbd（JPush 2.2.0 及以上版本需要，Xcode 7 以下版本是 libresolv.dylib）

 
 
 */






#import <UIKit/UIKit.h>

@interface ViewController : UIViewController








@end





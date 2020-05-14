////  MBProgressHUD+MBHUD.h
//  ProgressHUD
//
//  Created on 2019/8/1.
//  Copyright © 2019 Dayao. All rights reserved.
//


/** func: 在对应的项目中直接使用此 .h/.m文件即可使用。
 * 已封装完成
 *
 */



#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (MBHUD)


#pragma mark - 显示在window
//window显示文字
+ (void)showInWindowMessage:(NSString *)message;

//window显示文字延时 -- 不建议使用MBProgressHUD延时方法，请使用SVProgressHUD
+ (void)showInWindowMessage:(NSString *)message delayTime:(NSInteger)time;

//window加载
+ (void)showInWindowActivityWithMessage:(NSString *)message;

//window加载延时 -- 不建议使用MBProgressHUD延时方法，请使用SVProgressHUD
+ (void)showInWindowActivityWithMessage:(NSString *)message delayTime:(NSInteger)time;

//window自定义图片
+ (void)showInWindowCustomImage:(NSString *)imageName message:(NSString *)message;


#pragma mark - 显示在view
//view显示文字
+ (void)showInViewMessage:(NSString *)message;

//view显示文字延时 -- 不建议使用MBProgressHUD延时方法，请使用SVProgressHUD
+ (void)showInViewMessage:(NSString *)message delayTime:(NSInteger)time;

//view加载
+ (void)showInViewActivityWithMessage:(NSString *)message;

//view加载延时 -- 不建议使用MBProgressHUD延时方法，请使用SVProgressHUD
+ (void)showInViewActivityWithMessage:(NSString *)message delayTime:(NSInteger)time;

//view自定义图片
+ (void)showInViewCustomImage:(NSString *)imageName message:(NSString *)message;

// 黑色菊花钻 - 无背景蒙层 - 旋转加载
+ (void)showHUDBlackStyleForView:(UIView *)currentView animated:(BOOL)isAnimated;


#pragma mark - 操作结果提示
//成功提示
+ (void)showSuccessMessage:(NSString *)message;

//失败提示
+ (void)showFailMessage:(NSString *)message;

//警告提示
+ (void)showWarnMessage:(NSString *)message;

//信息提示
+ (void)showInfoMessage:(NSString *)message;

//显示进度条
+ (void)showProgressHudWithMessage:(NSString *)message;


#pragma mark - 隐藏
//隐藏
+ (void)hideHUD;
// set hidden customize view
+ (void)hiddenHUDForView:(UIView *)currentView animated:(BOOL)isAnimated;



@end

NS_ASSUME_NONNULL_END

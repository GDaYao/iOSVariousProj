////  SVProgressHUD+SVHUD.h
//  ProgressHUD
//
//  Created on 2019/8/1.
//  Copyright © 2019 Dayao. All rights reserved.
//


/** func: MBProgressHUD
 * 已封装完成
 */



#import "SVProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVProgressHUD (SVHUD)


// SVProgressHUD直接使用
+ (void)showLoadingUseSVProgress;
// 带文字进度展示
+ (void)showLoadingUseSVProgressWithStatus:(NSString *)statusStr;

// TODO: 文字延时提示信息--time后隐藏
+ (void)svprogressHUDShowWithMsg:(NSString *)message  minTime:(NSTimeInterval)minTime maxTime:(NSTimeInterval)maxTime;

//  进度展示--可多次调用
+ (void)showLoadingProgressUseSVProgressWithFloat:(float)progressFloat;
// 带文字进度展示
+ (void)showLoadingProgressUseSVProgressWithFloat:(float)progressFloat status:(NSString *)statusStr;

//   加载完成动画
+ (void)showCompletionInSVProgresssWithHint:(NSString *)hintStr;

//   hidden SVProgressHUD
+ (void)hiddenLoadingUseSVProgress;

// delay hidden SVProgressHUD
+ (void)hiddenLoadingUseSVProgressWithDelay:(NSTimeInterval)delay;



@end

NS_ASSUME_NONNULL_END

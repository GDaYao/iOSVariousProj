////  SVProgressHUD+SVHUD.m
//  ProgressHUD
//
//  Created on 2019/8/1.
//  Copyright © 2019 Dayao. All rights reserved.
//

#import "SVProgressHUD+SVHUD.h"

@implementation SVProgressHUD (SVHUD)


// SVProgressHUD直接使用
+ (void)showLoadingUseSVProgress {
    [SVProgressHUD show];
}

// 带文字加载展示
+ (void)showLoadingUseSVProgressWithStatus:(NSString *)statusStr {
    [SVProgressHUD showWithStatus:statusStr];
}

// TODO: 文字延时提示信息--time后隐藏
+ (void)svprogressHUDShowWithMsg:(NSString *)message  minTime:(NSTimeInterval)minTime maxTime:(NSTimeInterval)maxTime  {
    [SVProgressHUD setMinimumDismissTimeInterval:minTime]; // 1.0
    [SVProgressHUD setMaximumDismissTimeInterval:maxTime]; // 1.5
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showImage:[UIImage imageNamed:@""] status:message];
}



//  进度展示--可多次调用
+ (void)showLoadingProgressUseSVProgressWithFloat:(float)progressFloat {
    [SVProgressHUD showProgress:progressFloat];
}
// 带文字进度展示
+ (void)showLoadingProgressUseSVProgressWithFloat:(float)progressFloat status:(NSString *)statusStr {
    [SVProgressHUD showProgress:progressFloat status:statusStr];
}


//   加载完成动画
+ (void)showCompletionInSVProgresssWithHint:(NSString *)hintStr {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD setMinimumDismissTimeInterval:3.0];
        [SVProgressHUD setMaximumDismissTimeInterval:3.0];
        
        [SVProgressHUD showSuccessWithStatus:hintStr ];
    });
}


//  hidden SVProgressHUD
+ (void)hiddenLoadingUseSVProgress {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

// delay hidden SVProgressHUD
+ (void)hiddenLoadingUseSVProgressWithDelay:(NSTimeInterval)delay {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismissWithDelay:delay];
    });
}





@end

//
//  OtherRecordMgr.m


#import "OtherRecordMgr.h"

@implementation OtherRecordMgr


#pragma mark - screen rotate
/**
* 1. AppDelegate.m set support interface orientation.
 */
// support interface
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskAll;
}
/**
 * 2. 下面的3个方法如果是在有UINavigationController/UITabBarController时，需要在根控制器中设置调用下面的三个方法（在其它控制器直接创建使用，系统不会主动触发调用）
 * 或者解决某个控制器旋转可以实现继承自rootVC，实现`shouldAutorotate`xxx
 * 或者使用通知在`viewWillAppear`,`viewWillDisappear`发送通知，因为系统会在进入新的控制器实现主动调用下面的三个方法。
*/
- (BOOL)shouldAutorotate{
    return NO;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
// 优先/第一次显示方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
/**
 * 3. 强制某个时刻旋转屏幕 --
 */
// method 1
- (void)implementInTapRotateScreen{
    NSNumber *value = [NSNumber numberWithInt:UIDeviceOrientationLandscapeLeft];
    [[UIDevice currentDevice]setValue:value forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
}
// method 2
- (void)changeInterfaceOrientationTo:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
/**
 *  4. 旋转触发的方法
 */
// 视图发生了大小改变的时候会调用此方法   大小改变 == 横竖切换 (iOS8,*)
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{}
// deprecated 将要旋转到某个方向的时候调用此方法(iOS8之前)
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{}

#pragma mark - layout
/**
 *  在VC中布局界面
 */
- (void)viewWillLayoutSubviews{}
- (void)viewDidLayoutSubviews{}
/**
 * 在view中布局界面
 ①、直接调用setLayoutSubviews。
 ②、addSubview的时候触发layoutSubviews。
 ③、当view的frame发生改变的时候触发layoutSubviews。
 ④、第一次滑动UIScrollView的时候触发layoutSubviews。
 ⑤、旋转Screen会触发父UIView上的layoutSubviews事件。
 ⑥、改变一个UIView大小的时候也会触发父UIView上的layoutSubviews事件。
 7、屏幕发生旋转时也会调用。
 init初始化不会触发layoutSubviews，但是使用initWithFrame进行初始化时，当rect的值不为CGRectZero时，也会触发。
 */
- (void)layoutSubviews{}
/**
 * 强制更新布局，你可以调用`setNeedsLayout`方法
 */
- (void)setNeedsLayout{}
/**
 * 强制进行提前布局/立即显示views -- 可作为属性直接调用
 */
- (void)layoutIfNeeded{}



#pragma mark - 隐藏状态栏
/**
 * 1. 全部界面都隐藏
 * 设置 `Info.plist` Status bar is initially hidden   （value：YES) ||  View controller-based status bar appearance   (value:NO)
 */

/**
 * 2. 某个界面隐藏导航栏
 *  需要隐藏导航栏的地方 调用 -- [self setNeedsStatusBarAppearanceUpdate];
 */
- (BOOL)prefersStatusBarHidden
{
    return YES;  //隐藏为YES，显示为NO
}


#pragma mark - 计算Lab/text/string 所占宽度
+ (void)caculateLabOrTextStringSize:(NSString *)labText rangeWidth:(UIView *)rangeSelf{
    CGSize leRepLabSize = [labText boundingRectWithSize:CGSizeMake(rangeSelf.bounds.size.width, __FLT_MAX__) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil].size;
}


#pragma mark  - 验证码定时器
/*
 - (void)startTime:(UIButton *)button
 {
 __block int timeout = 60; //倒计时时间
 dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 dispatch_source_t timeNew = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
 dispatch_source_set_timer(timeNew, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
 dispatch_source_set_event_handler(timeNew, ^{
 if (timeout <= 0) { //倒计时结束，关闭
 dispatch_source_cancel(timeNew);
 dispatch_async(dispatch_get_main_queue(), ^{
 [button setTitle:@"获取验证码" forState:UIControlStateNormal];
 button.userInteractionEnabled = YES;
 [button setTitleColor:kNavigationBarBg forState:UIControlStateNormal];
 });
 } else {
 NSString *strTime = [NSString stringWithFormat:@"%.2d", timeout];
 dispatch_async(dispatch_get_main_queue(), ^{
 [button setTitle:[NSString stringWithFormat:@"获取验证码(%@)", strTime] forState:UIControlStateNormal];
 [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
 button.userInteractionEnabled = NO;
 });
 timeout--;
 }
 });
 dispatch_resume(timeNew);
 }
 
 **/

#pragma mark NSTimer定时器

/*
 //                    weakSelf.sendPhoneTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(runloopTimeSecondSendPhone) userInfo:nil repeats:YES];
 //                    [[NSRunLoop currentRunLoop] addTimer:weakSelf.sendPhoneTimer forMode:NSRunLoopCommonModes];
 //                    [[NSRunLoop currentRunLoop] run];
 
 - (void)runloopTimeSecondSendPhone{
 if (self.sendPhoneTimer && self.sendEmailBtnInVC) {
 if ([self.sendEmailBtnInVC.currentTitle isEqualToString:@"获取验证码"]) {
 [self.sendEmailBtnInVC setTitle:@"60S" forState:UIControlStateNormal];
 [self.sendEmailBtnInVC setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
 self.sendEmailBtnInVC.enabled = NO;
 }else if([self.sendEmailBtnInVC.currentTitle isEqualToString:@"0S"]){
 [self.sendEmailBtnInVC setTitle:@"发送验证码" forState:UIControlStateNormal];
 [self.sendEmailBtnInVC setTitleColor:kNavigationBarBg forState:UIControlStateNormal];
 self.sendEmailBtnInVC.enabled = YES;
 
 [self.sendPhoneTimer invalidate];
 self.sendPhoneTimer = nil;
 }else
 {
 NSInteger sendEmailNum = [self.sendEmailBtnInVC.currentTitle integerValue];
 NSString *numStr = [NSString stringWithFormat:@"%ldS",sendEmailNum-1];
 [self.sendEmailBtnInVC setTitle:numStr forState:UIControlStateNormal];
 }
 
 }
 }
 **/

#pragma mark UINavigation navBar
// self.extendedLayoutIncludesOpaqueBars = YES; //此解决UINavigationVC中出现UIScrollView导致下级的UIViewController也出现自动下移的情况(移动"状态栏+导航栏"的高度)
// self.automaticallyAdjustsScrollViewInsets = NO; // 此属性iOS 11.0之前可使用，在最新的iOS 12.0中未起作用。

#pragma mark - set Animation
/*
 // setAnimation - m1
 [UIView animateWithDuration:0.5 animations:^{
 self.contentSV.contentOffset = CGPointMake(0, tfOffset);
 } completion:^(BOOL finished) {
 }];
 // setAnimation - m2
 [UIView beginAnimations:@"ResizeKeyboard" context:nil];
 [UIView setAnimationDuration:0.5];
 // add set animation method
 [UIView commitAnimations];
 
 **/

#pragma mark - set Info.plist default
/**
 Info.plist add some authority
 ----
 <key>NSAppTransportSecurity</key>
 <dict>
 <key>NSAllowsArbitraryLoads</key>
 <true/>
 </dict>
 <key>NSAppleMusicUsageDescription</key>
 <string>App需要您的同意,才能访问媒体资料库</string>
 <key>NSBluetoothPeripheralUsageDescription</key>
 <string>App需要您的同意,才能访问蓝牙</string>
 <key>NSCameraUsageDescription</key>
 <string>需要访问相机，是否允许</string>
 <key>NSLocationAlwaysUsageDescription</key>
 <string>App需要您的同意,才能始终访问位置</string>
 <key>NSLocationUsageDescription</key>
 <string>App需要您的同意,才能访问位置</string>
 <key>NSLocationWhenInUseUsageDescription</key>
 <string>App需要您的同意,才能在使用期间访问位置</string>
 <key>NSMicrophoneUsageDescription</key>
 <string>App需要您的同意,才能访问麦克风</string>
 ----
 
 */



@end

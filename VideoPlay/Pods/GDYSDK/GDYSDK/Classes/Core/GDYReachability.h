/*
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE. 
 */

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

/**
 Usage:
function: 网络监测方法
 --- 可在需要使用网络直接使用下面的方法判断
 --- 会在网络改变后（无网络）给予弹框无网络提示
 
 #pragma mark - all network relative
 - (void)isNetworkingAndAddObserveNotificationCenter{
 if (![ToolMgr isNetworking]) {
 [self alertShow:NSLocalizedString(@"noNetwokingMsg", @"您的网络已断开，请开启网络以便给您更好的体验！")];
 }
 
 [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addObserveNetWorkIsChange:) name:kReachabilityChangedNotification object:nil];
 // 获取访问指定站点的Reachability的对象
 GDYReachability *hostReach=[GDYReachability reachabilityForInternetConnection];
 // 让Reachability对象开启被监听状态
 [hostReach startNotifier];
 }
 - (void)addObserveNetWorkIsChange:(NSNotification *)notification{
 // selector
 if (![ToolMgr isNetworking]) {
 [self alertShow:NSLocalizedString(@"noNetwokingMsg", @"您的网络已断开，请开启网络以便给您更好的体验！")];
 }
 }
 - (void)alertShow:(NSString *)alertMsg{
 //package alert show
 UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"drawPresentNullShowTitle", @"温馨提示") message:alertMsg delegate:self cancelButtonTitle:NSLocalizedString(@"goodBtn_title", @"好的") otherButtonTitles:nil];
 [alertV show];
 }
*/

/** 
 * Create NS_ENUM macro if it does not exist on the targeted version of iOS or OS X.
 *
 * @see http://nshipster.com/ns_enum-ns_options/
 **/
#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

extern NSString *const kReachabilityChangedNotificationInGDY;

typedef NS_ENUM(NSInteger, NetworkStatus) {
    // Apple NetworkStatus Compatible Names.
    NotReachable = 0,
    ReachableViaWiFi = 2,
    ReachableViaWWAN = 1
};

@class GDYReachability;

typedef void (^NetworkReachable)(GDYReachability * reachability);
typedef void (^NetworkUnreachable)(GDYReachability * reachability);


@interface GDYReachability : NSObject

@property (nonatomic, copy) NetworkReachable    reachableBlock;
@property (nonatomic, copy) NetworkUnreachable  unreachableBlock;

@property (nonatomic, assign) BOOL reachableOnWWAN;


+(GDYReachability*)reachabilityWithHostname:(NSString*)hostname;
// This is identical to the function above, but is here to maintain
//compatibility with Apples original code. (see .m)
+(GDYReachability*)reachabilityWithHostName:(NSString*)hostname;
+(GDYReachability*)reachabilityForInternetConnection;
+(GDYReachability*)reachabilityWithAddress:(void *)hostAddress;
+(GDYReachability*)reachabilityForLocalWiFi;

-(GDYReachability *)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

-(BOOL)startNotifier;
-(void)stopNotifier;

-(BOOL)isReachable;
-(BOOL)isReachableViaWWAN;
-(BOOL)isReachableViaWiFi;

// WWAN may be available, but not active until a connection has been established.
// WiFi may require a connection for VPN on Demand.
-(BOOL)isConnectionRequired; // Identical DDG variant.
-(BOOL)connectionRequired; // Apple's routine.
// Dynamic, on demand connection?
-(BOOL)isConnectionOnDemand;
// Is user intervention required?
-(BOOL)isInterventionRequired;

-(NetworkStatus)currentReachabilityStatus;
-(SCNetworkReachabilityFlags)reachabilityFlags;
-(NSString*)currentReachabilityString;
-(NSString*)currentReachabilityFlags;




@end

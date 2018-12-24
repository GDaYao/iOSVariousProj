//
//  QQApiShareEntry.m
//  iOSLogin
//


#import "QQApiShareEntry.h"

@implementation QQApiShareEntry

#pragma mark - QQAPIInterfaceDelegate
- (void)onReq:(QQBaseReq *)req{
    NSLog(@"log--onReq:%@",req);
    
}

- (void)onResp:(QQBaseResp *)resp{
    NSLog(@"log--onResp:%@",resp);
}

- (void)isOnlineResponse:(NSDictionary *)response{
    NSLog(@"log--isOnline:%@",response);
}






@end

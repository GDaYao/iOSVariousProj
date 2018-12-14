//
//  CustomAFNetHTTPSessionMgr.m


#import "CustomAFNetHTTPSessionMgr.h"

@implementation CustomAFNetHTTPSessionMgr

+ (instancetype)manager{
    CustomAFNetHTTPSessionMgr *manager = [super manager];
    // 1. XML - if sever back XML data,set AFNetworking serializer style
    //manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    // 2. not Json/XML
    //manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"application/xhtml+xml", @"application/xml", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"video/mp4", nil];
    manager.requestSerializer.timeoutInterval = 60.f;
    return manager;
}



@end

//
//  PaymentMgr.m


#import "PaymentMgr.h"

#import <StoreKit/StoreKit.h>

@implementation PaymentMgr

#pragma mark - app request review
+ (void)appRequestReview{
    // this method invalid.
    //#import <StoreKit/StoreKit.h>
    
    // `SKStoreReviewController` in iOS 10.3 use.
    if (@available(iOS 10.3,*)) {
        [SKStoreReviewController requestReview];
    }
    
}

#pragma mark - In-App purchase







@end






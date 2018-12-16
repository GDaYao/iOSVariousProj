//
//  UIViewController+CustomVC.m



#import "UIViewController+CustomVC.h"

@implementation UIViewController (CustomVC)

#pragma mark - transform UIView to get UIViewController
+ (UIViewController *)getCurrentVCWithView:(UIView *) currentView
{
    for (UIView* next = [currentView superview]; next; next = next.superview){
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]){
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}



@end





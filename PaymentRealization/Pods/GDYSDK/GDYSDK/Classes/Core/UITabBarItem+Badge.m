//
//  UITabBarItem+Badge.m


#import "UITabBarItem+Badge.h"
#import "UIBadgeLable.h"
#include <objc/runtime.h>
 const  static NSString *tabBarBadgeLableString=@"tabBarBadgeLableString";
@implementation UITabBarItem (Badge)


//-(void)makeBadgeTextNum:(NSInteger )textNum
//                  textColor:(UIColor *)tColor
//                  backColor:(UIColor *)backColor
//                       Font:(UIFont*)tfont{
//}

#pragma mark - make red badge
-(void)makeRedBadge:(CGFloat)corner color:(UIColor *)cornerColor{
    
    UIView *TabBar_item_=[self valueForKey:@"_view"];
    UIView *UITabBarSwappableImageView=[self findSwappableImageViewByInView:TabBar_item_];
    if ([self badgeLable]==nil) {
        UIBadgeLable *badgeLable =[[UIBadgeLable alloc] init];
        objc_setAssociatedObject(self, &tabBarBadgeLableString, badgeLable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
          [UITabBarSwappableImageView addSubview:badgeLable];
    }
    
    [[self badgeLable]setFrame:CGRectMake(UITabBarSwappableImageView.frame.size.width-corner, -corner, corner*2.0, corner*2.0)];
    
    [[self  badgeLable] makeBrdgeViewWithCor:corner CornerColor:cornerColor];
}

#pragma mark - remove badge view
- (void)removeBadgeView{
    
    [[self badgeLable] removeFromSuperview];
}

-(UIBadgeLable *)badgeLable{
    
    UIBadgeLable *badgeLable=objc_getAssociatedObject(self, &tabBarBadgeLableString);
    return badgeLable;
}

-(UIView *)findSwappableImageViewByInView:(UIView *)inView{
    
    for (UIView *subView in inView.subviews) {
        
        
        if ([subView isKindOfClass:[UIImageView class]]) {
            
            return subView;
        }
        
    }
    return nil;
}


@end

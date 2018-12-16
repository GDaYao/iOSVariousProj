//
//  UIView+Badge.h

#import <UIKit/UIKit.h>

@interface UIView (Badge)

/*
 set badge and property
 */
-(void)makeBadgeText:(NSString *)text
               textColor:(UIColor *)tColor
               backColor:(UIColor *)backColor
                    Font:(UIFont*)tfont;

/*
 set red point
 */
-(void)makeRedBadge:(CGFloat)corner color:(UIColor *)cornerColor;


-(void)removeBadgeView;


@end

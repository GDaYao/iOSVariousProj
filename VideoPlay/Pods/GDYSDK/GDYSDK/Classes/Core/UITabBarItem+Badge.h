//
//  UITabBarItem+Badge.h

// func: UITabBarItem add badge

#import <UIKit/UIKit.h>

@interface UITabBarItem (Badge)


/**
 make red badge.

 @param corner Corner size width or height.
 @param cornerColor Corner color.
 */
-(void)makeRedBadge:(CGFloat)corner color:(UIColor *)cornerColor;


 /**
  remove badge view.
  */
 -(void)removeBadgeView;




@end

//
//  UITabBar+CustomCircleBar.h

//function: 自定义UITabBar tabBar处理方法

/**
  UITabController底部每个UITabBar对上右上方加入红色提示点
 */

#import <UIKit/UIKit.h>

@interface UITabBar (CustomCircleBar)


/**
 Show `UITabBar` badge.

 @param index `UITabBar` index start 0.
 @param badgeTag Origin zoom badge tag.
 @param pointWidth Badge width.
 @param rightRange Badge right of `UITabBar` distance.
 */
- (void)showBadgeIndex:(NSInteger)index originBadgeTag:(NSInteger)badgeTag badgeWAH:(NSInteger)pointWidth rightMargin:(NSInteger)rightRange;


/**
 hide `UITabBar` badge.

 @param index `UITabBar` index start 0.
 @param badgeTag Origin zoom badge tag.
 */
- (void)hideBadgeIndex:(NSInteger)index originBadgeTag:(NSInteger)badgeTag;



@end

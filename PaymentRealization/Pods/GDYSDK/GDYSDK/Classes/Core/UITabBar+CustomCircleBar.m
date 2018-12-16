//
//  UITabBar+CustomCircleBar.m

#import "UITabBar+CustomCircleBar.h"


static NSInteger const pointDefaultWAH = 10; // default badge size



@implementation UITabBar (CustomCircleBar)

#pragma mark - show UITabBar badge
- (void)showBadgeIndex:(NSInteger)index originBadgeTag:(NSInteger)badgeTag badgeWAH:(NSInteger)pointWidth rightMargin:(NSInteger)rightRange{
    [self hideBadgeIndex:index originBadgeTag:badgeTag];
    UIView *badgeView = [[UIView alloc] init];
    //设置tag值，可以通过tag值去找到对应的tabBar上面的小红点
    badgeView.tag = badgeTag + index;
    if (pointWidth == 0 || pointWidth <0) {
        pointWidth = pointDefaultWAH;
    }
    badgeView.layer.cornerRadius = pointWidth / 2;
    badgeView.backgroundColor = [UIColor redColor];
    [self addSubview:badgeView];
    
    // 设置小红点的位置
    int i = 0;
    for (UIView *subView in self.subviews){
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            //找到需要加小红点的view，根据frame设置小红点的位置
            if (i == index) {
                //向右边的偏移量，可以根据具体情况调整
                CGFloat x = subView.frame.origin.x + subView.frame.size.width / 2 + rightRange;
                CGFloat y = pointWidth / 2;
                if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                    x = subView.frame.origin.x + subView.frame.size.width /3;
                    
                }
                badgeView.frame = CGRectMake(x, y, pointWidth, pointWidth);
                break;
            }
            i++;
        }
    }
}

#pragma mark - hide `UITabBar` badge
- (void)hideBadgeIndex:(NSInteger)index originBadgeTag:(NSInteger)badgeTag{
    for (UIView *subView in self.subviews) {
        if (subView.tag == badgeTag + index) {
            [subView removeFromSuperview];
        }
    }
}


@end

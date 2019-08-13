
/** func: customize page view.
 * provide customize page view method,so you can operate depend on this by yourself.
 *
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol PageControlViewDelegate <NSObject>

/*
 *  change position call method.
 */
- (void)selectedAtIndex:(NSInteger)index;


@end

@interface PageControlView : UIView


@property (nonatomic,weak)id<PageControlViewDelegate> delegate;

/** 默认选择的index */
@property (nonatomic, assign) NSInteger selectedIndex;
/** scrollEnabled 是否支持滑动*/
@property (nonatomic, assign) BOOL scrollEnabled;
/** lineColor */
@property (nonatomic, strong) UIColor* lineColor;

#pragma mark - init
/**
 init method.
 
 @param frame frame.
 @param titles array titles.
 @param viewControllers array viewControllers.
 @param selectedIndex selected index.
 @param segmentHeight segment height.
 @return return self.
 */
- (instancetype)initWithFrame:(CGRect)frame vcTitles:(NSArray <NSString *>*)titles viewControllers:(NSArray <UIViewController *>*)viewControllers selectIndex:(NSInteger)selectedIndex segmentHeight:(CGFloat)segmentHeight;

/**
 添加到控制器上作为子控制器 | 添加到view上显示。

 @param viewController 父视图控制器
 @param view 控制显示的父视图view，可调节frame位置
 */
- (void)showInViewController:(UIViewController *)viewController addView:(UIView *)view;

/**
 添加到 UINaviationController

 @param navigationController 导航控制器
 */
- (void)showInNavigationController:(UINavigationController *)navigationController;





@end



NS_ASSUME_NONNULL_END



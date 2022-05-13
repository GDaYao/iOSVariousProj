//  PageControlSuperView.h
//  PageController
//
//  Created by  on 2022/5/13.
//  Copyright © 2022 pagecontroller. All rights reserved.
//



/** func: page controller 采用自定义顶部按钮 + 自定义Sub子视图。
 *
 * 不采用UIPageController因为在滑动的时候有崩溃问题。
 *
 */


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/** 设置标题枚举类型
 *
 * 可自定义添加自适应枚举类型和视图
 *
 */
typedef NS_ENUM(NSInteger) {
    topTitleLayoutType_left = 0,    // 标题从从左边开始布局
}TopTitleLayoutType;


@protocol PageControlSuperViewDelegate <NSObject>

- (void)selectedAtIndexDelegate:(NSInteger)selectedIndex;


@end



@interface PageControlSuperView : UIView  {

@private
    TopTitleLayoutType _topTitleLayoutType;
    
    NSArray <NSString *>*_titles;
    NSArray <UIView *>*_views;
    
    UIColor *_titleNormalColor;
    UIColor *_titleSelectColor;
    
    float _titleNormalFontSize;
    float _titleSelectedFontSize;
    
    float _titleHeight;
    float _titleTopDis;
    
    float _subViewTopDis;
    
    UIColor *_bottomLineBtnColor;
    CGSize _bottomLineBtnSize;
    
    //
    UIScrollView *_topScrollView;
    UIScrollView *_pageScrollView;
    UIButton *_bottomLineBtn;
    
    //
    NSMutableArray *_topBtnMuArr;
    
    //
    CAGradientLayer *_btnBgLayer;
    
}


@property (nonatomic,assign)NSInteger selectedIndex;

@property (nonatomic,weak)id <PageControlSuperViewDelegate> delegate;



// init frame
/// 初始化方法，需传入相应的初始化参数
/// @param frame 计算当前PageView视图的frame；不可传CGRectZero内部会根据frame计算相应UI位置。
/// @param titles 标题数组
/// @param titleNormalColor 未选中装填标题色值
/// @param titleSelectedColor 选中状态标题色值
/// @param titleNormalFontSize 未选中状态字体大小
/// @param titleSelectedFontSize 选中状态字体大小
/// @param views 子视图数组--view可支持全屏展示，可根据子视图顶部距离调节。
/// @param titleHeight 顶部标题高度
/// @param titleTopDis 顶部标题距离
/// @param subViewTopDis 子视图距离
/// @param bottomLineBtnColor 选中标题下划线颜色
/// @param bottomLineBtnSize 选中标题下划线大小
/// @param topTitleLayoutType 选择标题样式
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *> *)titles titleNormalColor:(UIColor *)titleNormalColor titleSelectedColor:(UIColor *)titleSelectedColor titleNormalFontSize:(float)titleNormalFontSize titleSelectedFontSize:(float)titleSelectedFontSize views:(NSArray<UIView *> *)views titleHeight:(float)titleHeight titleTopDis:(float)titleTopDis subViewTopDis:(float)subViewTopDis bottomLineBtnColor:(UIColor *)bottomLineBtnColor bottomLineBtnSize:(CGSize)bottomLineBtnSize topTitleLayoutType:(TopTitleLayoutType)topTitleLayoutType;



// auto trigger next title
/// 适用场景：滑到底部时，自动切换下一页
- (void)setAutoTriggerNextTitleWithNextIndex;




@end

NS_ASSUME_NONNULL_END




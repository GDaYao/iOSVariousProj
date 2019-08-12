
#import "PageControlView.h"
#import "SegmentedControl.h"



/** 颜色宏定义 */
#define UIColorFromHexInPageControlView(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]



// set common segment height 40.0,after you can customize.
static const CGFloat SegmentHeight = 40.0f;


@interface PageControlView () <UIPageViewControllerDelegate,UIPageViewControllerDataSource>


@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *viewControllers;

@property (nonatomic, strong)SegmentedControl *segmentedControl;
@property (nonatomic, strong)UIPageViewController *pageViewController;



@end

@implementation PageControlView


#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame vcTitles:(NSArray <NSString *>*)titles viewControllers:(NSArray <UIViewController *>*)viewControllers selectIndex:(NSInteger)selectedIndex{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        
        [self createUI];
        self.titles = titles;
        self.viewControllers = viewControllers;
        self.selectedIndex = selectedIndex;
        
    }
    
    return self;
}

// 当视图即将加入父视图时 / 当视图即将从父视图移除时调用
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self selecteViewControllerIndex:_selectedIndex];
}
// 1. 添加到控制器上作为子控制器 | 添加到view上显示。
- (void)showInViewController:(UIViewController *)viewController addView:(UIView *)view {
    [viewController addChildViewController:self.pageViewController];
    NSLog(@"-------%@",@(self.pageViewController.view.frame));
    [view addSubview:self];
}
// 2. 添加到 UINaviationController
- (void)showInNavigationController:(UINavigationController *)navigationController {
    [navigationController.topViewController.view addSubview:self];
    [navigationController.topViewController addChildViewController:self.pageViewController];
    navigationController.topViewController.navigationItem.titleView = self.segmentedControl;
    self.pageViewController.view.frame = self.bounds;
    self.segmentedControl.backgroundColor = [UIColor clearColor];
}


#pragma mark - craet ui
- (void)createUI {
    [self addSubview:self.segmentedControl];
    [self addSubview:self.pageViewController.view];
}


#pragma mark - action
// index-page controller exchange.
- (void)selecteViewControllerIndex:(NSInteger)index {
    __weak __typeof(self)weakSelf = self;
    [self.pageViewController setViewControllers:@[_viewControllers[index]] direction:index<_selectedIndex animated:YES completion:^(BOOL finished) {
        _selectedIndex = index;
        [weakSelf performSwitchDelegateMethod];
    }];
    
}

#pragma mark - UISegmentedControl 事件
- (void)segmentValueChanged:(UISegmentedControl *)SegmentedControl {
    NSInteger index = SegmentedControl.selectedSegmentIndex;
    [self selecteViewControllerIndex:index];
}

#pragma mark - PageControlView delegate/dataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    UIViewController *vc;
    if (_selectedIndex + 1 < _viewControllers.count) {
        vc = _viewControllers[_selectedIndex + 1];
        vc.view.bounds = pageViewController.view.bounds;
    }
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    UIViewController *vc;
    if (_selectedIndex - 1 >= 0) {
        vc = _viewControllers[_selectedIndex - 1];
        vc.view.bounds = pageViewController.view.bounds;
    }
    return vc;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    self.selectedIndex = [_viewControllers indexOfObject:pageViewController.viewControllers.firstObject];
    self.segmentedControl.selectedSegmentIndex = _selectedIndex;
    [self performSwitchDelegateMethod];
}
//代理方法
- (void)performSwitchDelegateMethod {
    if ([self.delegate respondsToSelector:@selector(selectedAtIndex:)]) {
        [self.delegate selectedAtIndex:self.selectedIndex];
    }
}


#pragma mark - setter
// scroll enabled
-(void)setScrollEnabled:(BOOL)scrollEnabled{
    for (UIScrollView *scrollView in self.pageViewController.view.subviews) {
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            scrollView.scrollEnabled = NO;
        }
    }
}
- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    _segmentedControl.sectionTitles = _titles;
    _segmentedControl.selectedSegmentIndex = 0;
}
-(void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    self.segmentedControl.selectedSegmentIndex = _selectedIndex;
    [self selecteViewControllerIndex:_selectedIndex];
}

#pragma mark - getter
- (SegmentedControl *)segmentedControl {
    if (!_segmentedControl) {
        CGFloat viewWidth = CGRectGetWidth(self.frame);
        _segmentedControl= [[SegmentedControl alloc] initWithSectionTitles:self.titles];
        _segmentedControl.frame = CGRectMake(0, 0, viewWidth, SegmentHeight);
        _segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
        //indicator和文本等宽（含inset）、和segment一样宽，背景大方块，箭头
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
        //indicator位置
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        //选中indicator
        _segmentedControl.selectionIndicatorColor = UIColorFromHexInPageControlView(0xf2c22c);
        _segmentedControl.selectionIndicatorHeight = 2.0f;
        _segmentedControl.backgroundColor =[UIColor whiteColor];
        //标题属性
        _segmentedControl.titleTextAttributes = @{
                                                  NSForegroundColorAttributeName : UIColorFromHexInPageControlView(0x353535),
                                                  NSFontAttributeName:[UIFont systemFontOfSize:14.0]
                                                  };
        //选中标题属性
        _segmentedControl.selectedTitleTextAttributes =@{
                                                         NSForegroundColorAttributeName : UIColorFromHexInPageControlView(0x353535),
                                                         NSFontAttributeName:[UIFont systemFontOfSize:15.0]
                                                         };
        _segmentedControl.selectedSegmentIndex = _selectedIndex;
        [_segmentedControl addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentedControl;
}

- (UIPageViewController *)pageViewController {
    if (!_pageViewController) {
        _pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageViewController.view.frame = CGRectMake(0, SegmentHeight, self.bounds.size.width, self.bounds.size.height - SegmentHeight);
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    return _pageViewController;
}














@end



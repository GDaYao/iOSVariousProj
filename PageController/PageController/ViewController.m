////  ViewController.m
//  PageController
//
//  Created on 2019/8/12.
//  Copyright © 2019 pagecontroller. All rights reserved.
//


/** UIPageController 保存使用。
 */


#import "ViewController.h"


//
#import "PageControlSuperView.h"
#import "TestSubPageView.h"



@interface ViewController ()


@property (nonatomic,strong)PageControlSuperView *testPageV;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self createPageController];
    
}

#pragma mark - create page controller
- (void)createPageController {
    
    float testPageVTopDis = 44.0+40.0;
    
    NSArray *titles = @[@"测试1",@"测试2",@"测试3"];
    
    TestSubPageView *page1 = [[TestSubPageView alloc]initWithFrame:CGRectZero selectedIndex:0];
    TestSubPageView *page2 = [[TestSubPageView alloc]initWithFrame:CGRectZero selectedIndex:1];
    TestSubPageView *page3 = [[TestSubPageView alloc]initWithFrame:CGRectZero selectedIndex:2];
    
    NSArray *subVArr = @[page1,page2,page3];
    
    float titleTopDis = 15.0;
    float titleHeight = 45.0;
    float subViewTopDis = titleTopDis+titleHeight+15.0;
    self.testPageV = [[PageControlSuperView alloc]initWithFrame:CGRectMake(0, testPageVTopDis, self.view.bounds.size.width, self.view.bounds.size.height) titles:titles titleNormalColor:[UIColor blackColor] titleSelectedColor:[UIColor blueColor] titleNormalFontSize:15.0 titleSelectedFontSize:18.0 views:subVArr titleHeight:45.0 titleTopDis:15.0 subViewTopDis:subViewTopDis bottomLineBtnColor:[UIColor redColor] bottomLineBtnSize:CGSizeMake(50.0, 20.0) topTitleLayoutType:topTitleLayoutType_left];
    [self.view addSubview:self.testPageV];
    
    
#ifdef DEBUG
    self.testPageV.layer.borderColor = [UIColor redColor].CGColor;
    self.testPageV.layer.borderWidth = 1.0;
#endif
    
    
}





@end



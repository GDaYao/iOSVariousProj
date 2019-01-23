//
//  DrawLineChartViewController.m
//  DrawGraph
//


#import "DrawLineChartViewController.h"


#import "DrawLineChartView.h"

@interface DrawLineChartViewController ()

@end

@implementation DrawLineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createDrawLineChartView];
    
}

- (void)createDrawLineChartView{
    DrawLineChartView *lineView = [[DrawLineChartView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:lineView];
    
    
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end

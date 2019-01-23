//
//  DrawGraphViewController.m
//  DrawGraph
//


#import "DrawGraphViewController.h"

#import "DrawGraphView.h"
#import "DrawGraphBezierPathView.h"
#import "DrawProgressViewController.h"
#import "DrawPieChartView.h"
#import "BarChartView.h"
#import "DrawLineChart/DrawLineChartViewController.h"


@interface DrawGraphViewController ()

@end

@implementation DrawGraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    [self createUI];
    
}


#pragma mark - create UI
- (void)createUI{
    
    UIButton *CGBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:CGBtn];
    CGBtn.frame = CGRectMake(50, 50, 200, 50);
    [CGBtn setTitle:@"使用CG方式绘制图形" forState:UIControlStateNormal];
    [CGBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    CGBtn.layer.borderColor = [UIColor blackColor].CGColor;
    CGBtn.layer.borderWidth = 2.0f;
    
    
    UIButton *bezierBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:bezierBtn];
    bezierBtn.frame = CGRectMake(50, 250, 350, 50);
    [bezierBtn setTitle:@"使用UIBezierPath方式绘制图形" forState:UIControlStateNormal];
    [bezierBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    bezierBtn.layer.borderColor = [UIColor blackColor].CGColor;
    bezierBtn.layer.borderWidth = 2.0f;
    
    
    UIButton *progressBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:progressBtn];
    progressBtn.frame = CGRectMake(50, 320, 350, 50);
    [progressBtn setTitle:@"使用UIBezierPath方式绘制圆形进度条" forState:UIControlStateNormal];
    [progressBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    progressBtn.layer.borderColor = [UIColor blackColor].CGColor;
    progressBtn.layer.borderWidth = 2.0f;
    
    UIButton *pieChartBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:pieChartBtn];
    pieChartBtn.frame = CGRectMake(50, 380, 350, 50);
    [pieChartBtn setTitle:@"绘制饼状图" forState:UIControlStateNormal];
    [pieChartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pieChartBtn.layer.borderColor = [UIColor blackColor].CGColor;
    pieChartBtn.layer.borderWidth = 2.0f;
    
    UIButton *barChartBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:barChartBtn];
    barChartBtn.frame = CGRectMake(50, 430, 350, 50);
    [barChartBtn setTitle:@"绘制条形图" forState:UIControlStateNormal];
    [barChartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    barChartBtn.layer.borderColor = [UIColor blackColor].CGColor;
    barChartBtn.layer.borderWidth = 2.0f;

    
    UIButton *lineChartBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.view addSubview:lineChartBtn];
    lineChartBtn.frame = CGRectMake(50, 480, 350, 50);
    [lineChartBtn setTitle:@"绘制折线图" forState:UIControlStateNormal];
    [lineChartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    lineChartBtn.layer.borderColor = [UIColor blackColor].CGColor;
    lineChartBtn.layer.borderWidth = 2.0f;
    
    
    [CGBtn addTarget:self action:@selector(createDrawWithCG) forControlEvents:UIControlEventTouchUpInside];
    [bezierBtn addTarget:self action:@selector(createDrawUIBezierPath) forControlEvents:UIControlEventTouchUpInside];
    [progressBtn addTarget:self action:@selector(createProgress) forControlEvents:UIControlEventTouchUpInside];
    [pieChartBtn addTarget:self action:@selector(drawPieChart) forControlEvents:UIControlEventTouchUpInside];
    [barChartBtn addTarget:self action:@selector(drawBarChart) forControlEvents:UIControlEventTouchUpInside];
    [lineChartBtn addTarget:self action:@selector(drawLineChart) forControlEvents:UIControlEventTouchUpInside];
    
}



- (void)createDrawWithCG{
    DrawGraphView *drawGV = [[DrawGraphView alloc]initWithFrame:self.view.frame];
    drawGV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:drawGV];
    
}

- (void)createDrawUIBezierPath{
    DrawGraphBezierPathView *bezierPathV = [[DrawGraphBezierPathView alloc]initWithFrame:self.view.frame];
    bezierPathV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bezierPathV];
    
}


- (void)createProgress{
    DrawProgressViewController *vc = [[DrawProgressViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)drawPieChart{
    DrawPieChartView *pieChartV = [[DrawPieChartView alloc]initWithFrame:self.view.frame];
    pieChartV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:pieChartV];
}

- (void)drawBarChart{
    BarChartView *barChartV = [[BarChartView alloc]initWithFrame:self.view.frame];
    barChartV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:barChartV];
}
- (void)drawLineChart{
    DrawLineChartViewController *lineChartVC = [[DrawLineChartViewController alloc]init];
    [self presentViewController:lineChartVC animated:YES completion:nil];
    
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





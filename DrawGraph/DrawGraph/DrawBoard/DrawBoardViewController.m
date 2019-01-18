//
//  DrawBoardViewController.m
//  DrawGraph
//




#import "DrawBoardViewController.h"

#import "DrawBoardView.h"

@interface DrawBoardViewController ()

@end

@implementation DrawBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self createCustomView];
    

}

#pragma mark - 实用 DrawRect 方式实现绘制方法
- (void)createCustomView{
    DrawBoardView *drawV = [[DrawBoardView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:drawV];
    
    [drawV addOperationGestureRecognizer];
    
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




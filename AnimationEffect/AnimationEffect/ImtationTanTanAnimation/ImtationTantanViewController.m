//
//  ImtationTantanViewController.m
//  AnimationEffect
//


#import "ImtationTantanViewController.h"

#import "TanTanAnimationView.h"

@interface ImtationTantanViewController ()

@end

@implementation ImtationTantanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createTantanView];
    
 
    

}

- (void)createTantanView{
    
    float width = self.view.bounds.size.width-100;
    float height = self.view.bounds.size.height-150;
    TanTanAnimationView *tantanView = [[TanTanAnimationView alloc]initWithFrame:CGRectMake(100/2, 150/2, width, height)];
    [self.view addSubview:tantanView];
    
    [tantanView createCard];
    
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

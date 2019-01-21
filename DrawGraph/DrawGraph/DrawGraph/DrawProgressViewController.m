//
//  DrawProgressViewController.m
//  DrawGraph
//


#import "DrawProgressViewController.h"

#import "DrawProgressView.h"

@interface DrawProgressViewController ()

@property (nonatomic,strong)DrawProgressView *progressView;
@property (nonatomic,strong)UILabel *progressLab;
@property (nonatomic,strong)UISlider *progressSlider;

@end

@implementation DrawProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self createUI];
    
    
}

- (void)createUI{
    self.progressView = [[DrawProgressView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,  self.view.frame.size.width)];
    self.progressView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.progressView];
    
    
    
    self.progressLab = [[UILabel alloc]initWithFrame:CGRectMake(self.progressView.frame.size.width/2, self.progressView.frame.size.height/2,100, 50)];
    self.progressLab.center = self.progressView.center;
    self.progressLab.textAlignment = NSTextAlignmentCenter;
    [self.progressView addSubview:self.progressLab];

    
    self.progressSlider = [[UISlider alloc]initWithFrame:CGRectMake(30, self.view.frame.size.width+50,self.view.frame.size.width-60, 50)];
    self.progressSlider.maximumValue = 100;
    self.progressSlider.minimumValue = 0;
    [self.view addSubview:self.progressSlider];
    
    [self.progressSlider addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)changeValue:(UISlider *)currentSlider{
    NSLog(@"log--currentSlider:%f",currentSlider.value);
    
    self.progressLab.text = [NSString stringWithFormat:@"%.2f%%",currentSlider.value];
    self.progressView.progressValue = currentSlider.value;
    
    //重新绘制进度条
    [self.progressView setNeedsDisplay];
    
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



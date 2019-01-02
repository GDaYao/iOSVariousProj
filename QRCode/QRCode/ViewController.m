//
//  ViewController.m
//  QRCode
//

// func: 二维码多个功能增加使用，参考链接: https://github.com/TheLevelUp/ZXingObjC


#import "ViewController.h"

#import "UIImage+QRCode.h"

@interface ViewController () <UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //无logo
    //    self.imageView.image = [UIImage qrImgForString:@"http://blog.zhangpeng.site" size:CGSizeMake(100, 100) waterImg:nil];
    
    //有logo -- http://blog.zhangpeng.site
    self.imageView.image = [UIImage qrImgForString:@"恭喜你扫到一个傻屌" size:CGSizeMake(100, 100) waterImg:[UIImage imageNamed:@"zy-30"]]; // testLogo
    
    self.textView.layer.borderColor = [UIColor redColor].CGColor;
    self.textView.layer.borderWidth = 1.0f;
    self.textView.delegate = self;
    
    UITapGestureRecognizer *tapV = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignResponds)];
    [self.view addGestureRecognizer:tapV];
}


- (void)resignResponds{
    [self.textView resignFirstResponder];
    
    self.imageView.image = [UIImage qrImgForString:self.textView.text size:CGSizeMake(100, 100) waterImg:[UIImage imageNamed:@"zy-30"]]; // testLogo
    
}


@end

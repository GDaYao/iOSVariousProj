//
//  ViewController.m
//  QRCode
//

// func: 二维码多个功能增加使用，参考链接: https://github.com/TheLevelUp/ZXingObjC


#import "ViewController.h"

#import "UIImage+QRCode.h"

@interface ViewController () <UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *ChangeIconBtn;
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeIcon;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //无logo
    //    self.imageView.image = [UIImage qrImgForString:@"http://blog.zhangpeng.site" size:CGSizeMake(100, 100) waterImg:nil];
    
    //有logo -- http://blog.zhangpeng.site
    self.imageView.image = [UIImage qrImgForString:@"https://itunes.apple.com/app/id1226346659" size:CGSizeMake(100, 100) waterImg:[UIImage imageNamed:@"logo.png"]]; // testlog
    
    self.textView.layer.borderColor = [UIColor redColor].CGColor;
    self.textView.layer.borderWidth = 1.0f;
    self.textView.delegate = self;
    
    self.QRCodeIcon.layer.borderColor = [UIColor redColor].CGColor;
    self.QRCodeIcon.layer.borderWidth = 1.0f;
    
    
    UITapGestureRecognizer *tapV = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignResponds)];
    [self.view addGestureRecognizer:tapV];
    
    self.imageView.userInteractionEnabled = YES;
    self.imageView.multipleTouchEnabled = YES;
    UILongPressGestureRecognizer *longTapIV = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(saveCurrentImgToAlbum)];
    [self.imageView addGestureRecognizer:longTapIV];
    
}

// 根据新的输入文字内容，重新生成新的二维码
- (void)resignResponds{
    [self.textView resignFirstResponder];
    
    if (self.QRCodeIcon == nil) {
        self.imageView.image = [UIImage qrImgForString:self.textView.text size:CGSizeMake(100, 100) waterImg:[UIImage imageNamed:@"zy-30"]]; // testLogo
    }else{
        self.imageView.image = [UIImage qrImgForString:self.textView.text size:CGSizeMake(100, 100) waterImg:self.QRCodeIcon.image];
        self.QRCodeIcon = nil;
    }
    
    
}

#pragma mark - 保存当前二维码图片到本地相册
- (void)saveCurrentImgToAlbum{
    // 这里的警告框在技术层面来说，只是为了防止多次触发保存图片action
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"是否保存图片到本地" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];

    NSLog(@"log--触发 `saveCurrentImgToAlbum` 保存图片到本地");
    
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    NSString *msg = nil ;
    if(error){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alert show];
    
    NSLog(@"log--%@",msg);
}

#pragma mark - change icon

- (IBAction)changeQRCodeIcon:(id)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self; // 如果当前控制器没有实现 `UINavigationControllerDelegate`代理或者不是UINavigationController控制器则需要实现此代理，否则会报警告，即不会调用代理方法。
    imagePickerController.allowsEditing = YES;  // allowsEditing属性 一定要设置成yes，表示照片可编辑，会出现矩形图片选择框
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //退出相册
    [picker dismissViewControllerAnimated:YES completion:^{
        //原图
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        //用户选择区域图片
        UIImage *editImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        self.QRCodeIcon.image = originalImage;
        
    }];
}





@end



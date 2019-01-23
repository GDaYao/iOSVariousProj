//
//  ViewController.m
//  CameraFunctionDevelop
//


#import "NormalViewController.h"

// 1. 导入使用相机+相册框架
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>


// 继承相机+相册代理协议
@interface NormalViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation NormalViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createUI];
    
}


#pragma mark - create UI
- (void)createUI{
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:cameraBtn];
    cameraBtn.frame = CGRectMake(50,50,200,50);
    cameraBtn.layer.borderColor = [UIColor redColor].CGColor;
    cameraBtn.layer.borderWidth = 2.0f;
    [cameraBtn setTitle:@"点击开启拍照" forState:UIControlStateNormal];
    [cameraBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    
    [cameraBtn addTarget:self action:@selector(tapCamera) forControlEvents:UIControlEventTouchUpInside];
}


- (void)tapCamera {
    
    [self cameraAuthorization];
    
    [self photoAuthorizatioin];
    
    
    
    [self createCamera];
    
}


#pragma mark - 开始创建相机对象并使用（直接调用系统相机进行操作）
- (void)createCamera{
    
    UIImagePickerController *_imagePickerController;
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    /*
     UIImagePickerControllerSourceTypePhotoLibrary, 图库
     UIImagePickerControllerSourceTypeCamera,   相机
     UIImagePickerControllerSourceTypeSavedPhotosAlbum  相册
     打开类型，默认为图库
     */
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    /*
     UIModalTransitionStyleCoverVertical = 0,   底部滑入
     UIModalTransitionStyleFlipHorizontal,  水平翻转
     UIModalTransitionStyleCrossDissolve,   交叉溶解
     UIModalTransitionStylePartialCurl, 翻页
     弹出动画效果
     */
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    _imagePickerController.allowsEditing = YES; //允许编辑，设为NO则直接选中，YES可以调整位置
    
    BOOL camera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];  //是否支持相机功能，其他类型也可判断
    NSLog(@"%d",camera);
    
    /*
     UIImagePickerControllerQualityTypeHigh = 0,       // highest quality
     UIImagePickerControllerQualityTypeMedium = 1,     // medium quality, suitable for transmission via Wi-Fi
     UIImagePickerControllerQualityTypeLow = 2,         // lowest quality, suitable for tranmission via cellular network
     UIImagePickerControllerQualityType640x480 NS_ENUM_AVAILABLE_IOS(4_0) = 3,    // VGA quality
     UIImagePickerControllerQualityTypeIFrame1280x720 NS_ENUM_AVAILABLE_IOS(5_0) = 4,
     UIImagePickerControllerQualityTypeIFrame960x540 NS_ENUM_AVAILABLE_IOS(5_0) = 5,
     
     拍摄的照片质量，用于不同网络状态下，比如wifi下发送高、中质量的图片，蜂窝数据下发送低质量的图片，默认中等
     */
    _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    /*
     UIImagePickerControllerCameraDeviceRear,   后置摄像头
     UIImagePickerControllerCameraDeviceFront   前置摄像头
     默认后置摄像头，注意：只有在相机类型时才可使用
     */
    if (_imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
        _imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    
    /*
     typedef NS_ENUM(NSInteger, UIImagePickerControllerCameraFlashMode) {
     UIImagePickerControllerCameraFlashModeOff  = -1,   关闭闪光灯
     UIImagePickerControllerCameraFlashModeAuto = 0,    自动
     UIImagePickerControllerCameraFlashModeOn   = 1 开启
     默认自动,注意：只有在相机类型时才可使用
     */
    if (_imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
        _imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
    }
    
    if (_imagePickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
        _imagePickerController.showsCameraControls = YES;    //显示默认UI，NO会隐藏掉标准UI
    }
    
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}



#pragma mark - 相机授权+相册授权

- (void)cameraAuthorization{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            //程序是第一次启动，发起授权许可，不管用户接受还是拒绝，只会弹出一次
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    //第一次用户接受
                    NSLog(@"用户接受");
                }else{
                    //用户拒绝
                    NSLog(@"用户拒绝");
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            NSLog(@"已开启相机权限");
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户已经拒绝过授权，或者相机设备无法访问
            NSLog(@"没有权限");
            break;
        default:
            break;
    }
    
}

- (void)photoAuthorizatioin{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
            {
                // 用户拒绝，跳转到自定义提示页面
                NSLog(@"用户拒绝");
            }
            else if (status == PHAuthorizationStatusAuthorized)
            {
                // 用户授权，弹出相册对话框
                NSLog(@"用户同意");
            }
        });
    }];
    
}




@end




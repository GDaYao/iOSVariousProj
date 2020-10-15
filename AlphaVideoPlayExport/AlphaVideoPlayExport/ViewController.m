////  ViewController.m
//  AlphaVideoPlayExport
//
//  Created on 2020/8/28.
//  Copyright © 2020 dayao. All rights reserved.
//

#import "ViewController.h"

#import <iOSCompanySDK/AVSDKAssetAlphaJoinBgImgExportVideo.h>


@interface ViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@end

@implementation ViewController


#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    
    //
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"点击" forState:UIControlStateNormal];
    [nextBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    nextBtn.layer.borderColor = [UIColor redColor].CGColor;
    nextBtn.layer.borderWidth = 1.0;
    [self.view addSubview:nextBtn];
    nextBtn.frame = CGRectMake(50, 100, 80, 80);
    [nextBtn addTarget:self action:@selector(tapNextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}



#pragma mark - action
- (void)tapNextBtnAction {
    int i = 1;
    if (i == 1) {
        [self selectAlbum];
    }else{
        [self tapDirectlyNextBtnAction];
    }
    
}

- (void)exportVideoGetNotification {
    
    self.view.backgroundColor = [UIColor redColor];
    
    
}

#pragma mark - 方法1
// select Album + Delegate
- (void)selectAlbum {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES; //  allowsEditing属性⼀一定要设置成yes，表示照⽚片可编辑，会出现矩形图⽚片选择框
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if (@available(iOS 13.0,*)) {
        imagePickerController.modalPresentationStyle =  UIModalPresentationFullScreen;
    }
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    //退出相册
    [picker dismissViewControllerAnimated:YES completion:^{
        
        // 使用 - 原图
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // 使⽤- 用户选择区域图⽚
        UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        
        NSString *rgbFilePath = [[NSBundle mainBundle]pathForResource:kVideoColorStr ofType:@""];
        NSString *alphaFilePath = [[NSBundle mainBundle]pathForResource:kVideoMaskStr ofType:@""];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths firstObject];
        NSString *tmpOutPath = [documentsDirectory stringByAppendingFormat:@"/tmpOut.mp4"];
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:tmpOutPath]) {
            [fm removeItemAtPath:tmpOutPath error:nil];
        }
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(exportVideoGetNotification) name:kAlphaVideoCombineImgFinishNotification object:nil];
        
        AVSDKAssetAlphaJoinBgImgExportVideo *exportMgr= [AVSDKAssetAlphaJoinBgImgExportVideo aVSDKAssetAlphaJoinBgImgExportVideo];
        
        [exportMgr loadAVAnimationResourcesWithMovieRGBFilePath:rgbFilePath movieAlphaFilePath:alphaFilePath outPath:tmpOutPath bgCoverImg:editImage bgCoverImgPoint:CGPointMake(0,301) needCoverImgSize:CGSizeMake(540,568)];
        
    }];
}


#pragma mark - 方法二
- (void)tapDirectlyNextBtnAction {

//    [self.navigationController pushViewController:nextAlphaPlayVC animated:YES];
    
}




#pragma mark - --- path ---
// ---- get iOS-App some file path ----
- (NSString *)getDocumentFilePath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}




@end



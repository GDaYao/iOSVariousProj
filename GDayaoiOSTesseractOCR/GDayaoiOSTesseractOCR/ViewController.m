////  ViewController.m
//  GDayaoiOSTesseractOCR
//
//  Created on 2020/1/13.
//  Copyright © 2020 GDayao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong)UIImage *currentImg;

@end

@implementation ViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self createTesseractUI];
}


#pragma mark - create ui
- (void)createTesseractUI {
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"相册" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(20, 100, 50, 50);
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 1.0;

    
    
    // action
    [btn addTarget:self action:@selector(tapSelectAlbum) forControlEvents:UIControlEventTouchUpInside];

}



#pragma mark - actoin
- (void)tapSelectAlbum {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    //picker.allowsEditing = YES;
    if (@available(iOS 13.0,*)) {
        picker.modalPresentationStyle =  UIModalPresentationFullScreen;
    }
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    
    self.currentImg = info[UIImagePickerControllerOriginalImage];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}





@end

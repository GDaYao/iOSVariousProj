////  ViewController.m
//  GDayaoiOSTesseractOCR
//
//  Created on 2020/1/13.
//  Copyright © 2020 GDayao. All rights reserved.
//

#import "ViewController.h"


//
#import <TesseractOCR/TesseractOCR.h>



@interface ViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate,G8TesseractDelegate>

@property (nonatomic,strong)UIImage *currentImg;
@property (nonatomic,strong)UIImage *editCurrentImg;


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
    picker.allowsEditing = YES;
    if (@available(iOS 13.0,*)) {
        picker.modalPresentationStyle =  UIModalPresentationFullScreen;
    }
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.currentImg = info[UIImagePickerControllerOriginalImage];
    self.editCurrentImg = info[UIImagePickerControllerEditedImage];
    
    // 选择图片 --> 识别
    [self startCallTesseractOCRWithImg:self.editCurrentImg];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - TesseractOCR 使用
- (void)startCallTesseractOCRWithImg:(UIImage *)currentImg {
    
    [self scanImgInTranslateUseTesseractWithSrcLanguage:1 targetLanguge:0 recognizeImg:currentImg isRecognized:YES complete:^(BOOL status, NSString *recognizedText) {
        if (status) {
            NSLog(@" ------ log-识别成功 ------ \n ");
            NSLog(@"%@",recognizedText);
        }else{
            NSLog(@"log-识别失败");
        }
    }];
    
}


// Tesseract
// 用于翻译时识别方法
- (void)scanImgInTranslateUseTesseractWithSrcLanguage:(NSInteger)srcLanguage targetLanguge:(NSInteger)targetLanguage recognizeImg:(UIImage *)recognizedImg isRecognized:(BOOL)isRecognized complete:(void (^)(BOOL status, NSString *recognizedText))complete {
    
    // 识别图片为空 -- 模拟器识别
    if (!recognizedImg) {
#ifdef DEBUG
        // 测试使用
        complete(YES,@"This is title.\nyou can use this to test.");
#else
        complete(NO,@"");
#endif
        return;
    }
    
    /** 处理图片:
     *  1. 修正方向
     */
    recognizedImg = [self PTAlbumMgrFixOrientationWithImg:recognizedImg];
    recognizedImg = [self scaleImgwithImg:recognizedImg imgSize:640]; // 将图片缩放至宽高小于 640。（根据经验，640 的识别结果最佳）
    
    // 使用OpengCV 增加识别精度 ---- 由于识别黑白导致精度缺失，未使用 //
    
    
    // 切换语言
    NSString *defaultLanguage = @"eng";
    if (isRecognized == YES) {
        // 1.
        //defaultLanguage = @"eng+chi_sim"; // 中文+英文识别 chi_sim
        // 2.
        NSArray *languageArr = @[@"eng",@"chi_sim",@"eng",@"eng"];
        NSString *srcLanCode = [languageArr objectAtIndex:srcLanguage];
        NSString *targetLanCode = [languageArr objectAtIndex:targetLanguage];
        //defaultLanguage = [NSString stringWithFormat:@"%@",srcLanCode]; // 识别一种语言
        defaultLanguage = [NSString stringWithFormat:@"%@+%@",srcLanCode,targetLanCode]; // 识别两种语言
    }else{
        // 1.
        NSArray *languageArr = @[@"eng",@"chi_sim",@"eng",@"eng"];
        
        NSString *srcLanCode = [languageArr objectAtIndex:srcLanguage];
        
        NSString *targetLanCode = [languageArr objectAtIndex:targetLanguage];
    
        // 使用两种语言结合使用 -- 会导致识别缓慢
        //defaultLanguage = [NSString stringWithFormat:@"%@+%@",srcLanCode,targetLanCode];
        
        // 2.
        // 使用一种语言即可 -- 加快识别速度
        defaultLanguage = [NSString stringWithFormat:@"%@",srcLanCode];
    }
    
    
    // TODO: TesseractOCR 使用
    

    
    // 1. 使用 'G8OCREngineModeTesseractOnly' engineMode
    //G8RecognitionOperation *operation = [[G8RecognitionOperation alloc]initWithLanguage:defaultLanguage];

    // 2. 使用 其它 engineMode
    G8RecognitionOperation *operation = [[G8RecognitionOperation alloc]initWithLanguage:defaultLanguage configDictionary:nil configFileNames:nil absoluteDataPath:nil engineMode:G8OCREngineModeTesseractCubeCombined]; // init language config.
    
    
    /* G8OCREngineModeTesseractOnly--速度最快但最不准确，
     *  G8OCREngineModeCubeOnly-更多的人工智能，因此速度更慢但更准确;
     * G8OCREngineModeTesseractCubeCombined-以上二者同时运行
     */
    operation.tesseract.engineMode = G8OCREngineModeTesseractCubeCombined;
    
    /** 识别段落
     */
    operation.tesseract.pageSegmentationMode = G8PageSegmentationModeAutoOnly;
    
    //operation.tesseract.image = recognizedImg;
    operation.tesseract.image = recognizedImg.g8_blackAndWhite;
    
    //    [operation.tesseract setVariableValue:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ:;,.!-()#&÷" forKey:@"tessedit_char_whitelist"];
    //    operation.tesseract.maximumRecognitionTime = 60.0;
    operation.tesseract.delegate = self;
    
    // 1. 开启新的线程，执行识别。
    operation.recognitionCompleteBlock = ^(G8Tesseract * _Nullable tesseract) {
        NSString *tesseractStr = tesseract.recognizedText;
        NSLog(@"log-recognize text:%@",tesseractStr);
        if (tesseractStr.length == 0 || !tesseractStr) {
            complete(NO,@"");
        }else{
            complete(YES,tesseractStr);
        }
    };
    UIImage *testImg = operation.tesseract.thresholdedImage;
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    [operationQueue addOperation:operation];
    
    // 2. 直接在主线程识别，卡顿。
    //    BOOL isFinishRecognize = [operation.tesseract recognize];
    //    NSLog(@"log-recognize text:%@",operation.tesseract.recognizedText);
}


#pragma mark - G8TesseractDelegate
- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    NSLog(@"log-progressImageRecognitionForTesseract-progress: %lu", (unsigned long)tesseract.progress);
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    NSLog(@"log-shouldCancelImageRecognitionForTesseract");
    
    return NO;
}





#pragma mark - 其他方法使用
#pragma mark 修正图片方向
// 纠正图片的方向
- (UIImage *)PTAlbumMgrFixOrientationWithImg:(UIImage *)currentImg {
    if (currentImg.imageOrientation == UIImageOrientationUp) return currentImg;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (currentImg.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, currentImg.size.width, currentImg.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, currentImg.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, currentImg.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (currentImg.imageOrientation)
    {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, currentImg.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, currentImg.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, currentImg.size.width, currentImg.size.height,
                                             CGImageGetBitsPerComponent(currentImg.CGImage), 0,
                                             CGImageGetColorSpace(currentImg.CGImage),
                                             CGImageGetBitmapInfo(currentImg.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    switch (currentImg.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,currentImg.size.height,currentImg.size.width), currentImg.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,currentImg.size.width,currentImg.size.height), currentImg.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}


#pragma mark - 缩放图片-并保持纵横比不变
- (UIImage *)scaleImgwithImg:(UIImage *)img imgSize:(float)imgSize {
  
    CGSize scaledSize = CGSizeMake(imgSize, imgSize);
    
    if ( img.size.width>img.size.height ) {
        float scaleFactor = img.size.height/img.size.width;
        scaledSize.height = scaledSize.width * scaleFactor;
    }else{
        float scaleFactor = img.size.width/img.size.height;
        scaledSize.width = scaledSize.height * scaleFactor;
    }
    
    UIGraphicsBeginImageContext(scaledSize);
    [img drawInRect:CGRectMake(0, 0, scaledSize.width, scaledSize.height)];
    
    UIImage *scaledImg = UIGraphicsGetImageFromCurrentImageContext();
    if(scaledImg == nil)
    {
        return img;
    }

    UIGraphicsEndImageContext();
    return scaledImg;
}





@end

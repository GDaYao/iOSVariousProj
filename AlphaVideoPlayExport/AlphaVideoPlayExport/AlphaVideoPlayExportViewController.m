////  AlphaVideoPlayExportViewController.m
//  AlphaVideoPlayExport
//
//  Created on 2020/8/28.
//  Copyright © 2020 dayao. All rights reserved.
//

#import "AlphaVideoPlayExportViewController.h"

// AVAnimator
#import "AVAnimatorView.h"
#import "AVAnimatorMedia.h"
#import "AVMvidFrameDecoder.h"
#import "AVAssetJoinAlphaResourceLoader.h"
#import "AVAssetMixAlphaResourceLoader.h"
#import "AVFileUtil.h"


@interface AlphaVideoPlayExportViewController ()



// AVAnimator
@property (nonatomic,strong)AVAnimatorView *marioView; // 展示view

@property (nonatomic,strong)AVAnimatorMedia *marioMedia; // 处理数据



@end



@interface AlphaVideoPlayExportViewController ()

@end

@implementation AlphaVideoPlayExportViewController


// <<< 2. 观察通知方式
//#ifdef DEBUG
//        [self addInjectionIIIObserver];
//#endif
- (void)addInjectionIIIObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                selector:@selector(didInject:)
                                                    name:@"INJECTION_BUNDLE_NOTIFICATION"
                                                  object:nil];
}
- (void)didInject:(NSNotification*)notification {
    NSLog(@"log-didInject执行 -- Inject #1!");
    
    self.view.backgroundColor = [UIColor redColor];
    
}

- (instancetype)init {
    self = [super init];
    if (self) {

#ifdef DEBUG
        [self addInjectionIIIObserver];
#endif
        
    }
    return self;
}


#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    [self createAVAnimatorView];
    
}


#pragma mark -
- (void)createAVAnimatorView {
    
    // TODO: 开始播放透明视频 ==>  视频播放 + 处理后
    self.marioView = [[AVAnimatorView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:self.marioView];
    self.marioView.hidden = TRUE;
    
    // 加载资源素材
    [self prepareMedia];
    
    [self showMarioViewToPlay];
    
}

// Prep the mario media
- (void) prepareMedia
{
    NSString *rgbResourceName;
    NSString *alphaResourceName;
    NSString *rgbTmpMvidFilename;
    NSString *rgbTmpMvidPath;
    
    
    // 两种文件写 -- 一个RGB写+Alpha写
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    if ( [fm fileExistsAtPath:self.mvColorStr isDirectory:&isDir] && [fm fileExistsAtPath:self.mvMaskStr isDirectory:&isDir] ) {
        
    }else{
        if ( ![[self.mvColorStr pathExtension] isEqualToString:@"mp4"] ) {
            self.mvColorStr = [NSString stringWithFormat:@"%@.mp4",self.mvColorStr];
        }
        if ( ![[self.mvMaskStr pathExtension] isEqualToString:@"mp4"] ) {
            self.mvMaskStr = [NSString stringWithFormat:@"%@.mp4",self.mvMaskStr];
        }
        
    }
    rgbResourceName = self.mvColorStr;      // @"demo-rgbT.mp4"
    alphaResourceName = self.mvMaskStr;     // @"demo-alphaT.mp4"
    // Output filename
    rgbTmpMvidFilename = [NSString stringWithFormat:@"%@.mvid",self.fileName]; // MarioRendered.mvid
    // Set to TRUE to always decode from H.264
    rgbTmpMvidPath = [AVFileUtil getTmpDirPath:rgbTmpMvidFilename];
    NSLog(@"log-loading:%@", rgbTmpMvidPath);
    
//    if ([FileToolMgr judgePathFile:rgbTmpMvidPath]) {
//        [ToolMgr hiddenLoadingUseSVProgress];
//        [LPLottieMgr removeLottieLoadingViewWithLottieView:self.lottieLoadingView];
//    }
    
#warning 临时文件不移除 -- 使用临时mvid文件加载加快加载的速度
//    [self removeItemWithPath:rgbTmpMvidPath];
    // 放在应用退出时操作删除
#warning 临时文件移除，因为占用大量内存容量。
    
    // Create Media object and link it to the animatorView
    AVAnimatorMedia *media = [AVAnimatorMedia aVAnimatorMedia];
    self.marioMedia = media;
    
    
    // 1. This loader will join 2 H.264 videos together into a single 32BPP .mvid
    AVAssetJoinAlphaResourceLoader *resLoader = [AVAssetJoinAlphaResourceLoader aVAssetJoinAlphaResourceLoader];
    resLoader.movieRGBFilename = rgbResourceName;
    resLoader.movieAlphaFilename = alphaResourceName;
    resLoader.outPath = rgbTmpMvidPath;
    resLoader.alwaysGenerateAdler = TRUE;
    resLoader.serialLoading = YES;
    // 此方法已给出解决导致包过大的问题。
    resLoader.compressed = YES;
    
    
    // 2.
    /*
     AV7zAppResourceLoader *resLoader = [AV7zAppResourceLoader aV7zAppResourceLoader];
     resLoader.archiveFilename = @"Archive.7z";
     resLoader.movieFilename = @"bass_iPad.mvid";
     resLoader.outPath = [AVFileUtil getTmpDirPath:@"bass_iPad.mvid"];
     media.resourceLoader = resLoader;
    */
    
    
    //
    AVMvidFrameDecoder *frameDecoder = [AVMvidFrameDecoder aVMvidFrameDecoder];

    media.resourceLoader = resLoader;
    media.frameDecoder = frameDecoder;

    // audio -- 声音调用方法必须放在底下处理
    //resLoader.audioFilename = self.mvColorStr; // @"demo-rgbT.mp4"

    
    // 2 FPS
    //  media.animatorFrameDuration = 1.0/2;
    // Play slowly at half speed
    //media.animatorFrameDuration = AVAnimator10FPS;
    // Play video quickly (as opposed to 10 FPS)
//      media.animatorFrameDuration = AVAnimator24FPS;
    //media.animatorFrameDuration = AVAnimator30FPS;
    
//    media.animatorRepeatCount = INT_MAX;
    
    [media prepareToAnimate];
    
    // action
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(animatorPreviousNotification) name:AVAnimatorPreparedToAnimateNotification object:media];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(animatorStartNotification:) name:AVAnimatorDidStartNotification object:media];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(animatorDoneNotification:)
                                                 name:AVAnimatorDoneNotification
                                               object:media];
}


// Hide the Label and show Mario
- (void) showMarioViewToPlay {
    
    self.marioView.hidden = FALSE;
    
    [self.marioView attachMedia:self.marioMedia];
    
    [self.marioMedia startAnimator];
    
    //  self.marioView.backgroundColor = [UIColor greenColor];
    //    if ((0)) {
    //         PHony logic to show an alpha channel X over the background
    //        self.marioView.image = [UIImage imageNamed:@"X"];
    //    }
    
}


#pragma mark AVAnimator play status
- (void)animatorPreviousNotification {
    // 提前隐藏加载动画
    NSLog(@"log-animatorPreviousNotification");
}
- (void)animatorStartNotification:(NSNotification*)notification {
    NSLog( @"log-animatorStartNotification" );
    
}

// When done animating a clip, rewind to frame 0 so that Mario's eye close
- (void)animatorDoneNotification:(NSNotification*)notification {
    
    // 播放结束
    NSLog( @"log-animatorDoneNotification" );
    
    if (self.marioMedia.animatorRepeatCount > 0) {
        // nop since looping
        NSLog( @"log-animatorDoneNotification : already looping" );
    } else {
        // 播放结束时 --> 状态
//    NSLog( @"animatorDoneNotification : show frame 0 for eyes closed" );
//            [self.marioMedia showFrame:0];
//        NSLog( @"animatorDoneNotification : show frame 0 for eyes open" );
//        [self.marioMedia showFrame:1];
    }
    
    /// 可延时s后 -- 循环播放
    BOOL isAnimating = [self.marioMedia isAnimatorRunning];

    if (isAnimating) {
        self.marioMedia.animatorRepeatCount += 1;
    } else {
        [self.marioMedia startAnimator];
    }
    
}







@end




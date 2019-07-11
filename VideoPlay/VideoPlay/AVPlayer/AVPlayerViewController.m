//
//  AVPlayerViewController.m
//  VideoPlay
//


#import "AVPlayerViewController.h"

//#import <GDYSDK/GDYSDK.h>
#import <Masonry/Masonry.h>
#import <GDYSDK/ToolM.h>
#import "AVPlayerView.h"

// for media lock screen
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>


// test
#import <GDYSDK/NetworkMgr.h>
#import <GDYSDK/ToolM.h>

@interface AVPlayerViewController ()

@property (nonatomic,strong)AVPlayerView *avPlayerV;

@property (nonatomic ,strong)  id avPlayTimeObser;
@property (assign, nonatomic)BOOL isReadToPlay;     //用来判断当前视频是否准备好播放。
@property (nonatomic,assign)BOOL isRotate;  // set screen rotate.


@end

@implementation AVPlayerViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = YES;
    
    //TODO: 开启锁屏处理多媒体事件 + 多媒体监听
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notificationRemoteControlReceivedEvent:) name:@"RemoteControlReceivedEvent" object:nil];
    
    
    
    [self configUI];
    
    self.isRotate = NO;

}
// you must use `viewWillDisappear`
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    NSLog(@"log-- viewWillTransitionToSize");
    
    if (kScreenW<kScreenH) {
        self.isRotate = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        float disY = [UIApplication sharedApplication].statusBarFrame.size.height;  //+self.navigationController.navigationBar.frame.size.height
        // 竖屏
        [self.avPlayerV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(disY+7);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@300);
        }];
        self.avPlayerV.viewFrame = CGRectMake(0, 0, kScreenW, 300);
    }else{
        self.isRotate = YES;
        [self setNeedsStatusBarAppearanceUpdate];
        
        // 横屏
        [self.avPlayerV mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(0);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(0);
        }];
        self.avPlayerV.viewFrame = CGRectMake(0, 0, kScreenW,kScreenH);
    }
}

- (BOOL)prefersStatusBarHidden
{
    NSLog(@"log--prefersStatusBarHidden");
    return self.isRotate;  //隐藏为YES，显示为NO
}

#pragma mark - ui
- (void)configUI{
    self.avPlayerV = [[AVPlayerView alloc]init];
    [self.view addSubview:self.avPlayerV];
//    self.avPlayerV.layer.borderColor = [UIColor redColor].CGColor;
//    self.avPlayerV.layer.borderWidth = 1.0f;
    
    NSString *audioPath = [[NSBundle mainBundle]pathForResource:@"play" ofType:@".mp4"];
    NSURL *url = [NSURL fileURLWithPath:audioPath];
    self.avPlayerV.videoURL = url;
    self.avPlayerV.viewFrame = CGRectMake(0, 0, kScreenW, 300);
    [self.avPlayerV configUI];
    
    // layout
    float disY = [UIApplication sharedApplication].statusBarFrame.size.height;  //+self.navigationController.navigationBar.frame.size.height
    // 竖屏
    [self.avPlayerV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(disY+7);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@300);
    }];
    
    
// add target
    [self.avPlayerV.backBtn addTarget:self action:@selector(tapBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.avPlayerV.playBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.avPlayerV.playSlider addTarget:self action:@selector(playSliderAction) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchUpOutside|UIControlEventValueChanged];
    [self.avPlayerV.fullScreenBtn addTarget:self action:@selector(tapFullScreenBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.avPlayerV.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.avPlayerV.playItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil]; // 缓冲加载情况
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avPlayFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayerV.playItem]; //监控播放完成通知
    // 监控播放进度
    [self observePlayerTimeChange];
}





#pragma mark - target method
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"status"]) {
        // 取出新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] intValue];
        switch (status) {
            case AVPlayerItemStatusFailed:
                NSLog(@"item 有误");
                self.isReadToPlay = NO;
                break;
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"准备好播放了");
                self.isReadToPlay = YES;
                float totalTime = self.avPlayerV.playItem.duration.value / self.avPlayerV.playItem.duration.timescale; // seconds
                self.avPlayerV.playSlider.maximumValue = totalTime;
                self.avPlayerV.totalTimeLab.text = [NSString stringWithFormat:@"%@",[ToolM getDifferHourMintueSecondStringFromIntTime:totalTime]];
                break;
            case AVPlayerItemStatusUnknown:
                NSLog(@"视频资源出现未知错误");
                self.isReadToPlay = NO;
                break;
            default:
                break;
        }
        // 移除监听(观察者)
        [object removeObserver:self forKeyPath:@"status"];
    }else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        NSArray *array= self.avPlayerV.playItem.loadedTimeRanges;
        //本次缓冲时间范围
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSeconds = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        //缓冲总长度
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;
        NSLog(@"log--共缓冲：%.2f",totalBuffer);

//        [object removeObserver:self forKeyPath:@"loadedTimeRanges"];
    }
}

- (void)playBtnAction:(UIButton *)playBtn{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGAffineTransform rotate;
        if (playBtn.selected == YES) {
            rotate = CGAffineTransformMakeRotation(-90);
            playBtn.transform = rotate;
        }else{
            rotate = CGAffineTransformMakeRotation(90);
        }
        playBtn.transform = rotate;
    } completion:^(BOOL finished) {
        playBtn.selected = !playBtn.selected;
        playBtn.transform = CGAffineTransformIdentity;
        if (playBtn.selected == YES) {
            [self.avPlayerV.avPlayer pause];
        }else{
            if (self.isReadToPlay) {
                [self.avPlayerV.avPlayer play];
            }
        }
        
    }];
}

- (void)playSliderAction{
    //slider的value值为视频的时间
    float seconds = self.avPlayerV.playSlider.value;
    // 让视频从指定的CMTime对象处播放。
    CMTime startTime = CMTimeMakeWithSeconds(seconds, self.avPlayerV.playItem.currentTime.timescale);
    //让视频从指定处播放
    [self.avPlayerV.avPlayer seekToTime:startTime completionHandler:^(BOOL finished) {
        if (finished) {
            //[self playBtnAction:self.avPlayerV.playBtn]; ,一直播放就可以
        }
    }];
}
//监控时间进度
- (void)observePlayerTimeChange{
    __weak typeof(self) weakSelf = self;
    self.avPlayTimeObser = [self.avPlayerV.avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        __strong typeof(self) strongSelf = weakSelf;
        // 在这里将监听到的播放进度代理出去，对进度条进行设置
        float sliderValueTime = CMTimeGetSeconds(time);
        strongSelf.avPlayerV.playSlider.value = sliderValueTime;
        if (strongSelf.isRotate) {
            strongSelf.avPlayerV.aleradyTimeLab.text = [NSString stringWithFormat:@"%@",[ToolM getDifferHourMintueSecondStringFromIntTime:sliderValueTime]];
        }else{
            // 下面不断改变的time导致一直调用viewDidLayout
            strongSelf.avPlayerV.aleradyTimeLab.text = [NSString stringWithFormat:@"%@/%@",[ToolM getDifferHourMintueSecondStringFromIntTime:sliderValueTime],strongSelf.avPlayerV.totalTimeLab.text];
        }
        NSLog(@"log--observePlayerTimeChange--%f",sliderValueTime);
        
        // update lock screen slider duration -- from self get slider value
        [strongSelf configAndUpdateLockScreenMediaInfo];
        
    }];
}

// play finish --para:AVPlayerItem
- (void)avPlayFinish{
    NSLog(@"log--play finish");
    [self playBtnAction:self.avPlayerV.playBtn];
}

- (void)tapBackBtn{
    if (self.isRotate) {
        self.isRotate = NO;
       
        NSNumber *value = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
        [[UIDevice currentDevice]setValue:value forKey:@"orientation"];
        [UIViewController attemptRotationToDeviceOrientation];
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
        [self clearAVPlayerView];
        
    }
}

- (void)tapFullScreenBtn:(UIButton *)fullScreenBtn{
    
    self.isRotate = YES;
    NSNumber *value = [NSNumber numberWithInt:UIDeviceOrientationLandscapeLeft];
    [[UIDevice currentDevice]setValue:value forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
    
}


#pragma mark - 3-4-NSNotificationCenter+锁屏和控制器的播放控制处理
- (void)notificationRemoteControlReceivedEvent:(NSNotification *)notification{
    NSLog(@"log--notificationRemoteControlReceive");
    
    UIEvent *receivedEvent = notification.userInfo[@"event"];
    if (receivedEvent.type == UIEventTypeRemoteControl)
    {
        switch (receivedEvent.subtype)
        {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                // [ stop];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                // 上一曲
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                // 下一曲
                break;
                
            case UIEventSubtypeRemoteControlPlay:
                if (self.avPlayerV.avPlayer) {
                    [self.avPlayerV.avPlayer play];
                }
                break;
                
            case UIEventSubtypeRemoteControlPause:
                //暂停歌曲时，如果有类似动画也要暂停
                if (self.avPlayerV.avPlayer) {
                    [self.avPlayerV.avPlayer pause];
                }
                
                break;
                
            default:
                break;
        }
    }
}


#pragma mark - 4-4-锁屏+控制中心信息处理
// 配置锁屏信息 + 实时更新
- (void)configAndUpdateLockScreenMediaInfo{
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        // 设置 media 名称
        [dict setObject:@"testName" forKey:MPMediaItemPropertyTitle];
        // 播放时间
        [dict setObject:@(self.avPlayerV.playSlider.value) forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        //音乐的总时间
        [dict setObject:@(self.avPlayerV.playSlider.maximumValue) forKey:MPMediaItemPropertyPlaybackDuration];
        
        // TODO:保持锁屏情况下持续播放，同时也为了保持到进度和播放器一致
        if (@available(iOS 11.0 ,*)) {
            NSLog(@"log--%lu",(unsigned long)[MPNowPlayingInfoCenter defaultCenter].playbackState);
            
            // 外部暂停在时间数值相等时
            if(self.avPlayerV.playSlider.value == self.avPlayerV.playSlider.maximumValue){
                [[MPNowPlayingInfoCenter defaultCenter]setPlaybackState:MPNowPlayingPlaybackStatePaused];
            }else
            if ([MPNowPlayingInfoCenter defaultCenter].playbackState  == MPNowPlayingPlaybackStatePaused || [MPNowPlayingInfoCenter defaultCenter].playbackState  == 0) {
                [[MPNowPlayingInfoCenter defaultCenter] setPlaybackState:MPNowPlayingPlaybackStatePlaying];
            }
        }
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        
        NSLog(@"log--configAndUpdateLockScreenMediaInfo--%f,%f,%@",self.avPlayerV.playSlider.value,self.avPlayerV.playSlider.maximumValue,dict);
    }
    
}

//#pragma mark - 后台播放控制
//- (void)autoPlayNext{
//
//    //添加后台播放任务
//    UIBackgroundTaskIdentifier bgTask = 0;
//    if([UIApplication sharedApplication].applicationState== UIApplicationStateBackground) {
//
//        NSLog(@"后台播放");
//
//        UIApplication*app = [UIApplication sharedApplication];
//
//        UIBackgroundTaskIdentifier newTask = [app beginBackgroundTaskWithExpirationHandler:nil];
//
//        if(bgTask!= UIBackgroundTaskInvalid) {
//
//            [app endBackgroundTask: bgTask];
//        }
//
//        bgTask = newTask;
//
//    }
//    else {
//
//        NSLog(@"前台播放");
//
//    }
//}


#pragma mark - 屏幕旋转
// 在屏幕旋转后触发
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
//
//}
//- (void)viewDidLayoutSubviews {
//}

//- (BOOL)shouldAutorotate{
//    return self.isRotate;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait;
//}



#pragma mark - dealloc + clear
- (void)clearAVPlayerView{
    
    if (self.avPlayerV) {
        [self.avPlayerV.avPlayer removeTimeObserver:self.avPlayTimeObser];
        
        [self.avPlayerV.avLayer removeFromSuperlayer];
        self.avPlayerV.avLayer = nil;
        self.avPlayerV.avPlayer = nil;
        
        [self.avPlayerV.playItem cancelPendingSeeks];
        [self.avPlayerV.playItem.asset cancelLoading];
        //        [self.avPlayerV.avPlayer.currentItem cancelPendingSeeks];
        //        [self.avPlayerV.avPlayer.currentItem.asset cancelLoading];
        
    }
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    //[self.avPlayerV.avPlayer removeTimeObserver:self.avPlayTimeObser];
    NSLog(@"log--dealloc");
}







@end



//
//  AVPlayerViewController.m
//  VideoPlay
//


#import "AVPlayerViewController.h"

//#import <GDYSDK/GDYSDK.h>
#import <Masonry/Masonry.h>

#import "AVPlayerView.h"

@interface AVPlayerViewController ()

@property (nonatomic,strong)AVPlayerView *avPlayerV;

@property (nonatomic ,strong)  id avPlayTimeObser;
@property (assign, nonatomic)BOOL isReadToPlay;     //用来判断当前视频是否准备好播放。
@property (nonatomic,assign)BOOL isRotate; // set screen rotate.


@end

@implementation AVPlayerViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [self configUI];
    
    self.isRotate = NO;
}
// you must use `viewWillDisappear`
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
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
    
    self.navigationController.navigationBar.hidden = NO;
    
}

//#pragma mark - layout
//- (void)viewWillLayoutSubviews{
//    [super viewWillLayoutSubviews];
//
//}


#pragma mark - ui
- (void)configUI{
    self.avPlayerV = [[AVPlayerView alloc]init];
    [self.view addSubview:self.avPlayerV];
//    self.avPlayerV.layer.borderColor = [UIColor redColor].CGColor;
//    self.avPlayerV.layer.borderWidth = 1.0f;
    

    float disY = [UIApplication sharedApplication].statusBarFrame.size.height; //+self.navigationController.navigationBar.frame.size.height
    [self.avPlayerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(disY+7);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@300);
    }];
    [self.view layoutIfNeeded];
    
    [self.avPlayerV configUI];
    
    
// add target
    [self.avPlayerV.backBtn addTarget:self action:@selector(tapBackBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.avPlayerV.playBtn addTarget:self action:@selector(playBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.avPlayerV.playSlider addTarget:self action:@selector(playSliderAction) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchUpOutside|UIControlEventValueChanged];
    [self.avPlayerV.fullScreenBtn addTarget:self action:@selector(tapFullScreenBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.avPlayerV.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.avPlayerV.playItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil]; // 缓冲加载情况
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avPlayFinisn) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avPlayerV.playItem]; //监控播放完成通知
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
                self.avPlayerV.playSlider.maximumValue = self.avPlayerV.playItem.duration.value / self.avPlayerV.playItem.duration.timescale; // seconds
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
//        if (self.delegate && [self.delegate respondsToSelector:@selector(updateBufferProgress:)]) {
//            [self.delegate updateBufferProgress:totalBuffer];
//        }
        [object removeObserver:self forKeyPath:@"loadedTimeRanges"];
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
        NSLog(@"log--%f",sliderValueTime);
    }];
}
// play finish --para:AVPlayerItem
- (void)avPlayFinisn{
    NSLog(@"log--play finish");
    [self playBtnAction:self.avPlayerV.playBtn];
}

- (void)tapBackBtn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapFullScreenBtn:(UIButton *)fullScreenBtn{
//    [self.avPlayerV setNeedsLayout];
    
    self.isRotate = YES;
    NSNumber *value = [NSNumber numberWithInt:UIDeviceOrientationLandscapeLeft];
    [[UIDevice currentDevice]setValue:value forKey:@"orientation"];
    [UIViewController attemptRotationToDeviceOrientation];
    
}

#pragma mark - 屏幕旋转
//- (BOOL)shouldAutorotate{
//    return self.isRotate;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
//    return UIInterfaceOrientationPortrait;
//}



#pragma mark - dealloc
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //[self.avPlayerV.avPlayer removeTimeObserver:self.avPlayTimeObser];
    NSLog(@"log--dealloc");
}



@end



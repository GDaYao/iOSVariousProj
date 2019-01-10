//
//  FreeStreamerViewController.m
//  VideoPlay
//

#import "FreeStreamerViewController.h"


// 锁屏界面使用
#import <MediaPlayer/MPMediaItem.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>


// import `Free Streamer` ==> FSAudioStream
#import <FreeStreamer/FSAudioStream.h>
// import `Free Streamer` ==> FSAudioStream
#import <FreeStreamer/FSAudioController.h>

#import "FreeStreamerView.h"
#import "MusicSliderView.h"



@interface FreeStreamerViewController ()

// 1.
@property (nonatomic,strong)FSAudioStream *audioStream;
// 2.
@property (nonatomic,strong)FSAudioController *audioController;


@property (nonatomic,strong)NSTimer *timer;

//set UI
@property (nonatomic,strong)FreeStreamerView *streamerView;
@property (nonatomic,strong)MusicSliderView *sliderView;
// 确定播放时间And锁屏上确定时间 + total time
@property (nonatomic,assign)NSInteger playTime;
@property (nonatomic,assign)NSInteger totalTime;



@end

@implementation FreeStreamerViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor grayColor];
    
    // 保留使用顶部导航栏
    //self.navigationController.navigationBar.hidden = YES;
    
    [self configUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"This is test title";
    
    // 需要做某些判断进行相应处理
    
    // 重置旋转动画
    [self.streamerView reloadNew];
    [self renewUpdateRadioInfomation];
    
}


#pragma mark - config UI
- (void)configUI{
// 转盘
    self.streamerView = [[FreeStreamerView alloc] initWithFrame:CGRectMake(0,64 + 30, [UIScreen mainScreen].bounds.size.width,300 + 80)];
    self.streamerView.backgroundColor = [UIColor clearColor];
    __weak typeof(self) weakSelf = self;
    self.streamerView.isPlayer = ^(BOOL yes){
        
        // TODO: FSAudioStream pause暂停
        [weakSelf.audioStream pause]; // 设置暂停
        
        if (yes) {
            // 计时器开始
            [weakSelf.timer setFireDate:[NSDate distantPast]];
            NSLog(@"log--NSTimer play");
        }
        else
        {
            // 计时器暂停
            [weakSelf.timer setFireDate:[NSDate distantFuture]];
            NSLog(@"log-- NSTimer pause");
        }
    };
    self.streamerView.scrollViewDidEndDecelerating = ^(UIScrollView *scrollView,BOOL isScroll) {
        
        if (isScroll) {
            [weakSelf nextOne];
        }
        else
        {
            [weakSelf lastOne];
        }
    };
    [self.view addSubview:self.streamerView];
    
// 进度条
    _sliderView = [[MusicSliderView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.streamerView.frame) + 30, [UIScreen mainScreen].bounds.size.width - 40, 30)];
    [self.view addSubview:_sliderView];
    _sliderView.sliderValueChangeWithCallback = ^(UISlider *slider) {
        
        [weakSelf dragSliderEnd:slider];
    };
    
// next one or last one button
    UIButton *prevButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    prevButton.tag = 10;
    prevButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 40 - 50, CGRectGetMaxY(_sliderView.frame) + 40, 40, 40);
    prevButton.tintColor = [UIColor darkGrayColor];
    [prevButton setImage:[UIImage imageNamed:@"prev"] forState:(UIControlStateNormal)];
//      延时点击，避免重复执行
//    [prevButton cf_addEventHandler:^(UIButton *btn) {
//        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(playAction:) object:btn];
//        [self performSelector:@selector(playAction:) withObject:btn afterDelay:0.5f];
//
//    } forControlEvents:(UIControlEventTouchUpInside)];
    [prevButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:prevButton];
    
    UIButton *nextButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    nextButton.tag = 11;
    nextButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 + 50, CGRectGetMaxY(_sliderView.frame) + 40, 40, 40);
    nextButton.tintColor = [UIColor darkGrayColor];
    [nextButton setImage:[UIImage imageNamed:@"next"] forState:(UIControlStateNormal)];
//    增加延时点击触发事件
//    [nextButton cf_addEventHandler:^(UIButton *btn) {
//        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(playAction:) object:btn];
//        [self performSelector:@selector(playAction:) withObject:btn afterDelay:0.5f];
//
//    } forControlEvents:(UIControlEventTouchUpInside)];
    [nextButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
}


#pragma mark - config `FreeStreamer` two method
- (void)configStreamerWithAudioStreamWithNewURL:(NSURL *)newURL{
    
    // test  URL
    NSURL *url = [NSURL URLWithString:@"http://music.163.com/song/media/outer/url?id=476592630.mp3"];
    
    //    _audioStream.strictContentTypeChecking = NO;
    //    _audioStream.defaultContentType = @"audio/mpeg";

    // 1. use `FSAudioStream`
    if (!_audioStream) {
        _audioStream = [[FSAudioStream alloc]init];
        [_audioStream playFromURL:url];
    
        _audioStream.onCompletion = ^{
            NSLog(@"log--音频播放完成");
        };
        
        _audioStream.onFailure = ^(FSAudioStreamError error, NSString *errorDescription) {
            NSLog(@"播放过程中发生错误，错误信息：%@",errorDescription);
            //
            
        };
    }
    else
    {
        _audioStream.url = url;     // 在 FSAudioStream 已经初始化完成后，从新进行URL的赋值
    }
    [_audioStream play];
    
    self.sliderView.nowTimeLabel.text = @"00:00";
    self.sliderView.totalTimeLabel.text = @"00:00";
    
    if (!self.timer) {
        //进度条
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playerProgress) userInfo:nil repeats:YES];
    }
    else
    {
        [self.timer setFireDate:[NSDate distantPast]];// 计时器开始
    }
}

- (void)configStreamerWithAudioController{
    // 2. use `FSAudioController`
    _audioController = [[FSAudioController alloc] init];
    _audioController.url = [NSURL URLWithString:@"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4"];
    [_audioController play];
    
}

- (void)playerProgress
{
    FSStreamPosition position = self.audioStream.currentTimePlayed;
    
    self.playTime = round(position.playbackTimeInSeconds);//四舍五入整数值
    
    double minutes = floor(fmod(self.playTime/60.0,60.0));//返回不大于()中的最大整数值
    double seconds = floor(fmod(self.playTime,60.0));
    
    self.sliderView.nowTimeLabel.text = [NSString stringWithFormat:@"%02.0f:%02.0f",minutes, seconds];
    self.sliderView.slider.value = position.position;//播放进度
    
    self.totalTime = position.playbackTimeInSeconds/position.position;
    //判断分母为空时的情况
    if ([[NSString stringWithFormat:@"%ld",(long)self.totalTime] isEqualToString:@"nan"]) {
        
        self.sliderView.totalTimeLabel.text = @"00:00";
    }
    else
    {
        
        double minutes2 = floor(fmod(self.totalTime/60.0,60.0));
        double seconds2 = floor(fmod(self.totalTime,60.0));
        self.sliderView.totalTimeLabel.text = [NSString stringWithFormat:@"%02.0f:%02.0f",minutes2, seconds2];
    }
    
    /// 更新锁屏播放进度
    [self configNowPlayingInfoCenter];
    
}


#pragma mark - target action
- (void)playAction:(UIButton *)btn{
    if (btn.tag == 10) {
        [self.streamerView scrollLeftWithLastOne];
    }else if(btn.tag == 11){
        [self.streamerView scrollRightWithNextOne];
    }
}
- (void)nextOne{
    
    [self.timer setFireDate:[NSDate distantFuture]];
    
    //TODO:FSAudioStream stop停止
    [self.audioStream stop];
    
    /**
     * 从新更新下一首歌曲所需要更变界面的参数
     */
    
    [self renewUpdateRadioInfomation];
    
}
- (void)lastOne{
    
    [self.timer setFireDate:[NSDate distantFuture]];
    
    //TODO:FSAudioStream stop停止
    [self.audioStream stop];
    
    /**
     * 从新更新上一首歌曲所需要更变界面的参数
     */
    
    [self renewUpdateRadioInfomation];
    
}

- (void)dragSliderEnd:(UISlider *)slider{
    //滑动到底时，播放下一曲
    if (slider.value == 1) {
        [self.streamerView scrollRightWithNextOne];
    }
    else
    {
        if (slider.value > 0)
        {
        // TODO: progress 进度调整
            // 初始化一个 FSStreamPosition 结构体
            FSStreamPosition pos;
            //只对position赋值
            pos.position = slider.value;
            [self.audioStream seekToPosition:pos];// 到指定位置播放
        }
    }
}

- (void)renewUpdateRadioInfomation{
    
    // next url
    [self configStreamerWithAudioStreamWithNewURL:nil];
    
    // 对于有些需要加入上一首和下一首的歌曲的详细信息，更新锁屏界面内容
    
    // update center rotate image
    self.streamerView.centerRotationView.rotateIV.image = [UIImage imageNamed:@"RotateImg1"]; // RotateImg1,RotateImg2,RotateImg3
    
    
}


#pragma mark - 锁屏事件控制
- (void)remoteControl:(NSNotification *)note
{
    UIEvent *receivedEvent = note.userInfo[@"event"];
    if (receivedEvent.type == UIEventTypeRemoteControl)
    {
        switch (receivedEvent.subtype)
        {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self.audioStream stop];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self.streamerView scrollLeftWithLastOne];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self.streamerView scrollRightWithNextOne];
                break;
                
            case UIEventSubtypeRemoteControlPlay:
                [self.streamerView playOrPause];
                break;
                
            case UIEventSubtypeRemoteControlPause:
                //暂停歌曲时，动画也要暂停
                [self.streamerView playOrPause];
                break;
                
            default:
                break;
        }
    }
}

//锁屏显示信息
- (void)configNowPlayingInfoCenter
{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        
        [dict setObject:@"testMusicName" forKey:MPMediaItemPropertyTitle];
        
        [dict setObject:@(self.playTime)forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
        //音乐的总时间
        [dict setObject:@(self.totalTime)forKey:MPMediaItemPropertyPlaybackDuration];
        
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
}

//后台播放控制
-(void)autoPlayNext{
    
    //添加后台播放任务
    UIBackgroundTaskIdentifier bgTask = 0;
    if([UIApplication sharedApplication].applicationState== UIApplicationStateBackground) {
        
        NSLog(@"后台播放");
        
        UIApplication*app = [UIApplication sharedApplication];
        
        UIBackgroundTaskIdentifier newTask = [app beginBackgroundTaskWithExpirationHandler:nil];
        
        if(bgTask!= UIBackgroundTaskInvalid) {
            
            [app endBackgroundTask: bgTask];
        }
        
        bgTask = newTask;
        [self nextOne];
    }
    else {
        
        NSLog(@"log--前台播放");
        [self.streamerView scrollRightWithNextOne];
        
    }
}






@end





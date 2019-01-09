//
//  FreeStreamerViewController.m
//  VideoPlay
//

#import "FreeStreamerViewController.h"

// import `Free Streamer` ==> FSAudioStream
#import <FreeStreamer/FSAudioStream.h>
// import `Free Streamer` ==> FSAudioStream
#import <FreeStreamer/FSAudioController.h>

@interface FreeStreamerViewController ()

// 1.
@property (nonatomic,strong)FSAudioStream *audioStream;
// 2.
@property (nonatomic,strong)FSAudioController *audioController;



@property (nonatomic,strong)NSTimer *timer;


@end

@implementation FreeStreamerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 保留使用顶部导航栏
    //self.navigationController.navigationBar.hidden = YES;
    
    [self configUI];
    
    
}


#pragma mark - config UI
- (void)configUI{
    
    
    [self configStreamerWithAudioStreamWithNewURL:nil];
    
}



#pragma mark - config `FreeStreamer` two method
- (void)configStreamerWithAudioStreamWithNewURL:(NSURL *)newURL{
    
    // test  URL
    NSURL *url = [NSURL URLWithString:@"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4"];
    
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
        _audioStream.url = url; // 在 FSAudioStream 已经初始化完成后，从新进行URL的赋值
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




#pragma mark - target action










@end





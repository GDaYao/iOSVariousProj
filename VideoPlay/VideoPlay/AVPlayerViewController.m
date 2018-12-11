//
//  AVPlayerViewController.m
//  VideoPlay
//


#import "AVPlayerViewController.h"

// 1. import <AVFoundationxxx>
#import <AVFoundation/AVFoundation.h>




@interface AVPlayerViewController ()
@property (nonatomic,strong)AVPlayer *avPlayer;
@end

@implementation AVPlayerViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configUIVideoPlay];
}



#pragma mark - config ui
- (void)configUIVideoPlay{
 // 简书： https://www.jianshu.com/p/746cec2c3759
    
    //网络视频播放
//    NSString *playString = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
//    NSURL *url = [NSURL URLWithString:playString];
    
    //本地视频播放
    NSString *audioPath = [[NSBundle mainBundle]pathForResource:@"play" ofType:@".mp4"];
    NSURL *url = [NSURL fileURLWithPath:audioPath];
    
// 1. 播放单元 -- 设置播放的项目
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:url];
    //初始化player对象
    self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
// 2.播放界面 -- 设置播放页面
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:_avPlayer];
    //设置播放页面的大小
    layer.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 230); // 230 [UIScreen mainScreen].bounds.size.height
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    //设置播放窗口和当前视图之间的比例显示内容
    //1.保持纵横比；适合层范围内
    //2.保持纵横比；填充层边界
    //3.拉伸填充层边界
    /*
     第1种AVLayerVideoGravityResizeAspect是按原视频比例显示，是竖屏的就显示出竖屏的，两边留黑；
     第2种AVLayerVideoGravityResizeAspectFill是以原比例拉伸视频，直到两边屏幕都占满，但视频内容有部分就被切割了；
     第3种AVLayerVideoGravityResize是拉伸视频内容达到边框占满，但不按原比例拉伸，这里明显可以看出宽度被拉伸了。
     */
    layer.videoGravity = AVLayerVideoGravityResizeAspect;
    //添加播放视图到self.view
    [self.view.layer addSublayer:layer];
    
    //[self.avPlayer replaceCurrentItemWithPlayerItem:item];
    
// 3. 播放器 -- 视频播放
    [self.avPlayer play];
    
    
    //视频暂停
    //[self.avPlayer pause];
    
}



// paly pause
- (void)avPlayerPause{
    [self.avPlayer pause];
}








@end



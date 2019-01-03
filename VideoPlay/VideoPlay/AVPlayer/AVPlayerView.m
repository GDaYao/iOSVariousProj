//
//  AVPlayerView.m
//  VideoPlay


#import "AVPlayerView.h"

#import <Masonry/Masonry.h>
#import <GDYSDK/UILabel+CustomLabInit.h>

@implementation AVPlayerView

#pragma mark - init life cycle
- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    NSLog(@"log--AVPlayerView--layoutSubviews");
    // 重设 layer frame
    self.avLayer.frame = CGRectMake(0, 0, self.viewFrame.size.width, self.viewFrame.size.height);
   
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(8);
        make.size.equalTo(@(CGSizeMake(25, 25)));
    }];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(8);
        make.bottom.equalTo(self).offset(-10);
        make.size.equalTo(@(CGSizeMake(30, 30)));
    }];
    CGSize aleradyLabSize = [@"00:00:00/00:00:00" boundingRectWithSize:CGSizeMake(self.bounds.size.width, __FLT_MAX__) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil].size;
    [self.aleradyTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).offset(10);
        make.centerY.equalTo(self.playBtn.mas_centerY);
        make.size.equalTo(@(CGSizeMake(aleradyLabSize.width, aleradyLabSize.height)));
    }];
    [self.playSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.aleradyTimeLab.mas_right).offset(5);
        //make.right.equalTo(self).offset(-90);
        make.centerY.equalTo(self.aleradyTimeLab.mas_centerY);
    }];
    if(kScreenW<kScreenH){
        self.fullScreenBtn.hidden = NO;
        self.totalTimeLab.hidden = YES;
        // 竖屏
        [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playSlider.mas_right).offset(30);
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self.playSlider.mas_centerY);
            make.size.equalTo(@(CGSizeMake(30, 30)));
        }];
        
    }else{
        // 横屏
        self.fullScreenBtn.hidden = YES;
        self.totalTimeLab.hidden = NO;
        
          CGSize totalLabSize = [self.totalTimeLab.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, __FLT_MAX__) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:12.0]} context:nil].size;
        [self.totalTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            //make.left.equalTo(self.playSlider.mas_right).offset(30);
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self.playSlider.mas_centerY);
            make.size.equalTo(@(CGSizeMake(totalLabSize.width+15, totalLabSize.height)));
        }];
    }
}


#pragma mark - config ui
- (void)configUI{
    
    // set avLayer top avoid other control cover.
    [self configVideoPlayWithURL:self.videoURL layerFrame:CGRectMake(0,0,self.viewFrame.size.width, self.viewFrame.size.height)];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.backBtn];
    [self.backBtn setBackgroundImage:[UIImage imageNamed:@"playBackBtn"] forState:UIControlStateNormal];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.playBtn];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"playBtnPlay"] forState:UIControlStateNormal];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"playBtnPause"] forState:UIControlStateSelected];
    
    self.aleradyTimeLab = [UILabel InitLabWithBGColor:nil textColor:[UIColor whiteColor] fontName:nil fontSize:12.0 labText:@"00:00" txAlignment:NSTextAlignmentCenter];
    [self addSubview:self.aleradyTimeLab];
    
    
    
    self.playSlider = [[UISlider alloc]init];
    [self addSubview:self.playSlider];
    self.playSlider.minimumTrackTintColor = [UIColor orangeColor];
    self.playSlider.thumbTintColor = [UIColor orangeColor]; // 滑轮颜色
    [self.playSlider setThumbImage:[UIImage imageNamed:@"playSliderThumb"] forState:UIControlStateNormal];
    [self.playSlider setThumbImage:[UIImage imageNamed:@"playSliderThumb"] forState:UIControlStateHighlighted];
    
    self.totalTimeLab = [UILabel InitLabWithBGColor:nil textColor:[UIColor whiteColor] fontName:nil fontSize:12.0 labText:@"00:00" txAlignment:NSTextAlignmentLeft];
    [self addSubview:self.totalTimeLab];
   
    self.fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.fullScreenBtn];
    [self.fullScreenBtn setBackgroundImage:[UIImage imageNamed:@"playFullScreen"] forState:UIControlStateNormal];
    
    // layout
    

}

#pragma mark - config video player
- (void)configVideoPlayWithURL:(NSURL *)videoURL layerFrame:(CGRect)playerFrame{
    
    //网络视频播放
        //NSString *playString = @"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4";
    // NSString *playString = @"http://wvideo.spriteapp.cn/video/2016/0328/56f8ec01d9bfe_wpd.mp4"; // can use
    // NSURL *netUrl = [NSURL URLWithString:playString];
    // 1. 合法URL -- 本地视频播放
    //    NSString *audioPath = [[NSBundle mainBundle]pathForResource:@"play" ofType:@".mp4"];
    //    NSURL *url = [NSURL fileURLWithPath:audioPath];
    
    // 2. 播放单元 -- 设置播放的项目
    self.playItem = [[AVPlayerItem alloc] initWithURL:videoURL];    // videoURL
    
    // 3. 初始化player对象
    self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:self.playItem];
    
    // 4. 播放界面 -- 设置播放页面 -- V
    self.avLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    self.avLayer.frame = playerFrame; //
    self.avLayer.backgroundColor = [UIColor blackColor].CGColor; // or whiteColor
    //设置播放窗口和当前视图之间的比例显示内容
    //1.保持纵横比；适合层范围内
    //2.保持纵横比；填充层边界
    //3.拉伸填充层边界
    /*
     第1种AVLayerVideoGravityResizeAspect是按原视频比例显示，是竖屏的就显示出竖屏的，两边留黑；
     第2种AVLayerVideoGravityResizeAspectFill是以原比例拉伸视频，直到两边屏幕都占满，但视频内容有部分就被切割了；
     第3种AVLayerVideoGravityResize是拉伸视频内容达到边框占满，但不按原比例拉伸，这里明显可以看出宽度被拉伸了。
     */
    self.avLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer addSublayer:self.avLayer];
    
    //[self.avPlayer replaceCurrentItemWithPlayerItem:item];
    
    // 5. 播放器 -- 视频播放
    [self.avPlayer play];
    
    // KVO 监听 playItem "status"属性变化
    //[self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    
}








@end



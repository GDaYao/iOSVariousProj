//
//  AVPlayerView.h
//  VideoPlay

// func: custom AVPlayer View.

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN


#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

@interface AVPlayerView : UIView

@property (nonatomic,strong)NSURL *videoURL;
@property (nonatomic,strong)AVPlayerItem *playItem; // M
@property (nonatomic,strong)AVPlayer *avPlayer; // C
@property (nonatomic,strong)AVPlayerLayer *avLayer; // V
// btn
@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)UILabel *aleradyTimeLab; // this value with vc change.
@property (nonatomic,strong)UILabel *totalTimeLab;
@property (nonatomic,strong)UIButton *playBtn; // 播放按钮
@property (strong, nonatomic)UISlider *playSlider;    // 用来现实视频的播放进度，并且通过它来控制视频的快进快退。
@property (nonatomic,strong)UIButton *fullScreenBtn;

@property (nonatomic,assign)CGRect viewFrame;
- (void)configUI;




@end


NS_ASSUME_NONNULL_END

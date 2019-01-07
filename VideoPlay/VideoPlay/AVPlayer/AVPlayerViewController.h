//
//  AVPlayerViewController.h
//  VideoPlay

// func: AVPlayer implement video play
/**
 AVPlayer is belong to  AVFoundation framework
 1. 能够播放视频、音频，支持本地和网络链接地址视频。
 2. 支持边下边播放。
 3. 后台播放的处理。
 
 缺点:
 
    1. 体验不是很好，如可能会出现缓存不播放或者播放出错等问题。
 
 参考链接: https://www.jianshu.com/p/71ab0e828c0a
 
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVPlayerViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

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
 
 参考链接:
    https://www.cnblogs.com/v2m_/p/8575622.html -- 常用属性设置
    http://msching.github.io/blog/2014/11/06/audio-in-ios-8/
    http://www.samirchen.com/ios-avaudiosession-3/
 
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVPlayerViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

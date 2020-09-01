//
//  AVAnimatorH264AlphaPlayer.h
//
//  Created by Moses DeJong on 2/27/16.
//
//  License terms defined in License.txt.
//
// The AVAnimatorH264AlphaPlayer class provides a self contained player
// for a mixed H264 video that contains both RGB + Alpha channels of
// data encoded as interleaved frames. This class extends GLKView
// and provides functionality that decodes video data from a resource
// file or regular file and then sends the video data to the view.
// Any audio data contained in the asset is ignored.
//
// Because of the way iOS implements asset loading, it is not possible
// to seamlessly loop an asset video. The prepareToAnimate method must be
// invoked in order to kick off an animation loop, then the startAnimator
// method should be invoked in the AVAnimatorPreparedToAnimateNotification
// callback. The asset must be loaded on a background thread to avoid
// blocking the main thread before each animation cycle can begin.
//
// Note that playback on iOS supports only video data encoded at
// 30 FPS (the standard 29.97 FPS is close enough). Playback will
// smoothly render at exactly 30 FPS via a display link timed
// OpenGL render and a high prio background thread. Note that the
// caller should be careful to invoke stopAnimator when the view
// is going away or the whole app is going into the background.

/** func:
    AVAnimatorH264AlphaPlayer 类提供混合型H264视频，包含RGB + Alpha 通道的数据编码为交错帧。
 此类扩展了CLKView提供了从资源文件中解码视频数据，并且在视图中呈现视频数据的功能。
 音频数据在asset中是被忽略了。
 
 由于iOS实现asset 加载的方法原因，它是不可能无缝循环播放asset视频的，此`prepareToAnimate` 方法必须被调用为了开始执行动画循环，
 之后在接收到 `AVAnimatorPreparedToAnimateNotification` 通知回调后在调用  `startAnimator` 方法。
 此asset资产必须在后台进程加载了为了避免阻塞主线程在每个动画循环开始之前。
 
 请注意，iOS上的播放仅支持以30FPS编码的视频数据（标准29.97 FPS足够接近）。回放将通过显示链接定时OpenGL渲染和高prio背景线程，以30FPS的速度平滑渲染。
 请注意，当视图消失或整个应用进入后台时，调用者应谨慎调用stopAnimator方法。
 
 
 
 */


#import "AVAssetConvertCommon.h"

#if defined(HAS_AVASSET_READ_COREVIDEO_BUFFER_AS_TEXTURE)

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "AVAssetFrameDecoder.h"

// These notifications are delived from the AVAnimatorH264AlphaPlayer

#define AVAnimatorPreparedToAnimateNotification @"AVAnimatorPreparedToAnimateNotification"
#define AVAnimatorFailedToLoadNotification @"AVAnimatorFailedToLoadNotification"

#define AVAnimatorDidStartNotification @"AVAnimatorDidStartNotification"
#define AVAnimatorDidStopNotification @"AVAnimatorDidStopNotification"


@interface AVAnimatorH264AlphaPlayer : GLKView

// static ctor : create view that has the screen dimensions
+ (AVAnimatorH264AlphaPlayer*) aVAnimatorH264AlphaPlayer;

// static ctor : create view with the given dimensions
+ (AVAnimatorH264AlphaPlayer*) aVAnimatorH264AlphaPlayerWithFrame:(CGRect)viewFrame;

// Set this property to indicate the name of the asset to be
// loaded as a result of calling startAnimator.

@property (atomic, copy) NSString *assetFilename;

@property (atomic, retain) AVAssetFrameDecoder *frameDecoder;

// In DEBUG mode, this property can be set to a directory and each rendered
// output frame will be captured as BGRA and saved in a PNG.

#if defined(DEBUG)
@property (nonatomic, copy) NSString *captureDir;
#endif // DEBUG

// Invoke this metho to read from the named asset and being loading initial data

- (void) prepareToAnimate;

// After an animator has been prepared and the AVAnimatorPreparedToAnimateNotification has
// been delivered this startAnimator API can be invoked to actually kick off the playback loop.

- (void) startAnimator;

// Stop playback of animator, nop is not currently animating

- (void) stopAnimator;

@end

#endif // HAS_AVASSET_READ_COREVIDEO_BUFFER_AS_TEXTURE

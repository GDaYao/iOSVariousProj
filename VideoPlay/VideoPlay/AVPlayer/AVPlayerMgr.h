////  AVPlayerMgr.h
//  VideoPlay
//
//  Created on 2021/8/26.
//  Copyright © 2021 Dayao. All rights reserved.
//


/** func: AVPlayer manager.
 *
 *
 */


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface AVPlayerMgr : NSObject

@property (nonatomic,strong)AVPlayer *avplayer;
@property (nonatomic,strong)AVPlayerLayer *avplayerlayer;


- (void)createOrChangeAVPlayerVideoMgrWithVideoUrl:(NSURL *)playerVideoUrl playVideoSuperView:(UIView *)playerVideoSuperView;


- (void)AVPlayerVideoMgrPlay;
- (void)AVPlayerVideoMgrPause;



@end

NS_ASSUME_NONNULL_END

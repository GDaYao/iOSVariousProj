////  AVPlayerMgr.m
//  VideoPlay
//
//  Created on 2021/8/26.
//  Copyright © 2021 Dayao. All rights reserved.
//

#import "AVPlayerMgr.h"


@implementation AVPlayerMgr

#pragma mark - init
- (void)createOrChangeAVPlayerVideoMgrWithVideoUrl:(NSURL *)playerVideoUrl playVideoSuperView:(UIView *)playerVideoSuperView {
    
    if ( playerVideoUrl == nil ) {
        NSLog(@"log-test-playerVideoUrl-nil");
        return;
    }
    
    //
    AVPlayerItem *playeritem = [[AVPlayerItem alloc]initWithURL:playerVideoUrl];
    
    
    if (!self.avplayer) {
        self.avplayer = [[AVPlayer alloc]initWithPlayerItem:playeritem];
    }else{
        [self removePlayerObserver];
        [self.avplayer replaceCurrentItemWithPlayerItem:playeritem];
    }
    [self addPlayerObserver];
    
    if (!self.avplayerlayer) {
        self.avplayerlayer = [AVPlayerLayer playerLayerWithPlayer:self.avplayer];
        self.avplayerlayer.frame = playerVideoSuperView.bounds;
        self.avplayerlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [playerVideoSuperView.layer addSublayer:self.avplayerlayer];
    }
    
    // 直接播放
    [self AVPlayerVideoMgrPlay];
    
}


#pragma mark - observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"status"]) {
        if(self.avplayer.currentItem.status == AVPlayerItemStatusFailed) {
        
        }
        
        if(self.avplayer.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            NSLog(@"log-AVPlayerVideoMgr-资源准备好了");
            
            
        }
        
    }
}


#pragma mark - action
- (void)AVPlayerVideoMgrPlay {
    if (self.avplayer) {
        [self.avplayer play];
    }
}
- (void)AVPlayerVideoMgrPause {
    if (self.avplayer) {
        [self.avplayer pause];
    }
}
// 播放完成后，重置，重新播放
- (void)AVPlayerVideoMgrPlayFinish  {
    CMTime startTime = CMTimeMakeWithSeconds(0, self.avplayer.currentItem.currentTime.timescale);
    [self.avplayer seekToTime:startTime completionHandler:^(BOOL finished) {
        if (finished) {}
    }];
    [self.avplayer play];
}


#pragma mark - add play observer
- (void)addPlayerObserver {
    @try {
        if (self.avplayer.currentItem) {
            [self.avplayer.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVPlayerVideoMgrPlayFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:self.avplayer.currentItem];
        }
    } @catch (NSException *exception) {
        NSLog(@"log-addPlayItemObserver-exception");
    } @finally {
    }
}
- (void)removePlayerObserver {
    @try {
        if (self.avplayer.currentItem) {
            [self.avplayer.currentItem removeObserver:self forKeyPath:@"status"];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.avplayer.currentItem];
        }
    } @catch (NSException *exception) {
        NSLog(@"log-addPlayItemObserver-catch-1");
    } @finally {
    }
}




@end



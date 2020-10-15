////  AVSDKAssetFrameDecoder.h
//  iOSCompanySDK
//
//  Created on 2020/9/3.
//  
//

/** func:
 
    rgb+alpha 资源解码类
 
 */


#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

@class AVSDKAVFrame;
@class AVSDKCGFrameBuffer;


NS_ASSUME_NONNULL_BEGIN

@interface AVSDKAssetFrameDecoder : NSObject {
    
@private

    NSURL *m_assetURL;
    AVAssetReader *m_aVAssetReader;
    AVAssetReaderOutput *m_aVAssetReaderOutput;

    NSTimeInterval m_frameDuration;
    NSUInteger     m_numFrames;
    int            frameIndex;
    
    CGSize detectedMovieSize;
    float prevFrameDisplayTime;
    int numTrailingNopFrames;
    
    BOOL m_isOpen;
    BOOL m_isReading;
    BOOL m_readingFinished;
    
    BOOL m_produceCoreVideoPixelBuffers;
    BOOL m_produceYUV420Buffers;
    BOOL m_dropFrames;

}



// video frame time.
@property (nonatomic,assign) CMTime frameTime;


@property (nonatomic, readonly) NSUInteger  numFrames;


@property (nonatomic, assign) BOOL produceCoreVideoPixelBuffers;

@property (nonatomic, assign) BOOL produceYUV420Buffers;


/*此标志默认为TRUE，如果为TRUE，则如果指示的显示时间小于到下一帧的预期间隔时间，则解码器将丢弃一帧。 请注意，在视频一次编码一帧并且不应基于时序信息丢弃任何帧的情况下，此丢帧逻辑并不总是正确的，则应将此标志设置为FALSE。*/
// 丢弃frame-帧flag
@property (nonatomic, assign) BOOL dropFrames;

// class init
+ (AVSDKAssetFrameDecoder *)aVSDKAssetFrameDecoder;

// 判断当前src文件是否可以被读取 | 并进行读取赋值
- (BOOL) openForReading:(NSString*)assetPath;

// 取所有帧的index帧出来 - invoke 1
- (AVSDKAVFrame *) advanceToFrame:(NSUInteger)newFrameIndex;



// allocateDecodeResources
- (BOOL) allocateDecodeResources;


// getter
- (NSTimeInterval) frameDuration;
- (NSUInteger) width;
- (NSUInteger) height;



@end

NS_ASSUME_NONNULL_END

//
//  AVMvidFileWriter.h
//
//  Created by Moses DeJong on 2/20/12.
//
//  License terms defined in License.txt.
//
//  This module implements a class that handles the details of writing a .mvid
//  file. This file type is a specially optimized binary layout of pixel data
//  useful for animations and general video. Pixels in a .mvid file are optimized
//  so that regions can be blitted into memory as quickly as possible. In addition
//  memory is configured on page bounds and word bounds for maximum efficiency
//  at the cost of a little on disk space.


/** func:
    此模块实现，处理写入 .mvid 文件中的实现细节。
    此文件类型是经过特殊优化的像素数据二进制布局，可用于动画和一般视频。
    .mvid文件中的像素经过了优化，以便可以将区域尽快加载到内存。
    另外，在页边界和字边界上配置了内存，以最大程度地提高效率，但只占用少量磁盘空间。

 
 */



#import <Foundation/Foundation.h>

#import <QuartzCore/QuartzCore.h>

#import "maxvid_file.h"

@interface AVMvidFileWriter : NSObject {
@private
  NSString *m_mvidPath;
  float m_frameDuration;
  int   frameNum;
  int   m_totalNumFrames;
  MVFileHeader *mvHeader;
  void *mvFramesArray;
  uint32_t framesArrayNumBytes;
  uint32_t m_bpp;
  
  FILE *maxvidOutFile;

  off_t offset;
  CGSize m_movieSize;

  BOOL  isOpen;
  BOOL  m_genAdler;
  BOOL  m_isAllKeyframes;
  BOOL  m_genV3;
#if MV_ENABLE_DELTAS
  BOOL  m_isDeltas;
#endif // MV_ENABLE_DELTAS
}

@property (nonatomic, copy)   NSString      *mvidPath;
@property (nonatomic, assign) float         frameDuration;
@property (nonatomic, readonly) int         frameNum;
@property (nonatomic, assign) int           totalNumFrames;
@property (nonatomic, assign) BOOL          genAdler;
@property (nonatomic, assign) uint32_t      bpp;
@property (nonatomic, assign) CGSize        movieSize;

// TRUE by default, if writeDeltaframe is invoked then this
// property is set to FALSE.

@property (nonatomic, assign) BOOL          isAllKeyframes;

// Set this property to TRUE when a generated V3 file
// that contains compressed data blocks at known page
// offsets should be generated. This type of file need
// not be memory mapped and it can support much larger
// sizes that previous versions since all frame sizes
// are implicitly stored as page offsets.

@property (nonatomic, assign) BOOL          genV3;

#if MV_ENABLE_DELTAS

// FALSE by default, if the mvid file was created with the
// -deltas option then this property would be TRUE.

@property (nonatomic, assign) BOOL          isDeltas;

#endif // MV_ENABLE_DELTAS

+ (AVMvidFileWriter*) aVMvidFileWriter;

- (BOOL) open;

- (void) close;

// Write a single nop frame after a keyframe or a delta frame

- (void) writeNopFrame;

#if MV_ENABLE_DELTAS

// Write special case nop frame that appears at the begining of
// the file. The weird special case bascially means that the
// first frame is constructed by applying a frame delta to an
// all black framebuffer.

- (void) writeInitialNopFrame;

#endif // MV_ENABLE_DELTAS

// Count up the number of nop frames that would appear after the indicated
// frame display time. The currentFrameDuration is the duration that
// a frame would be displayed, it could be longer than the expected FPS
// duration indicated by the frameDuration argument.

+ (int) countTrailingNopFrames:(float)currentFrameDuration
                 frameDuration:(float)frameDuration;

// Write 0 to N trailing nop frames, pass in total frame display time

- (void) writeTrailingNopFrames:(float)frameDuration;

- (void) skipToNextPageBound;

// Write a self contained key frame. Note that the bufferSize argument
// here should contain all the pixels and any zero pading in the case
// of an odd number of pixels.

- (BOOL) writeKeyframe:(char*)ptr bufferSize:(int)bufferSize;

// This version of writeKeyframe stores a non-zero adler passed in to the method

- (BOOL) writeKeyframe:(char*)ptr bufferSize:(int)bufferSize adler:(uint32_t)adler isCompressed:(BOOL)isCompressed;

// Write a delta frame that depends on the previous frame. The adler needs to be
// generated in the caller since both previous and current frames would need to be
// decoded in order to generate the adler.

- (BOOL) writeDeltaframe:(char*)ptr bufferSize:(int)bufferSize adler:(uint32_t)adler;

- (BOOL) rewriteHeader;

@end

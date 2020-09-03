//
//  AVFrame.h
//
//  Created by Moses DeJong on 9/2/12.
//
//  License terms defined in License.txt.
//
//  This class defines a platform specific "frame" object that "contains" visual
//  information for one specific frame in an animaton or movie. Code that executes
//  only on one platform may access platform specific properties, but general
//  purpose code can safely pass around a reference to a AVFrame without platform
//  specific concerns.

/** func:
  此类定义了平台特定的“框架”对象，该对象“包含”动画或电影中一个特定框架的视觉信息。 仅在一个平台上执行的代码可以访问平台特定的属性，但是通用代码可以安全地传递对AVFrame的引用，而无需平台特定的问题。
 
    读取并处理视频每一帧。
 
 */

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <Cocoa/Cocoa.h>
#endif

@class CGFrameBuffer;

@interface AVFrame : NSObject
{
#if TARGET_OS_IPHONE
  UIImage *m_image;
#else
  NSImage *m_image;
#endif // TARGET_OS_IPHONE
  
  CGFrameBuffer *m_cgFrameBuffer;
  CVImageBufferRef m_cvBufferRef;
  BOOL m_isDuplicate;
}

#if TARGET_OS_IPHONE
@property (nonatomic, retain) UIImage *image;
#else
@property (nonatomic, retain) NSImage *image;
#endif // TARGET_OS_IPHONE

// If the frame data is already formatted as a pixel buffer, then
// this field is non-nil. A pixel buffer can be wrapped into
// platform specific image data.
// 如果帧数据已经被格式化作为像素缓冲区，则此区域非空。 像素缓冲区可以被打包进入特定的图像数据中。
@property (nonatomic, retain) CGFrameBuffer *cgFrameBuffer;

// A frame decoder might provide a buffer directly as a CoreVideo image
// buffer as opposed to an image. Typically, this ref actually points
// at a CVPixelBufferRef, but CVImageBufferRef is a more generic superclass
// ref that could also apply to an OpenGL buffer. The AVAssetFrameDecoder
// class can decode this type of CoreVideo buffer directly.

@property (nonatomic, assign) CVImageBufferRef cvBufferRef;

@property (nonatomic, assign) BOOL     isDuplicate;

// Constructor

+ (AVFrame*) aVFrame;

// If the image property is nil but the cgFrameBuffer is not nil, then
// create the image object from the contents of the cgFrameBuffer. This
// method attempts to verify that the image object is created and initialized
// as much as possible, though some image operations may still be deferred
// until the render cycle.

- (void) makeImageFromFramebuffer;

@end

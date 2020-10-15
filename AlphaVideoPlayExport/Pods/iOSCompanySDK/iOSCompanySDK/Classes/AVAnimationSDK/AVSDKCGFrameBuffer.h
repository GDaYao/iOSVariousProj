////  AVSDKCGFrameBuffer.h
//  iOSCompanySDK
//
//  Created on 2020/9/3.
//  
//


/** func:
    存储所有需要操作的 frame buffer 数据
 
 */


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface AVSDKCGFrameBuffer : NSObject {
    
@protected
    
    size_t m_bitsPerPixel;
    size_t m_bytesPerPixel;

    char *m_pixels;
    
    size_t m_numBytes;
    size_t m_numBytesAllocated;

    size_t m_width;
    size_t m_height;

    char *m_zeroCopyPixels;
    NSData *m_zeroCopyMappedData;
    int32_t m_isLockedByDataProvider;
    CGImageRef m_lockedByImageRef;
    CGColorSpaceRef m_colorspace;
}


//

//@property char * pixels;
@property (readonly) char * pixels;

@property (readonly) char *zeroCopyPixels;
@property (nonatomic, copy) NSData *zeroCopyMappedData;


@property (readonly) size_t numBytes;
@property (readonly) size_t width;
@property (readonly) size_t height;
@property (readonly) size_t bitsPerPixel;
@property (readonly) size_t bytesPerPixel;

@property (nonatomic, assign) BOOL isLockedByDataProvider;
@property (nonatomic, readonly) CGImageRef lockedByImageRef;


@property (nonatomic, assign) CGColorSpaceRef colorspace;


// AVSDKCGFrameBuffer init method
+ (AVSDKCGFrameBuffer*)avsdkCGFrameBufferWithBppDimensions:(NSInteger)bitsPerPixel
                                            width:(NSInteger)width
                                                    height:(NSInteger)height;

#pragma mark - get frame buffer
- (id) initWithBppDimensions:(NSInteger)bitsPerPixel
                       width:(NSInteger)width
                      height:(NSInteger)height;


// TODO: bytes array covert to CVPixelBufferRef
- (CVPixelBufferRef)getCVPixelBufferRefFromBytesWithWidth:(int)pixelWidth pixelHeight:(int)pixelHeight;

// 根据此缓冲区中的像素数据创建Core Graphics图像。
//使用CGImageRef时hasDataProvider属性将为TRUE。 此名称是大写字母，以避免来自analyzer工具的警告。
- (CGImageRef)createCGImageRef CF_RETURNS_RETAINED;

// render CGImgae
- (BOOL) renderCGImage:(CGImageRef)cgImageRef;

// Set all pixels to 0x0
- (void) clear;




@end

NS_ASSUME_NONNULL_END

////  AVSDKCGFrameBuffer.m
//  iOSCompanySDK
//
//  Created on 2020/9/3.
//  
//

#import "AVSDKCGFrameBuffer.h"



#ifndef __OPTIMIZE__
// Automatically define EXTRA_CHECKS when not optimizing (in debug mode)
# define EXTRA_CHECKS
#endif // DEBUG

// Alignment is not an issue, makes no difference in performance -- 使用对齐分配内存方式
//#define USE_ALIGNED_VALLOC 1

// Using page copy makes a huge diff, 24 bpp goes from 15->20 FPS to 30 FPS! -- 使用分页
#define USE_MACH_VM_ALLOCATE 1

#if defined(USE_ALIGNED_VALLOC) || defined(USE_MACH_VM_ALLOCATE)
#import <unistd.h> // getpagesize()
#endif

#if defined(USE_MACH_VM_ALLOCATE)
#import <mach/mach.h>
#endif


void AVSDKCGFrameBufferProviderReleaseData (void *info, const void *data, size_t size);


@interface AVSDKCGFrameBuffer ()

@property (readonly) size_t numBytesAllocated;


@property (nonatomic, retain) NSObject *arcRefToSelf;


@end




@implementation AVSDKCGFrameBuffer

@synthesize pixels = m_pixels;
@synthesize zeroCopyPixels = m_zeroCopyPixels;
@synthesize zeroCopyMappedData = m_zeroCopyMappedData;
@synthesize numBytes = m_numBytes;
@synthesize numBytesAllocated = m_numBytesAllocated;
@synthesize width = m_width;
@synthesize height = m_height;
@synthesize bitsPerPixel = m_bitsPerPixel;
@synthesize bytesPerPixel = m_bytesPerPixel;
//@synthesize isLockedByDataProvider = m_isLockedByDataProvider;
@synthesize lockedByImageRef = m_lockedByImageRef;
@synthesize colorspace = m_colorspace;



#pragma mark - AVSDKCGFrameBuffer alloc
+ (AVSDKCGFrameBuffer*)avsdkCGFrameBufferWithBppDimensions:(NSInteger)bitsPerPixel
                                            width:(NSInteger)width
                                           height:(NSInteger)height {
    AVSDKCGFrameBuffer *obj = [[AVSDKCGFrameBuffer alloc] initWithBppDimensions:bitsPerPixel width:width height:height];
    return obj;
}

#pragma mark - init frame buffer -- assign some property,assign memory.
- (id) initWithBppDimensions:(NSInteger)bitsPerPixel
                       width:(NSInteger)width
                      height:(NSInteger)height
{
    // Ensure that memory is allocated in terms of whole words, the
    // bitmap context won't make use of the extra half-word.
    
    size_t numPixels = width * height;
    size_t numPixelsToAllocate = numPixels;
    
    if ((numPixels % 2) != 0) {
        numPixelsToAllocate++;
    }
    
    // 16bpp -> 2 bytes per pixel, 24bpp and 32bpp -> 4 bytes per pixel
    // RGBA，一个通道一个字节，一个像素包含4个通道。
    
    size_t bytesPerPixel;
    if (bitsPerPixel == 16) {
        bytesPerPixel = 2;
    } else if (bitsPerPixel == 24 || bitsPerPixel == 32) {
        bytesPerPixel = 4;
    } else {
        bytesPerPixel = 0;
        NSAssert(FALSE, @"bitsPerPixel is invalid");
    }
    
    // 所有的像素总和所占内存字节数
    size_t inNumBytes = numPixelsToAllocate * bytesPerPixel;
    
    // FIXME: if every frame is a key frame, then don't use the kernel memory interface
    // since it would not help at all in terms of performance. Would be faster to
    // just use different buffers.
    
    // FIXME: implement runtime switch for mode, so that code can be compiled once to
    // test out both modes!
    
    char* buffer;
    
    size_t allocNumBytes; // 应该分配多大bytes字节数（分页数 * 每页bytes ）
    
#if defined(USE_MACH_VM_ALLOCATE)
    size_t pagesize = (size_t)getpagesize();
    size_t numpages = (inNumBytes / pagesize);    // 分页大小
    if (inNumBytes % pagesize) {
        numpages++;
    }
    
    vm_size_t m_size = (vm_size_t)(numpages * pagesize);
    allocNumBytes = (size_t)m_size;
    
    // mac或iOS上申请内核内存方法。 -- 内核内存都是按页管理
    kern_return_t ret = vm_allocate((vm_map_t) mach_task_self(), (vm_address_t*) &buffer, m_size, VM_FLAGS_ANYWHERE);
    
    if (ret != KERN_SUCCESS) {
        buffer = NULL;
    }
    
    // Note that the returned memory is not zeroed, the first frame is a keyframe, so it will completely
    // fill the framebuffer. Additional frames will be created from a copy of the initial frame.
#else
    
    // Regular malloc(), or page aligned malloc()
# if defined(USE_ALIGNED_VALLOC)
    size_t pagesize = getpagesize();
    size_t numpages = (inNumBytes / pagesize);
    if (inNumBytes % pagesize) {
        numpages++;
    }
    allocNumBytes = numpages * pagesize;
    buffer = (char*) valloc(allocNumBytes);
    if (buffer) {
        bzero(buffer, allocNumBytes);
    }
# else
    allocNumBytes = inNumBytes;
    buffer = (char*) malloc(allocNumBytes);
    if (buffer) {
        bzero(buffer, allocNumBytes);
    }
# endif // USE_ALIGNED_MALLOC
#endif
    
    if (buffer == NULL) {
        return nil;
    }
    
    // Verify page alignemnt of the image buffer. The self.pixels pointer must be page
    // aligned to properly support zero copy blit and whole page copy optimizations.
    
    if (1) {
        uint32_t i32val = (uint32_t)buffer;
        uint32_t pagesize = getpagesize();
        uint32_t mod = i32val % pagesize;
        
        if (mod != 0) {
            NSAssert(0, @"framebuffer is not page aligned : pagesize %d : ptr %p : ptr32 0x%08X : ptr32 mod pagesize %d",
                     pagesize,
                     buffer,
                     i32val,
                     mod);
            // Just in case NSAssert() was disabled in opt mode
            assert(0);
        }
    }
    
    if ((self = [super init])) {
        self->m_bitsPerPixel = bitsPerPixel;
        self->m_bytesPerPixel = bytesPerPixel;
        self->m_pixels = buffer;
        self->m_numBytes = inNumBytes;
        self->m_numBytesAllocated = allocNumBytes;
        self->m_width = width;
        self->m_height = height;
    } else {
        free(buffer);
    }
    
    return self;
}


#pragma mark - bytes array covert to CVPixelBufferRef
- (CVPixelBufferRef)getCVPixelBufferRefFromBytesWithWidth:(int)pixelWidth pixelHeight:(int)pixelHeight {
    // 使用pixels数组直接生成需要的CVPixelBufferRef
    CVPixelBufferRef pixelBuffer = NULL;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool : YES],           kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool : YES],           kCVPixelBufferCGBitmapContextCompatibilityKey,
                             [NSNumber numberWithInt  : pixelWidth],  kCVPixelBufferWidthKey,
                             [NSNumber numberWithInt  : pixelHeight], kCVPixelBufferHeightKey,
                             nil];
    /*
     由pixels生成CVPixelBuffer,像素格式类型kCVPixelBufferPixelFormatTypeKey/pixelFormatType,需设置成kCVPixelFormatType_32BGRA,不能使用kCVPixelFormatType_32ARGB。
     传入参数pixels是包含各个像素点的位图布局信息，二者属性有差别，bitmapInfo所以不一致会有问题，而转入image后，bitmapInfo决定位图布局信息。
     // 
     当inputPixelFormat=kCVPixelFormatType_32BGRA CGBitmapInfo的正确的设置
     uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host;
     // 或者
     uint32_t bitmapInfo = kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Host;

     当inputPixelFormat=kCVPixelFormatType_32ARGB CGBitmapInfo的正确的设置
     uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Big;
     // 或者
     uint32_t bitmapInfo = kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Big;
     
     */
    // Define a function to call when the pixel buffer is freed.

    CVPixelBufferCreateWithBytes(kCFAllocatorDefault, self.width, self.height, kCVPixelFormatType_32BGRA,(void*)self.pixels, 4*self.width, NULL, NULL, (__bridge CFDictionaryRef) options,&pixelBuffer);
    return pixelBuffer;
}

//void releaseCallback(void *releaseRefCon, const void *baseAddress) {
//    //free((void *)releaseRefCon);
//    //free((void *)baseAddress);
//    // 根据需要执行其他清理。
//    NSLog(@"log-调用释放");
//}



#pragma mark - createCGImageRef
- (CGImageRef)createCGImageRef
{
    // Load pixel data as a core graphics image object.
    // 加载像素数据作为核心图形图像对象。
    NSAssert(self.width > 0 && self.height > 0, @"width or height is zero");
    
    size_t bitsPerComponent = 0;
    size_t numComponents = 0;
    size_t bitsPerPixel = 0;
    size_t bytesPerRow = 0;
    
    if (self.bitsPerPixel == 16) {
        bitsPerComponent = 5;
        //    numComponents = 3;
        bitsPerPixel = 16;
        bytesPerRow = self.width * (bitsPerPixel / 8);
    } else if (self.bitsPerPixel == 24 || self.bitsPerPixel == 32) {
        bitsPerComponent = 8;
        numComponents = 4;
        bitsPerPixel = bitsPerComponent * numComponents;
        bytesPerRow = self.width * (bitsPerPixel / 8);
    } else {
        NSAssert(FALSE, @"unmatched bitsPerPixel");
    }
    
    CGBitmapInfo bitmapInfo = [self getBitmapInfo];
    
    CGDataProviderReleaseDataCallback releaseData = AVSDKCGFrameBufferProviderReleaseData;
    
    void *pixelsPtr = self.pixels;   // Will return zero copy pointer in zero copy mode. Otherwise self.pixels
    
    CGDataProviderRef dataProviderRef = CGDataProviderCreateWithData(
#if __has_feature(objc_arc)
                                                                     (__bridge void *)self,
#else
                                                                     self,
#endif // objc_arc
                                                                     pixelsPtr,
                                                                     self.width * self.height * (bitsPerPixel / 8),
                                                                     releaseData);
    
    BOOL shouldInterpolate = FALSE; // images at exact size already
    
    CGColorRenderingIntent renderIntent = kCGRenderingIntentDefault;
    
    CGColorSpaceRef colorSpace = self.colorspace;
    if (colorSpace) {
        CGColorSpaceRetain(colorSpace);
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGImageRef inImageRef = CGImageCreate(self.width, self.height, bitsPerComponent, bitsPerPixel, bytesPerRow,
                                          colorSpace, bitmapInfo, dataProviderRef, NULL,
                                          shouldInterpolate, renderIntent);
    
    CGDataProviderRelease(dataProviderRef);
    
    CGColorSpaceRelease(colorSpace);
    
    if (inImageRef != NULL) {
        self.isLockedByDataProvider = TRUE;
        self->m_lockedByImageRef = inImageRef; // Don't retain, just save pointer
    }
    
    return inImageRef;
}

- (CGBitmapInfo) getBitmapInfo
{
    CGBitmapInfo bitmapInfo = 0;
  if (self.bitsPerPixel == 16) {
    bitmapInfo = kCGBitmapByteOrder16Host | kCGImageAlphaNoneSkipFirst;
  } else if (self.bitsPerPixel == 24) {
    bitmapInfo |= kCGBitmapByteOrder32Host | kCGImageAlphaNoneSkipFirst;
  } else if (self.bitsPerPixel == 32) {
    bitmapInfo |= kCGBitmapByteOrder32Host | kCGImageAlphaPremultipliedFirst;
  } else {
    assert(0);
  }
    return bitmapInfo;
}

// C callback invoked by core graphics when done with a buffer, this is tricky
// since an extra ref is held on the buffer while it is locked by the
// core graphics layer.
void AVSDKCGFrameBufferProviderReleaseData (void *info, const void *data, size_t size) {
    
#ifdef DEBUG
#ifdef LOGGING
    NSLog(@"AVSDKCGFrameBufferProviderReleaseData() called");
#endif
#endif

      AVSDKCGFrameBuffer *cgBuffer;
#if __has_feature(objc_arc)
  cgBuffer = (__bridge AVSDKCGFrameBuffer *) info;
#else
    cgBuffer = (AVSDKCGFrameBuffer *) info;
#endif // objc_arc

    cgBuffer.isLockedByDataProvider = FALSE;

    // Note that the cgBuffer just deallocated itself, so the
    // pointer no longer points to valid memory.
}


#pragma mark - render CGImgae -- 会进行所有的pixels赋值。
/* 从 frameDecoder中调用，每一帧解码，获得CVImageBufferRef,转成CGImageRef,在这里进行渲染
    *** 进行所有的pixels赋值 **
*/
- (BOOL)renderCGImage:(CGImageRef)cgImageRef
{
    [self doneZeroCopyPixels];
    
    
    // Render the contents of an image to pixels.
    
    size_t w = CGImageGetWidth(cgImageRef);
    size_t h = CGImageGetHeight(cgImageRef);
    
    BOOL isRotated = FALSE;
    
    if ((w != h) && (h == self.width) && (w == self.height)) {
        // Assume image is rotated to portrait, so rotate and then render
        isRotated = TRUE;
    } else {
        // If sizes do not match, then resize input image to fit into this framebuffer
    }
    
    size_t bitsPerComponent = 0; // 8
    size_t numComponents = 0;
    size_t bitsPerPixel = 0; // 32每个字节32位数据
    size_t bytesPerRow = 0; // 每行多少字节
    // bitsPerPixel根据初始化给定决定
    if (self.bitsPerPixel == 16) {
        bitsPerComponent = 5;
        //    numComponents = 3;
        bitsPerPixel = 16;
        bytesPerRow = self.width * (bitsPerPixel / 8);
    } else if (self.bitsPerPixel == 24 || self.bitsPerPixel == 32) {
        bitsPerComponent = 8;
        numComponents = 4;
        bitsPerPixel = bitsPerComponent * numComponents;
        bytesPerRow = self.width * (bitsPerPixel / 8);
    } else {
        NSAssert(FALSE, @"unmatched bitsPerPixel");
    }
    
    // 指定下面调用方法alpha的类型 -- 指定位图是否应该包含一个Alpha通道及其生成方式，以及组件是浮点数还是整数。
    CGBitmapInfo bitmapInfo = [self getBitmapInfo];
    
    CGColorSpaceRef colorSpace = self.colorspace;
    if (colorSpace) {
        CGColorSpaceRetain(colorSpace);
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();  // 构建一个颜色空间引用
    }
    
    
    NSAssert(self.pixels != NULL, @"pixels must not be NULL");
    NSAssert(self.isLockedByDataProvider == FALSE, @"renderCGImage: pixel buffer locked by data provider");
    
    // 创建位图上下文,
    // self.pixels(data),`data'，如果非NULL，指向至少一个“ bytesPerRow * height”字节的内存块。
    // 如果`data'为NULL，则自动分配上下文数据并释放 -- 数据给pixels-data存储
    CGContextRef bitmapContext =
    CGBitmapContextCreate(self.pixels, self.width, self.height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
    
    CGColorSpaceRelease(colorSpace);
    
    if (bitmapContext == NULL) {
        return FALSE;
    }
    
    // Translation matrix that maps CG space to view space
    
    if (isRotated) {
        // To landscape : 90 degrees CCW
        
        CGContextRotateCTM(bitmapContext, M_PI / 2);
    }
    
    CGRect bounds = CGRectMake( 0.0f, 0.0f, self.width, self.height );
    // image 绘制进行contenxt，分配给pxiels
    CGContextDrawImage(bitmapContext, bounds, cgImageRef);
    
    CGContextRelease(bitmapContext);
    
    return TRUE;
}




// Exit zero copy mode.

- (void) doneZeroCopyPixels
{
  NSAssert(self.isLockedByDataProvider == FALSE, @"isLockedByDataProvider");
  self->m_zeroCopyPixels = NULL;
  self.zeroCopyMappedData = nil;
}



// Set all pixels to 0x0
- (void) clear
{
  [self doneZeroCopyPixels];
    // 使用bzero置空pixels
  bzero(self.pixels, self.numBytes);
}


// 分配buffer pixels内存
- (CGContextRef) newBitmapRGBA8ContextFromImage:(CGImageRef) image width:(NSInteger)width height:(NSInteger)height {
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    uint32_t *bitmapData;
    
    self->m_bitsPerPixel = 24;
    
    size_t bitsPerComponent = 8;
    size_t numComponents = 4;
    size_t bitsPerPixel = bitsPerComponent * numComponents;
    size_t bytesPerRow = width * (bitsPerPixel / 8);
    
    size_t bufferLength = bytesPerRow * height;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if(!colorSpace) {
        NSLog(@"Error allocating color space RGB\n");
        return NULL;
    }
    
    // Allocate memory for image data
//    bitmapData = (uint32_t *)malloc(bufferLength);
//    if(!bitmapData) {
//        NSLog(@"Error allocating memory for bitmap\n");
//        CGColorSpaceRelease(colorSpace);
//        return NULL;
//    }
    char* buffer;
    buffer = (char*) malloc(bufferLength);
    
    CGBitmapInfo bitmapInfo = [self getBitmapInfo];
    
    //Create bitmap context
    context = CGBitmapContextCreate(buffer,
            width,
            height,
            bitsPerComponent,
            bytesPerRow,
            colorSpace,
            bitmapInfo);    // RGBA // bitmapData  kCGImageAlphaPremultipliedLast
    if(!context) {
        free(bitmapData);
        NSLog(@"Bitmap context not created");
    }
    
    CGColorSpaceRelease(colorSpace);
    
    return context;
}



@end



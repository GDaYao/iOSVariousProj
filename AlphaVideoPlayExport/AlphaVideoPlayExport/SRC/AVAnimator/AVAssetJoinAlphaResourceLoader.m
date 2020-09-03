//
//  AVAssetJoinAlphaResourceLoader.m
//
//  Created by Moses DeJong on 1/1/13.
//
//  License terms defined in License.txt.
//

#import "AVAssetJoinAlphaResourceLoader.h"

#import "AVFileUtil.h"

#import "AVAsset2MvidResourceLoader.h"

#import "AVAssetReaderConvertMaxvid.h"

#import "AVFrame.h"

#import "AVAssetFrameDecoder.h"

#import "CGFrameBuffer.h"

#import "movdata.h"

#include "AVStreamEncodeDecode.h"


// 多张图片合成视频
#import "ImageMakeToMovie.h"


//#define LOGGING

@interface AVAssetJoinAlphaResourceLoader ()

+ (void) combineRGBAndAlphaPixels:(uint32_t)numPixels
                   combinedPixels:(uint32_t*)combinedPixels
                        rgbPixels:(uint32_t*)rgbPixels
                      alphaPixels:(uint32_t*)alphaPixels;


@end

@implementation AVAssetJoinAlphaResourceLoader

@synthesize movieRGBFilename = m_movieRGBFilename;
@synthesize movieAlphaFilename = m_movieAlphaFilename;
@synthesize outPath = m_outPath;
@synthesize alwaysGenerateAdler = m_alwaysGenerateAdler;

#if defined(HAS_LIB_COMPRESSION_API)
@synthesize compressed = m_compressed;
#endif // HAS_LIB_COMPRESSION_API


#pragma mark -
+ (AVAssetJoinAlphaResourceLoader*) aVAssetJoinAlphaResourceLoader
{
  AVAssetJoinAlphaResourceLoader *obj = [[AVAssetJoinAlphaResourceLoader alloc] init];
#if __has_feature(objc_arc)
  return obj;
#else
  return [obj autorelease];
#endif // objc_arc
}

- (void) dealloc
{
  self.movieRGBFilename = nil;
  self.movieAlphaFilename = nil;
  self.outPath = nil;
  
#if __has_feature(objc_arc)
#else
  [super dealloc];
#endif // objc_arc
}

// Overload suerclass self.movieFilename getter so that standard loading
// process so that the movieRGBFilename property can be set instead
// of the self.movieFilename property.

- (NSString*) movieFilename
{
  return self.movieRGBFilename;
}

// Output movie filename must be redefined

- (NSString*) _getMoviePath
{
  return self.outPath;
}

// Create secondary thread to process operation
// 创建辅助线程以处理操作
- (void) _detachNewThread:(BOOL)phony
             rgbAssetPath:(NSString*)rgbAssetPath
           alphaAssetPath:(NSString*)alphaAssetPath
             phonyOutPath:(NSString*)phonyOutPath
                  outPath:(NSString*)outPath
             isCompressed:(BOOL)isCompressed
{
  NSNumber *serialLoadingNum = [NSNumber numberWithBool:self.serialLoading];
  
  uint32_t genAdler = self.alwaysGenerateAdler;
  NSNumber *genAdlerNum = [NSNumber numberWithInt:genAdler];
  NSAssert(genAdlerNum != nil, @"genAdlerNum");
  
  NSArray *arr = [NSArray arrayWithObjects:rgbAssetPath,
                  alphaAssetPath,
                  phonyOutPath, outPath,
                  serialLoadingNum,
                  genAdlerNum,
                  @(isCompressed), nil];
  NSAssert([arr count] == 7, @"arr count");
  
  [NSThread detachNewThreadSelector:@selector(decodeThreadEntryPoint:) toTarget:self.class withObject:arr];
}

// Define load method here to provide custom implementation that will load
// the needed .mvid files from .m4v (H264) video and then combine these
// two video sources into one single video that contains an alpha channel.
// This load method should be called from the main thread to kick off a
// secondary thread.
#pragma mark - 外部会调用load方法
- (void) load
{
  // Avoid kicking off mutliple sync load operations. This method should only
  // be invoked from a main thread callback, so there should not be any chance
  // of a race condition involving multiple invocations of this load mehtod.
  
  if (startedLoading) {
    return;
  } else {
    startedLoading = TRUE;
  }
  // 确保线程安全
  premultiply_init(); // ensure thread safe init of premultiply table
  
  NSAssert(self.movieRGBFilename, @"movieRGBFilename");
  NSAssert(self.movieAlphaFilename, @"movieAlphaFilename");
  NSString *outPath = self.outPath;
  NSAssert(outPath, @"outPath not defined");
  
  NSString *qualRGBPath = [AVFileUtil getQualifiedFilenameOrResource:self.movieRGBFilename];
  NSAssert(qualRGBPath, @"qualRGBPath");

  NSString *qualAlphaPath = [AVFileUtil getQualifiedFilenameOrResource:self.movieAlphaFilename];
  NSAssert(qualAlphaPath, @"qualAlphaPath");
  
  BOOL isCompressed = FALSE;
#if defined(HAS_LIB_COMPRESSION_API)
  isCompressed = self.compressed;
#endif // HAS_LIB_COMPRESSION_API
  
  self.movieFilename = @""; // phony assign to disable check in superclass
  
  // Superclass load method asserts that self.movieFilename is not nil
  [super load];
  
  // Create a loader that will run as a detached secondary thread. It is critical
  // that we be able to execute all of the operation logic in the secondary thread.
  
  NSString *phonyOutPath = [NSString stringWithFormat:@"%@.mvid", [AVFileUtil generateUniqueTmpPath]];
  
  [self _detachNewThread:FALSE
             rgbAssetPath:qualRGBPath
          alphaAssetPath:qualAlphaPath
            phonyOutPath:phonyOutPath
                 outPath:outPath
            isCompressed:isCompressed];
  
  return;
}

- (BOOL) isReady
{
  return [super isReady];
}

// joinRGBAndAlpha
//
// Implement logic to join pixels from RGB video and Alpha video back into single .mvid
// with an alpha channel.
#pragma mark - 实施逻辑以将RGB视频和Alpha视频中的像素连接回单个.mvid
+ (BOOL) joinRGBAndAlpha:(NSString*)joinedMvidPath
                 rgbPath:(NSString*)rgbPath
               alphaPath:(NSString*)alphaPath
                genAdler:(BOOL)genAdler
            isCompressed:(BOOL)isCompressed
{
    // Open both the rgb and alpha mvid files for reading
    // 打开rgb和透明 mvid文件读取
    AVAssetFrameDecoder *frameDecoderRGB = [AVAssetFrameDecoder aVAssetFrameDecoder];
    AVAssetFrameDecoder *frameDecoderAlpha = [AVAssetFrameDecoder aVAssetFrameDecoder];
    
    BOOL worked;
    worked = [frameDecoderRGB openForReading:rgbPath]; // 判断当前视频资源文件是否可以被AVAsset转换并读取操作。
    
    if (worked == FALSE) {
        NSLog(@"error: cannot open RGB mvid filename \"%@\"", rgbPath);
        return FALSE;
    }
    
    worked = [frameDecoderAlpha openForReading:alphaPath];
    
    if (worked == FALSE) {
        NSLog(@"error: cannot open ALPHA mvid filename \"%@\"", alphaPath);
        return FALSE;
    }
    
    worked = [frameDecoderRGB allocateDecodeResources];
    
    if (worked == FALSE) {
        NSLog(@"error: cannot allocate RGB decode resources for filename \"%@\"", rgbPath);
        return FALSE;
    }
    
    worked = [frameDecoderAlpha allocateDecodeResources];
    
    if (worked == FALSE) {
        NSLog(@"error: cannot allocate ALPHA decode resources for filename \"%@\"", alphaPath);
        return FALSE;
    }
    
    // BPP for decoded asset is always 32 BPP
    
    // framerate
    
    NSTimeInterval frameRate = frameDecoderRGB.frameDuration;      // 获得RGB资源帧速率
    NSTimeInterval frameRateAlpha = frameDecoderAlpha.frameDuration; // 获取alpha资源帧速率
    if (frameRate != frameRateAlpha) {
        NSLog(@"error: RGB movie fps %.4f does not match alpha movie fps %.4f",
              1.0f/(float)frameRate, 1.0f/(float)frameRateAlpha);
        return FALSE;
    }
    
    // num frames
    
    NSUInteger numFrames = [frameDecoderRGB numFrames];
    NSUInteger numFramesAlpha = [frameDecoderAlpha numFrames];
    if (numFrames != numFramesAlpha) {
        NSLog(@"error: RGB movie numFrames %d does not match alpha movie numFrames %d", (int)numFrames, (int)numFramesAlpha);
        return FALSE;
    }
    
    // width x height
    
    int width  = (int) [frameDecoderRGB width];
    int height = (int) [frameDecoderRGB height];
    NSAssert(width > 0, @"width");
    NSAssert(height > 0, @"height");
    CGSize size = CGSizeMake(width, height);
    
    // Size of Alpha movie must match size of RGB movie
    
    CGSize alphaMovieSize;
    
    alphaMovieSize = CGSizeMake(frameDecoderAlpha.width, frameDecoderAlpha.height);
    if (CGSizeEqualToSize(size, alphaMovieSize) == FALSE) {
        NSLog(@"error: RGB movie size (%d, %d) does not match alpha movie size (%d, %d)",
              (int)width, (int)height,
              (int)alphaMovieSize.width, (int)alphaMovieSize.height);
        return FALSE;
    }
    
    // Create output file writer object
    // TODO: 此类中包含实现生成.mvid文件细节
    AVMvidFileWriter *fileWriter = [AVMvidFileWriter aVMvidFileWriter];
    NSAssert(fileWriter, @"fileWriter");
    
    fileWriter.mvidPath = joinedMvidPath;
    fileWriter.bpp = 32;
    // Note that we don't know the movie size until the first frame is read
    fileWriter.genV3 = TRUE;
    
    fileWriter.frameDuration = frameRate;
    fileWriter.totalNumFrames = (int) numFrames;
    
    if (genAdler) {
        fileWriter.genAdler = TRUE;
    }
    
    worked = [fileWriter open];
    if (worked == FALSE) {
        NSLog(@"error: Could not open .mvid output file \"%@\"", joinedMvidPath);
        return FALSE;
    }
    
    fileWriter.movieSize = size;
    
    CGFrameBuffer *combinedFrameBuffer = [CGFrameBuffer cGFrameBufferWithBppDimensions:32 width:width height:height];
    // 像素转储用于将预期结果与iOS解码器硬件产生的实际结果进行比较
    // Pixel dump used to compare exected results to actual results produced by iOS decoder hardware
    //NSString *tmpFilename = [NSString stringWithFormat:@"%@%@", joinedMvidPath, @".adump"];
    //char *utf8Str = (char*) [tmpFilename UTF8String];
    //NSLog(@"Writing %s", utf8Str);
    //FILE *fp = fopen(utf8Str, "w");
    //assert(fp);
    
    // TODO: for 循环 -- 遍历所有帧，即处理所有帧
    BOOL isExecute = [self executeForLoop:numFrames frameDecoderRGB:frameDecoderRGB frameDecoderAlpha:frameDecoderAlpha combinedFrameBuffer:combinedFrameBuffer width:width height:height isCompressed:isCompressed fileWriter:fileWriter worked:worked joinedMvidPath:joinedMvidPath ];
    if (isExecute == FALSE) {
        return FALSE;
    }

    //fclose(fp);
    
    [fileWriter rewriteHeader];
    [fileWriter close];
    
#if defined(DEBUG)
    {
        // Query the file length for the container, will be returned by length getter.
        // If the file does not exist, then nil is returned.
        NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:fileWriter.mvidPath error:nil];
        if (attrs != nil) {
            unsigned long long fileSize = [attrs fileSize];
            size_t fileSizeT = (size_t) fileSize;
            NSAssert(fileSize == fileSizeT, @"assignment from unsigned long long to size_t lost bits");
            
            NSLog(@"wrote \"%@\" at size %d kB", fileWriter.mvidPath, (int)fileSizeT/1000);
        }
    }
#endif // DEBUG
    
    return TRUE;
}


// TODO: 执行for循环,拿出来使用
+ (BOOL)executeForLoop:(NSUInteger)numFrames  frameDecoderRGB:(AVAssetFrameDecoder *)frameDecoderRGB frameDecoderAlpha:(AVAssetFrameDecoder *)frameDecoderAlpha  combinedFrameBuffer:(CGFrameBuffer *)combinedFrameBuffer width:(int)width height:(int)height isCompressed:(BOOL)isCompressed fileWriter:(AVMvidFileWriter *)fileWriter  worked:(BOOL)worked joinedMvidPath:(NSString *)joinedMvidPath  {
    
    
    NSMutableArray *imgs = [NSMutableArray array];
    
    //UIImage *bgCoverImg = [UIImage imageNamed:@"tmp-1.jpg"];
    UIImage *bgCoverImg = [UIImage imageNamed:@"testImg.JPG"];
    
    ImageMakeToMovie *movieMaker  = [self singlaImgToGenerateMOVWithNumFrames:numFrames VideoSize:CGSizeMake(width, height) frameTime:frameDecoderRGB.frameTime];
    
    
    // 正序循环
    for (NSUInteger frameIndex = 0; frameIndex < numFrames; frameIndex++) @autoreleasepool {
    // 倒序循环
    //for (NSUInteger frameIndex = numFrames-1; frameIndex >0; frameIndex--) @autoreleasepool {
//#ifdef LOGGING
        NSLog(@"log-joinRGBAndAlpha-reading frame %d", frameIndex);
//#endif // LOGGING
        
        // 读取RGB+alpha文件 ==> 此处耗时大概2s-7s(模拟器)
        AVFrame *frameRGB = [frameDecoderRGB advanceToFrame:frameIndex]; // AVAssetFrameDecoder 获取当前帧图像，包含在 frameRGB.image
        assert(frameRGB);
        
        AVFrame *frameAlpha = [frameDecoderAlpha advanceToFrame:frameIndex];
        assert(frameAlpha);
        
        //BOOL isHasAlphaFrameRGB = [self hasAlphaWithCurrentImg:frameRGB.image];
        //BOOL isHasAlphaFrameAlpha = [self hasAlphaWithCurrentImg:frameAlpha.image];
        //NSLog(@"log-是否含有透明通道:rgb:%d,alpha:%d",isHasAlphaFrameRGB,isHasAlphaFrameAlpha);
        
        // 是否需要 -- 转储RGB和ALPHA帧的图像 TRUE/FALSE
#ifdef DEBUG
        if (FALSE) {
            // Dump images for the RGB and ALPHA frames
            // Write image as PNG
            
            NSString *tmpDir = NSTemporaryDirectory();
            
            NSString *tmpPNGPath = [tmpDir stringByAppendingFormat:@"JoinAlpha_RGB_Frame%d.png", (int)(frameIndex + 1)];
            
            NSData *data = [NSData dataWithData:UIImagePNGRepresentation(frameRGB.image)];
            [data writeToFile:tmpPNGPath atomically:YES];
            //NSLog(@"log-wrote %@", tmpPNGPath);
            
            tmpPNGPath = [tmpDir stringByAppendingFormat:@"JoinAlpha_ALPHA_Frame%d.png", (int)(frameIndex + 1)];
            
            data = [NSData dataWithData:UIImagePNGRepresentation(frameAlpha.image)];
            [data writeToFile:tmpPNGPath atomically:YES];
            //NSLog(@"log-wrote %@", tmpPNGPath);
        }
#endif
        
        
        // 在框架内释放UIImage ref，因为我们将直接对图像数据进行操作。
        // Release the UIImage ref inside the frame since we will operate on the image data directly.
        frameRGB.image = nil;   // 操作完成后释放image图像
        frameAlpha.image = nil;
        
        CGFrameBuffer *cgFrameBufferRGB = frameRGB.cgFrameBuffer;
        NSAssert(cgFrameBufferRGB, @"cgFrameBufferRGB");
        
        CGFrameBuffer *cgFrameBufferAlpha = frameAlpha.cgFrameBuffer;
        NSAssert(cgFrameBufferAlpha, @"cgFrameBufferAlpha");
        
        // sRGB
        
        if (frameIndex == 0) {
            combinedFrameBuffer.colorspace = cgFrameBufferRGB.colorspace;
        }
        
        //fprintf(fp, "Frame %d\n", frameIndex);
        //NSLog(@"Frame %d\n", frameIndex);
        
        // Join RGB and ALPHA
        uint32_t numPixels = width * height;  // 每张图片所包含像素数值
        uint32_t *combinedPixels = (uint32_t*)combinedFrameBuffer.pixels;
        uint32_t *rgbPixels = (uint32_t*)cgFrameBufferRGB.pixels;
        uint32_t *alphaPixels = (uint32_t*)cgFrameBufferAlpha.pixels;
        
        // RGB和alpha透明通道混合
        // 达到的结果是更新 combinedPixels 数值
        [self combineRGBAndAlphaPixels:numPixels
                        combinedPixels:combinedPixels
                             rgbPixels:rgbPixels
                           alphaPixels:alphaPixels];
        
        // Write combined RGBA pixles as a keyframe, we do not attempt to calculate
        // frame diffs when processing on the device as that takes too long.
        // 将组合的RGBA像素写为关键帧，我们不会尝试计算各帧差异当在设备上处理时，那将占用很长时间。
        int numBytesInBuffer = (int) combinedFrameBuffer.numBytes;
        
        // 保存所有存储的image
        AVFrame *disFrame = [AVFrame aVFrame];
        disFrame.cgFrameBuffer = combinedFrameBuffer;  // 使用最新的 `combinedFrameBuffer` 生成最新的image。
        [disFrame makeImageFromFramebuffer];
        
        
        UIImage *newImg = [self imageByCombiningImageNewImgSize:CGSizeMake(width, height) firstImage:bgCoverImg withImage:disFrame.image];
        
        // 1. 添加到图片数组中，以便合成
        //[imgs addObject:newImg];
        
        // 2.
        //NSData *newImgData = [NSData dataWithData:UIImagePNGRepresentation(newImg)];
        //[imgs addObject:newImgData];
        
        // 3. 单个图片存储在mov buffer数据中
        [movieMaker createMovieAppenPixelBufferWithImage:newImg imgIndex:frameIndex];
        
        
        //  TODO: 使用完成释放需要释放
        frameRGB = nil;
        frameAlpha = nil;

        [cgFrameBufferRGB clear];
        [cgFrameBufferAlpha clear];

        numPixels = 0;
        combinedPixels = 0;
        rgbPixels = 0;
        alphaPixels = 0;
        
        
        disFrame.image = nil;
        disFrame = nil;
        
        newImg = nil;
        
#ifdef DEBUG
        // mEncodeData 是处理完、压缩完成的data数据
        if (FALSE) {
            NSString *tmpDir = NSTemporaryDirectory();
            // png /jpg
            NSString *disPNGPath = [tmpDir stringByAppendingFormat:@"JoinAlpha_RGBA_%d.jpg", (int)(frameIndex + 1)];
            
            //NSData *data = [NSData dataWithData:UIImagePNGRepresentation(newImg)];
//            NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(newImg, 0.5)];
//            [data writeToFile:disPNGPath atomically:YES];
//            UIImage *disImg = newImg;
//            NSLog(@"log-测试:%@",disPNGPath);
        }
#endif
        
        // 直接进行下次循环
        continue;
        
#if defined(HAS_LIB_COMPRESSION_API)
        // If compression is used, then generate a compressed buffer and write it as
        // a keyframe.
        // 如果使用确定使用压缩处理，则会生成一个压缩缓冲区并写它作为一个关键帧。
        if (isCompressed) @autoreleasepool {
            // 使用combinedPixels ==> NSData
            NSData *pixelData = [NSData dataWithBytesNoCopy:combinedPixels length:numBytesInBuffer freeWhenDone:NO];
    
            
            // FIXME: make this mutable data a member so that it is not allocated
            // in every loop.
            
            NSMutableData *mEncodedData = [NSMutableData data];
            
            // 处理data数据，主要进行压缩处理然后对比
//            [AVStreamEncodeDecode streamDeltaAndCompress:pixelData
//                                             encodedData:mEncodedData
//                                                     bpp:fileWriter.bpp
//                                               algorithm:COMPRESSION_LZ4];
            
            //int src_size = bufferSize;
//            assert(mEncodedData.length > 0);
//            assert(mEncodedData.length < 0xFFFFFFFF);
//            int dst_size = (int) mEncodedData.length;
//
//#ifdef DEBUG
//            int src_size = (int) pixelData.length;
//            printf("log-compressed frame size %d kB down to %d kB\n", (int)src_size/1000, (int)dst_size/1000);
//#endif
            
            // Calculate adler based on original pixels (not the compressed representation)
            
//            uint32_t adler = 0;
//            adler = maxvid_adler32(0, (unsigned char*)combinedPixels, numBytesInBuffer);

            
            // 写关键帧
            //worked = [fileWriter writeKeyframe:(char*)mEncodedData.bytes bufferSize:(int)dst_size adler:adler isCompressed:TRUE];
            
            
        } else {
            worked = [fileWriter writeKeyframe:(char*)combinedPixels bufferSize:numBytesInBuffer];
        }
#else
        worked = [fileWriter writeKeyframe:(char*)combinedPixels bufferSize:numBytesInBuffer];
#endif // HAS_LIB_COMPRESSION_API
        
//        if (worked == FALSE) {
//            NSLog(@"cannot write keyframe data to mvid file \"%@\"", joinedMvidPath);
//            return FALSE;
//        }
    }
    
    // 1. 全部图片统一生成mov
//    [self imagesToGenerateMOVWith:imgs videoSize:CGSizeMake(width, height) frameTime:frameDecoderRGB.frameTime writefinish:^(NSURL *fileURL) {
//        NSLog(@"log-生成视频路径地址:%@",fileURL.path);
//        NSLog(@"log-test");
//    }];
    
    // 2. 图片导入完成
    [movieMaker createMovieFinishWithCompletion:^(NSURL *fileURL) {
        NSLog(@"log-生成视频路径地址:%@",fileURL.path);
        NSLog(@"log-test");
    }];
    
    
    return TRUE;
}


// Join the RGB and Alpha components of two input framebuffers
// so that the final output result contains native premultiplied
// 32 BPP pixels.
// TODO: 更新pixels -- 连接两个输入帧缓冲区的RGB和Alpha分量，以便最终输出结果包含本机预乘的32 BPP像素。 -- 使用rgbPixels,alphaPixels，组合替换combinedPixels.
+ (void) combineRGBAndAlphaPixels:(uint32_t)numPixels
                   combinedPixels:(uint32_t*)combinedPixels
                        rgbPixels:(uint32_t*)rgbPixels
                      alphaPixels:(uint32_t*)alphaPixels
{
    
#ifdef DEBUG
    NSMutableArray *alphaMuArr = [NSMutableArray array];
#endif
    
    // 一帧图像含有 numPixels 像素
    for (uint32_t pixeli = 0; pixeli < numPixels; pixeli++) {
        uint32_t pixelAlpha = alphaPixels[pixeli];
        uint32_t pixelRGB = rgbPixels[pixeli];
        
        // All 3 components of the ALPHA pixel should be the same in grayscale mode.
        // If these are not exactly the same, this is likely caused by limited precision
        // ranges in the hardware color conversion logic.
        // 在灰度模式下，alpha像素的所有3个分量都应该相同
        // 如果它们不完全相同，则可能是由于硬件颜色转换逻辑中的精度范围有限所致。
        uint32_t pixelAlphaRed = (pixelAlpha >> 16) & 0xFF; //  alpha pixel 应该都为255,255,255
        uint32_t pixelAlphaGreen = (pixelAlpha >> 8) & 0xFF;
        uint32_t pixelAlphaBlue = (pixelAlpha >> 0) & 0xFF;
        
        // 16进制色值使用
        // hexValue [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:1.0]
        
#if defined(DEBUG)
        if (FALSE) {
            uint32_t pixelRed = (pixelRGB >> 16) & 0xFF;
            uint32_t pixelGreen = (pixelRGB >> 8) & 0xFF;
            uint32_t pixelBlue = (pixelRGB >> 0) & 0xFF;
            
            NSLog(@"log-输出每个像素-rgbA-processing pixeli %d : (%3d %3d %3d) : alpha grayscale %3d %3d %3d", pixeli, pixelRed, pixelGreen, pixelBlue, pixelAlphaRed, pixelAlphaGreen, pixelAlphaBlue);
        }
#endif // DEBUG
        
        //    if ((pixeli % 256) == 0) {
        //      NSLog(@"processing row %d", (pixeli / 256));
        //    }
        
        //    if ((pixeli >= (2 * 256)) && (pixeli < (3 * 256))) {
        //      // Third row
        //      combinedPixels[pixeli] = combinedPixels[pixeli];
        //    }
        
        
        // 进行判断alpha通道像素值，应该使用RGB中哪个数值。
        if (pixelAlphaRed != pixelAlphaGreen || pixelAlphaRed != pixelAlphaBlue) {
            //NSLog(@"Input Alpha MVID input movie R G B components (%d %d %d) do not match at pixel %d", pixelAlphaRed, pixelAlphaGreen, pixelAlphaBlue, pixeli);
            //return FALSE;
            
            uint32_t sum = pixelAlphaRed + pixelAlphaGreen + pixelAlphaBlue;
            if (sum == 1) {
                // If two values are 0 and the other is 1, then assume the alpha value is zero. The iOS h264
                // decoding hardware seems to emit (R=0 G=0 B=1) even when the input is a grayscale black pixel.
                pixelAlpha = 0;
            } else if (sum == 2 && (pixelAlphaRed == 0 && pixelAlphaGreen == 2 && pixelAlphaBlue == 0)) {
                // The h.264 decoder seems to generate (R=0 G=2 B=0) for black in some weird cases on ARM64.
                pixelAlpha = 0;
#if defined(__arm64__) && __arm64__
            } else if ((pixelAlphaRed == pixelAlphaBlue) && (pixelAlphaRed+1 == pixelAlphaGreen)) {
                // The h.264 decoder in newer ARM64 devices seems to decode the grayscale values (2 2 2) as
                // (1 2 1) in certain cases. Choose an output grayscale value of 2 in these cases only
                // for this specific hardware decoder.
                
                pixelAlpha = pixelAlphaGreen;
            } else if ((pixelAlphaRed == pixelAlphaBlue) && (pixelAlphaRed+2 == pixelAlphaGreen)) {
                // The h.264 decoder in newer ARM64 devices seems to decode the grayscale values (3 3 3) as
                // (2 4 2) in certain cases. Choose an output grayscale value of 3 in these cases only
                // for this specific hardware decoder.
                
                pixelAlpha = pixelAlphaRed + 1;
#endif // __arm64__
            } else if (pixelAlphaRed == pixelAlphaBlue) {
                // The R and B pixel values are equal but these two values are not the same as the G pixel.
                // This indicates that the grayscale conversion should have resulted in value between the
                // two numbers.
                //
                // R G B components
                //
                // (3 1 3)       -> 2   <- (2, 2, 2) (sim)
                // (2 0 2)       -> 1   <- (1, 1, 1) (sim)
                // (18 16 18)    -> 17  <- (17, 17, 17) (sim)
                // (219 218 219) -> 218 <- (218, 218, 218) (sim)
                //
                // Note that in some cases the original values (5, 5, 5) get decoded as (5, 4, 5) and that results in 4 as the
                // alpha value. These cases are few and we just ignore them because the alpha is very close.
                
                if (pixelAlphaRed == 0) {
                    pixelAlpha = 0;
                } else {
                    pixelAlpha = pixelAlphaRed - 1;
                }
                
                //NSLog(@"Input Alpha MVID input movie R G B components (%d %d %d) do not match at pixel %d in frame %d", pixelAlphaRed, pixelAlphaGreen, pixelAlphaBlue, pixeli, frameIndex);
                //NSLog(@"Using RED/BLUE Alpha level %d at pixel %d in frame %d", pixelAlpha, pixeli, frameIndex);
            } else if ((pixelAlphaRed == (pixelAlphaGreen + 1)) && (pixelAlphaRed == (pixelAlphaBlue - 1))) {
                // Common case seen in hardware decoder output, average is the middle value.
                //
                // R G B components
                // (62, 61, 63)    -> 62  <- (62, 62, 62) (sim)
                // (111, 110, 112) -> 111 <- (111, 111, 111) (sim)
                
                pixelAlpha = pixelAlphaRed;
                
                //NSLog(@"Input Alpha MVID input movie R G B components (%d %d %d) do not match at pixel %d in frame %d", pixelAlphaRed, pixelAlphaGreen, pixelAlphaBlue, pixeli, frameIndex);
                //NSLog(@"Using RED (easy ave) Alpha level %d at pixel %d in frame %d", pixelAlpha, pixeli, frameIndex);
            } else {
                // Output did not match one of the know common patterns seen coming from iOS H264 decoder hardware.
                // Since this branch does not seem to ever be executed, just use the red component which is
                // basically the same as the branch above.
                
                //pixelAlpha = sum / 3;
                pixelAlpha = pixelAlphaRed;
                
                //NSLog(@"Input Alpha MVID input movie R G B components (%d %d %d) do not match at pixel %d in frame %d", pixelAlphaRed, pixelAlphaGreen, pixelAlphaBlue, pixeli, frameIndex);
                //NSLog(@"Using AVE Alpha level %d at pixel %d in frame %d", pixelAlpha, pixeli, frameIndex);
            }
            
            //NSLog(@"will use pixelAlpha %d", pixelAlpha);
        } else {
            // All values are equal, does not matter which channel we use as the alpha value
            // 所有值都相等，与我们使用哪个通道作为Alpha值无关紧要
            pixelAlpha = pixelAlphaRed; // 255，带有透明通道，即alpha=1
        }
        
        // Automatically filter out zero pixel values, because there are just so many
        //if (pixelAlpha != 0) {
        //fprintf(fp, "A[%d][%d] = %d\n", frameIndex, pixeli, pixelAlpha);
        //fprintf(fp, "A[%d][%d] = %d <- (%d, %d, %d)\n", frameIndex, pixeli, pixelAlpha, pixelAlphaRed, pixelAlphaGreen, pixelAlphaBlue);
        //}
        
        // RGB componenets are 24 BPP non pre-multiplied values
        
        uint32_t pixelRed = (pixelRGB >> 16) & 0xFF;
        uint32_t pixelGreen = (pixelRGB >> 8) & 0xFF;
        uint32_t pixelBlue = (pixelRGB >> 0) & 0xFF;
        
#ifdef DEBUG
        if (FALSE) {
            if (pixelAlpha != 255 ) {
                NSLog(@"log-当前rgb透明-alpha:%f",pixelAlpha/255.0);
            }
            // 记住移除
            NSNumber *alphaNum = [NSNumber numberWithFloat:pixelAlpha/255.0];
            [alphaMuArr addObject:alphaNum];
        }
#endif
        
        // 预乘分量，组合像素
        uint32_t combinedPixel = premultiply_bgra_inline(pixelRed, pixelGreen, pixelBlue, pixelAlpha);
        
        //NSLog(@"output combinedPixel 0x%08X", combinedPixel);
        
        combinedPixels[pixeli] = combinedPixel;
        
    }
    
    return;
}

#pragma mark - 此方法功能，解码给定的两个资源文件，然后合并成为一个单独的mvid带alpha透明通道的文件。
// This method is invoked in the secondary thread to decode the contents of the
// two resource asset files and combine them back together into a single
// mvid with an alpha channel.

+ (void) decodeThreadEntryPoint:(NSArray*)arr
{
    @autoreleasepool {
        
        NSAssert([arr count] == 7, @"arr count");
        
        // Pass 6 arguments : RGB_ASSET_PATH ALPHA_ASSET_PATH PHONY_OUT_PATH REAL_OUT_PATH SERIAL ADLER
        
        NSString *rgbAssetPath = [arr objectAtIndex:0];
        NSString *alphaAssetPath = [arr objectAtIndex:1];
        NSString *phonyOutPath = [arr objectAtIndex:2];
        NSString *outPath = [arr objectAtIndex:3];
        NSNumber *serialLoadingNum = [arr objectAtIndex:4];
        NSNumber *alwaysGenerateAdler = [arr objectAtIndex:5];
        NSNumber *isCompressedNum = [arr objectAtIndex:6];
        BOOL isCompressed = [isCompressedNum boolValue];
        
        BOOL genAdler = ([alwaysGenerateAdler intValue] ? TRUE : FALSE);
        
        if ([serialLoadingNum boolValue]) {
            [self grabSerialResourceLoaderLock];
        }
        
        // Check to see if the output file already exists. If the resource exists at this
        // point, then there is no reason to kick off another decode operation. For example,
        // in the serial loading case, a previous load could have loaded the resource.
        // 判断mvid文件是否存在，存在就需要在解码生层新的mvid文件了。
        BOOL fileExists = [AVFileUtil fileExists:outPath];
        
        if (fileExists) {
#ifdef LOGGING
            NSLog(@"no asset decompression needed for %@", [outPath lastPathComponent]);
#endif // LOGGING
        } else {
#ifdef LOGGING
            NSLog(@"start asset decompression %@", [outPath lastPathComponent]);
#endif // LOGGING
            
            BOOL worked;
            
            // Iterate over RGB and ALPHA for each frame in the two movies and join the pixel values
            
            worked = [self joinRGBAndAlpha:phonyOutPath rgbPath:rgbAssetPath alphaPath:alphaAssetPath genAdler:genAdler isCompressed:isCompressed];
            NSAssert(worked, @"joinRGBAndAlpha");
            
            // Move phony tmp filename to the expected filename once writes are complete
            
            [AVFileUtil renameFile:phonyOutPath toPath:outPath];
            
#ifdef LOGGING
            NSLog(@"wrote %@", outPath);
#endif // LOGGING
        }
        
        if ([serialLoadingNum boolValue]) {
            [self releaseSerialResourceLoaderLock];
        }
        
    }
}

#pragma mark - new add method
// 判断是否有透明通道
+ (BOOL)hasAlphaWithCurrentImg:(UIImage *)img {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(img.CGImage);
    return (alpha==kCGImageAlphaFirst || alpha == kCGImageAlphaLast || alpha == kCGImageAlphaPremultipliedFirst || alpha == kCGImageAlphaPremultipliedLast);
}

#pragma mark - 单张图片生成视频
+ (ImageMakeToMovie *)singlaImgToGenerateMOVWithNumFrames:(int)numFrames VideoSize:(CGSize)videoSize frameTime:(CMTime)frameTime {
    
    int videoWidth = videoSize.width;
    int videoHeight = videoSize.height;
    while ( videoWidth % 16 != 0) {
        videoWidth = videoWidth - 1;
    }
    
    
    // 使用CEMovieMake实现视频生成
    if (@available(iOS 11.0, *)) {
        NSDictionary *settings = [ImageMakeToMovie videoSettingsWithCodec:AVVideoCodecTypeH264 withWidth:videoWidth andHeight:videoHeight];
        ImageMakeToMovie *movieMaker = [[ImageMakeToMovie alloc] initWithSettings:settings];
        Float64 seconds = frameTime.value/frameTime.timescale;
        int32_t timescale = numFrames/seconds;
        movieMaker.frameTime = CMTimeMake(1,timescale); // mean:1秒钟多少帧<==>1秒钟25帧
        
        // init singla image
        [movieMaker createMovieInitProperty];
        return movieMaker;
    } else {
        // Fallback on earlier versions
    }
    return nil;
}
#pragma mark - 所有图片整合图片生成 视频
+ (void)imagesToGenerateMOVWith:(NSMutableArray *)imgs videoSize:(CGSize)videoSize frameTime:(CMTime)frameTime writefinish:(void(^)(NSURL *fileURL))writeFinish {
    
    int videoWidth = videoSize.width;
    int videoHeight = videoSize.height;
    while ( videoWidth % 16 != 0) {
        videoWidth = videoWidth - 1;
    }
    
    // 使用CEMovieMake实现视频生成
    if (@available(iOS 11.0, *)) {
        NSDictionary *settings = [ImageMakeToMovie videoSettingsWithCodec:AVVideoCodecTypeH264 withWidth:videoWidth andHeight:videoHeight];
        ImageMakeToMovie *movieMaker = [[ImageMakeToMovie alloc] initWithSettings:settings];
        Float64 seconds = frameTime.value/frameTime.timescale;
        int32_t timescale = imgs.count/seconds;
        movieMaker.frameTime = CMTimeMake(1,timescale); // mean:1秒钟多少帧<==>1秒钟25帧
        
        [movieMaker createMovieFromImages:imgs withCompletion:^(NSURL *fileURL){
            writeFinish(fileURL);
        }];
    } else {
        // Fallback on earlier versions
    }
    
}


// TODO: 两张图片合成一张图片
+ (UIImage*)imageByCombiningImageNewImgSize:(CGSize)newImgSize firstImage:(UIImage*)firstImage withImage:(UIImage*)secondImage {
    UIImage *image = nil;
    
    CGSize newImageSize = newImgSize;
    UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [[UIScreen mainScreen] scale]);
    
    float screenHeightScle = [UIScreen mainScreen].bounds.size.height/667.0; //7屏幕适配高度比例系数
    
    [firstImage drawInRect:CGRectMake( 50 + (newImgSize.width-firstImage.size.width)/2.0, -100, firstImage.size.width,firstImage.size.height)];
    [secondImage drawInRect:CGRectMake(0, 0, newImgSize.width, newImgSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    // 图片尺寸过大时处理
    //image = [self pressNewImgWithImg:image];
    //image = [self resetSizeOfImageData:image maxSize:50];
    
    return image;
}

#pragma mark - 图片压缩算法 - 未使用
// 1. image压缩算法 使用压缩算法对图片进行相应的压缩处理
+ (UIImage *)pressNewImgWithImg:(UIImage *)currentImg {
    NSData *currentImgData = [NSData dataWithData:UIImagePNGRepresentation(currentImg)];
    NSUInteger imgSize = currentImgData.length;
    // 如果当前size>50KB
    while(imgSize/1000 > 55 ) {
        float pressRatio = 55.0/(imgSize/1000);
        NSData *tmpImgData = UIImageJPEGRepresentation(currentImg, pressRatio);
        currentImg = [UIImage imageWithData:tmpImgData];
        imgSize = tmpImgData.length;
    }
    return currentImg;
}

// 2. image压缩算法
+ (UIImage *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize {
    //先判断当前质量是否满足要求，不满足再进行压缩
    __block NSData *finallImageData = UIImageJPEGRepresentation(sourceImage,1.0);
    NSUInteger sizeOrigin   = finallImageData.length;
    NSUInteger sizeOriginKB = sizeOrigin / 1000;
    
    if (sizeOriginKB <= maxSize) {
        UIImage *img = [UIImage imageWithData:finallImageData];
        return img;
    }
    
    //获取原图片宽高比
    CGFloat sourceImageAspectRatio = sourceImage.size.width/sourceImage.size.height;
    //先调整分辨率
    CGSize defaultSize = CGSizeMake(1024, 1024/sourceImageAspectRatio);
    UIImage *newImage = [self newSizeImage:defaultSize image:sourceImage];
    
    finallImageData = UIImageJPEGRepresentation(newImage,1.0);
    
    //保存压缩系数
    NSMutableArray *compressionQualityArr = [NSMutableArray array];
    CGFloat avg   = 1.0/250;
    CGFloat value = avg;
    for (int i = 250; i >= 1; i--) {
        value = i*avg;
        [compressionQualityArr addObject:@(value)];
    }
    
    /*
     调整大小
     说明：压缩系数数组compressionQualityArr是从大到小存储。
     */
    //思路：使用二分法搜索
    finallImageData = [self halfFuntion:compressionQualityArr image:newImage sourceData:finallImageData maxSize:maxSize];
    //如果还是未能压缩到指定大小，则进行降分辨率
    while (finallImageData.length == 0) {
        //每次降100分辨率
        CGFloat reduceWidth = 100.0;
        CGFloat reduceHeight = 100.0/sourceImageAspectRatio;
        if (defaultSize.width-reduceWidth <= 0 || defaultSize.height-reduceHeight <= 0) {
            break;
        }
        defaultSize = CGSizeMake(defaultSize.width-reduceWidth, defaultSize.height-reduceHeight);
        UIImage *image = [self newSizeImage:defaultSize
                                      image:[UIImage imageWithData:UIImageJPEGRepresentation(newImage,[[compressionQualityArr lastObject] floatValue])]];
        finallImageData = [self halfFuntion:compressionQualityArr image:image sourceData:UIImageJPEGRepresentation(image,1.0) maxSize:maxSize];
    }
    UIImage *img = [UIImage imageWithData:finallImageData];
    return img;
}
#pragma mark 调整图片分辨率/尺寸（等比例缩放）
+ (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)sourceImage {
    CGSize newSize = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth = newSize.width / size.width;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
#pragma mark 二分法
+ (NSData *)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(NSInteger)maxSize {
    NSData *tempData = [NSData data];
    NSUInteger start = 0;
    NSUInteger end = arr.count - 1;
    NSUInteger index = 0;
    
    NSUInteger difference = NSIntegerMax;
    while(start <= end) {
        index = start + (end - start)/2;
        
        finallImageData = UIImageJPEGRepresentation(image,[arr[index] floatValue]);
        
        NSUInteger sizeOrigin = finallImageData.length;
        NSUInteger sizeOriginKB = sizeOrigin / 1024;
        //NSLog(@"当前降到的质量：%ld KB", (unsigned long)sizeOriginKB);
        //NSLog(@"\nstart：%zd\nend：%zd\nindex：%zd\n压缩系数：%lf", start, end, (unsigned long)index, [arr[index] floatValue]);
        
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        } else if (sizeOriginKB < maxSize) {
            if (maxSize-sizeOriginKB < difference) {
                difference = maxSize-sizeOriginKB;
                tempData = finallImageData;
            }
            if (index<=0) {
                break;
            }
            end = index - 1;
        } else {
            break;
        }
    }
    return tempData;
}







@end




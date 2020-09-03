//
//  AVAssetJoinAlphaResourceLoader.h
//
//  Created by Moses DeJong on 1/1/13.
//
//  License terms defined in License.txt.
//
// This loader will decompress a video with a full alpha channel stored
// as a pair of h264 encoded videos. The first video contains the RGB
// values while the second video contains just the alpha channel
// stored as grayscale. Typically, the h264 video should be encoded with
// ffmpeg+x264 and it would be stored in a .m4v file.

/** func:
 该加载程序将解压缩具有完整Alpha通道的视频，并将其存储为一对h264编码的视频。
 第一个视频包含RGB值并且第二个视频包含透明通道存储其灰度值。
 通常，h264视频应使用ffmpeg+x264进行编码，并将其存储在.m4v文件中。
 
 
 *** 处理rgb+alpha素材核心代码 ***
 
 */



@class AVAsset2MvidResourceLoader;

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "AVAppResourceLoader.h"

#import "AVAssetConvertCommon.h"

@interface AVAssetJoinAlphaResourceLoader : AVAppResourceLoader
{
  NSString *m_movieRGBFilename;
  NSString *m_movieAlphaFilename;
  NSString *m_outPath;
  BOOL m_alwaysGenerateAdler;
  BOOL startedLoading;
  
#if defined(HAS_LIB_COMPRESSION_API)
  BOOL m_compressed;
#endif // HAS_LIB_COMPRESSION_API
}

// 后面背景图
@property (nonatomic,strong)UIImage *bgCoverImg;


// The name of the RGB portion of the movie should be saved in the
// "movieRGBFilename" property.

@property (nonatomic, copy) NSString *movieRGBFilename;

// The name of the ALPHA portion of the movie should be saved in the
// "movieAlphaFilename" property.

@property (nonatomic, copy) NSString *movieAlphaFilename;

// The fully qualified filename of the final result file, for example
// the output path might be constructed by combining the mvid filename
// like "Ghost.mvid" with the tmp dir.

@property (nonatomic, copy) NSString *outPath;

@property (nonatomic, assign) BOOL alwaysGenerateAdler;

// Set this property to TRUE to enable compression of each keyframe

#if defined(HAS_LIB_COMPRESSION_API)
@property (nonatomic, assign) BOOL compressed;
#endif // HAS_LIB_COMPRESSION_API

// constructor

+ (AVAssetJoinAlphaResourceLoader*) aVAssetJoinAlphaResourceLoader;

@end

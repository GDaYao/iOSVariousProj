//
//  AVAssetMixAlphaResourceLoader.h
//
//  Created by Moses DeJong on 1/1/13.
//
//  License terms defined in License.txt.
//
// This loader will decompress a "mixed" video where RGB and Alpha frames
// are mixed together. A video of this type must be encoded with the main
// profile so that effective compression is retained.


/** func:
 该加载器将解压缩RGB和Alpha帧混合在一起的“混合”视频。
 
 此类型的视频必须使用主配置文件编码，以便保留有效的压缩。
 
 */

@class AVAsset2MvidResourceLoader;

#import <Foundation/Foundation.h>

#import "AVAppResourceLoader.h"

@interface AVAssetMixAlphaResourceLoader : AVAppResourceLoader

// The fully qualified filename of the final result file, for example
// the output path might be constructed by combining the mvid filename
// like "Ghost.mvid" with the tmp dir.

@property (nonatomic, copy) NSString *outPath;

@property (nonatomic, assign) BOOL alwaysGenerateAdler;

// constructor

+ (AVAssetMixAlphaResourceLoader*) aVAssetMixAlphaResourceLoader;

@end

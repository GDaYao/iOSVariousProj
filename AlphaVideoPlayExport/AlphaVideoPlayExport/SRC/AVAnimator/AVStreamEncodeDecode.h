//
//  AVStreamEncodeDecode.h
//
//  Created by Moses DeJong on 2/24/16.
//
//  License terms defined in License.txt.

#import <Foundation/Foundation.h>

#import "AVAssetConvertCommon.h" // HAS_LIB_COMPRESSION_API

#if defined(HAS_LIB_COMPRESSION_API)

#import "compression.h"

@interface AVStreamEncodeDecode : NSObject

// Stream compression interface, compress input and store into encodedData buffer
// 流压缩接口，压缩输入并存储到encodedData缓冲区中
+ (void) streamCompress:(NSData*)inputData
            encodedData:(NSMutableData*)encodedData
              algorithm:(compression_algorithm)algorithm;

// Streaming delta + compress encoding operation that reads 16, 24, 32 BPP pixels
// and writes data to an output mutable data that contains encoded bytes
// 流式增量+压缩编码操作，可读取16、24、32 BPP像素并将数据写入包含编码字节的输出可变数据
+ (BOOL) streamDeltaAndCompress:(NSData*)inputData
                    encodedData:(NSMutableData*)encodedData
                            bpp:(int)bpp
                      algorithm:(compression_algorithm)algorithm;

// Undo the delta + compress operation so that the original pixel data is recovered
// and written to the indicated pixel buffer.
// 撤消增量+压缩操作，以便恢复原始像素数据并将其写入指示的像素缓冲区。
+ (BOOL) streamUnDeltaAndUncompress:(NSData*)encodedData
                        frameBuffer:(void*)frameBuffer
                frameBufferNumBytes:(uint32_t)frameBufferNumBytes
                                bpp:(int)bpp
                          algorithm:(compression_algorithm)algorithm;

@end

#endif // HAS_LIB_COMPRESSION_API

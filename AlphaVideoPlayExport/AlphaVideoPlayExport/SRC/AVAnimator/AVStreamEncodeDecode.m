//
//  AVStreamEncodeDecode.m
//
//  Created by Moses DeJong on 2/24/16.
//
//  License terms defined in License.txt.

#import "AVStreamEncodeDecode.h"

#import <stdlib.h>

#if defined(HAS_LIB_COMPRESSION_API)

#import "compression.h"

@implementation AVStreamEncodeDecode

// Streaming encode inputData using algorithm and write the results
// to the passed in encodedData.

+ (void) streamCompress:(NSData*)inputData
            encodedData:(NSMutableData*)encodedData
              algorithm:(compression_algorithm)algorithm
{
  compression_status status = COMPRESSION_STATUS_OK;

  compression_stream_flags flags;
  compression_stream stream;
  
  compression_stream_operation operation = COMPRESSION_STREAM_ENCODE;
  
  compression_stream_init(&stream, operation, algorithm);
  
  // Setup input pointer and length since all src data is known
  
  stream.src_ptr = inputData.bytes;
  stream.src_size = inputData.length;

  // If the estimated output size is defined, use caller set value.
  // Otherwise base estimate on worst case based on input size.
  
  int numDstBytes = (int) encodedData.length;
  int estInputSize = (int)inputData.length+1024;
  
  if (numDstBytes < estInputSize) {
    numDstBytes = estInputSize;
    // White this will zero out bytes, the assumption here
    // is that the capacity is already large enough so that
    // repeated extension does not require a reallocation.
    [encodedData setLength:numDstBytes];
  }
  
  stream.dst_ptr = (uint8_t*) encodedData.mutableBytes;
  stream.dst_size = numDstBytes;
  
  assert(stream.dst_size > 0);  
  
  flags = 0;
  
  do {
    if (stream.dst_size == 0) {
      // Output buffer full, this should not happen
      assert(0);
    }
    
    if (stream.src_size == 0) {
      flags = COMPRESSION_STREAM_FINALIZE;
    }
    
    status = compression_stream_process(&stream, flags);
    
    switch (status) {
      case COMPRESSION_STATUS_OK: {
        // We are going to call compression_stream_process at least once more, so we prepare for that.
        
        if (stream.dst_size == 0) {
          // Output buffer full.
          assert(0);
        }
        break;
      }
      case COMPRESSION_STATUS_END: {
        // We are done, just write out the output buffer if there's anything in it.
        
        if (stream.dst_ptr == (uint8_t*)encodedData.bytes) {
          // No data was encoded
          assert(0);
        } else {
          // Some number of bytes were encoded, shorten the length
          // of encodedData to account for the reduced size.
          
          int numWritten = (int) (stream.dst_ptr - (uint8_t*)encodedData.bytes);
          assert(numWritten <= encodedData.length);
          if (numWritten < encodedData.length) {
            [encodedData setLength:numWritten];
          }
        }
        break;
      }
      case COMPRESSION_STATUS_ERROR: {
        assert(0);
      }
      default: {
        break;
      }
    }
  } while (status == COMPRESSION_STATUS_OK);
  
  assert(stream.src_size == 0);
  
  compression_stream_destroy(&stream);
  
  return;
}

// Streaming delta + compress encoding operation that reads 16, 24, 32 BPP pixels
// and writes data to an output mutable data that contains encoded bytes
// 流式增量+压缩编码操作，可读取16、24、32 BPP像素并将数据写入包含编码字节的输出可变数据。
+ (BOOL) streamDeltaAndCompress:(NSData*)inputData
                    encodedData:(NSMutableData*)encodedData
                            bpp:(int)bpp
                      algorithm:(compression_algorithm)algorithm
{
  const BOOL debug = FALSE;
  
  uint32_t *pixelsPtr = (uint32_t*) inputData.bytes;
  int bufferSize = (int) inputData.length;
  
  assert((bufferSize % sizeof(uint32_t)) == 0);
  const int maxOffset = bufferSize / sizeof(uint32_t);

  NSData *dataToEncode;
  
  NSMutableData *mInputData = [NSMutableData data];
  
  if (bpp == 24) {
    // Generate buffer of BGR bytes without A byte
    
    uint32_t *inPixelsPtr = (uint32_t*) pixelsPtr;
    
    size_t src_size = 3 * maxOffset;
    
    [mInputData setLength:src_size];
    
    uint8_t *outPtr = (uint8_t*) mInputData.mutableBytes;
    
    for ( int i = 0; i < maxOffset; i++ ) {
      uint32_t inPixel = inPixelsPtr[i];
      
      uint8_t B = inPixel & 0xFF;
      uint8_t G = (inPixel >> 8) & 0xFF;
      uint8_t R = (inPixel >> 16) & 0xFF;
      uint8_t A = (inPixel >> 24) & 0xFF;
      
      if (A == 0 || A == 255) {
        // Acceptable values
      } else {
        //NSAssert(0, @"input pixel 0x%08X has invalid alpha channel value %d at offset %d", inPixel, A, i);
        
        return FALSE;
      }
      
      // Binary Layout : B G R B G R
      
      outPtr[0] = B;
      outPtr[1] = G;
      outPtr[2] = R;
      
      outPtr += 3;
    }
    
    if (debug) {
      printf("encoded %d pixel bytes and %d BGR bytes\n", (int)inputData.length, (int)mInputData.length);
    }
    
#if defined(DEBUG)
    // Verify that a simple expansion loop for every 3 bytes produces the original input pixels
    {
      int numBytesOriginal = (int)inputData.length;
      
      NSAssert((numBytesOriginal % sizeof(uint32_t)) == 0, @"bufferSize");
      
      NSMutableData *expandedTmp = [NSMutableData data];
      [expandedTmp setLength:numBytesOriginal];
      
      uint32_t *expandedPixelsPtr = (uint32_t *) expandedTmp.mutableBytes;
      int expandedi = 0;
      
      uint32_t A = (inPixelsPtr[0] >> 24) & 0xFF;
      
      int numBytesEncoded = (int) mInputData.length;
      uint8_t *encodedBytesPtr = (uint8_t*) mInputData.bytes;
      
      for ( int numBytesProcessed = 0; numBytesProcessed < numBytesEncoded; numBytesProcessed += 3 ) {
        // Consume 3 bytes and write word to output
        
        uint32_t B = encodedBytesPtr[numBytesProcessed];
        uint32_t G = encodedBytesPtr[numBytesProcessed+1];
        uint32_t R = encodedBytesPtr[numBytesProcessed+2];
        
        uint32_t pixel = (A << 24) | (R << 16) |(G << 8) | B;
        
        expandedPixelsPtr[expandedi++] = pixel;
      }
      
      NSAssert(expandedi == (numBytesOriginal / sizeof(uint32_t)), @"ptr size");
      
      // Compare expandedTmp and inputData
      
      NSAssert(expandedTmp.length == inputData.length, @"lengths %d != %d", (int)expandedTmp.length, (int)inputData.length);
      
      uint32_t *originalPixelsPtr = (uint32_t*) inputData.bytes;
      
      for ( int i = 0; i < maxOffset; i++ ) {
        // Compare words
        
        uint32_t pixel1 = originalPixelsPtr[i];
        uint32_t pixel2 = expandedPixelsPtr[i];
        
        if (pixel1 != pixel2) {
          printf("0x%08X != 0x%08X at offset %d\n", pixel1, pixel2, i);
        }
        
        NSAssert(pixel1 == pixel2, @"pixel match");
      }
      
      NSAssert([expandedTmp isEqualToData:inputData], @"matches input pixels");
    }
#endif // DEBUG
    
    dataToEncode = mInputData;
  } else {
    // Encode 16 or 32 BPP pixels directly
    
    dataToEncode = inputData;
  }
  
  [AVStreamEncodeDecode streamCompress:dataToEncode encodedData:encodedData algorithm:algorithm];
  
  if (debug) {
    printf("encoded %d BGR bytes as %d compressed bytes\n", (int)dataToEncode.length, (int)encodedData.length);
  }
  
#if defined(DEBUG)
  @autoreleasepool {
    // Decode encoded data back to original and verify
    
    NSMutableData *decodedData = [NSMutableData data];
    [decodedData setLength:inputData.length];
    
    BOOL worked = [AVStreamEncodeDecode streamUnDeltaAndUncompress:encodedData
                                                       frameBuffer:(void*)decodedData.bytes
                                               frameBufferNumBytes:(uint32_t)decodedData.length
                                                               bpp:bpp
                                                         algorithm:algorithm];
    NSAssert(worked, @"streamUnDeltaAndUncompress failed");
    
    int numPixels = (int)decodedData.length / sizeof(uint32_t);
    uint32_t *decodedPixelsPtr = (uint32_t *) decodedData.bytes;
    uint32_t *originalPixelsPtr = (uint32_t *) inputData.bytes;
    
    for ( int pi = 0; pi < numPixels; pi++) {
      uint32_t decodedPixel = decodedPixelsPtr[pi];
      uint32_t originalPixel = originalPixelsPtr[pi];
      if (decodedPixel != originalPixel) {
        printf("offset %d : 0x%08X != 0x%08X\n", pi, decodedPixel, originalPixel);
      }
      NSAssert(decodedPixel == originalPixel, @"0x%08X != 0x%08X\n", decodedPixel, originalPixel);
    }
  }
#endif // DEBUG
  
  return TRUE;
}

// Undo the delta + compress operation so that the original pixel data is recovered
// and written to the indicated pixel buffer.

// algorithm: COMPRESSION_LZ4, COMPRESSION_ZLIB, COMPRESSION_LZMA, COMPRESSION_LZFSE

+ (BOOL) streamUnDeltaAndUncompress:(NSData*)encodedData
                        frameBuffer:(void*)frameBuffer
                frameBufferNumBytes:(uint32_t)frameBufferNumBytes
                                bpp:(int)bpp
                          algorithm:(compression_algorithm)algorithm
{
  const BOOL debug = FALSE;
  const BOOL debugReadSizes = FALSE;
  
  size_t src_size = (int) encodedData.length;
  uint8_t *src_buffer = (uint8_t*) encodedData.bytes;
  
  size_t dst_size;
  uint64_t *dst_buffer = NULL;
  int malloc_dst_buffer = 0;
  
  uint32_t * const framebufferPixelPtr = (uint32_t*) frameBuffer;
  int framebufferWritei = 0;
  const int framebufferWriteiMax = frameBufferNumBytes / sizeof(uint32_t);
  
  const int numWordsIn24BPPInputBuffer = 12;
  
  if (bpp == 16 || bpp == 32) {
    dst_size = frameBufferNumBytes;
    dst_buffer = frameBuffer;
  } else {
    // 24 BPP -> 12 words -> 6 double words
    
    // Reads are done in terms of 3 words which contain 4 pixels
    // 3  words = 12 bytes = 4 output pixels
    // 6  words = 24 bytes = 8 output pixels
    // 9  words = 36 bytes = 12 output pixels
    // 12 words = 48 bytes = 16 output pixels
    
    dst_size = numWordsIn24BPPInputBuffer * sizeof(uint32_t);
    dst_buffer = (uint64_t*) malloc(dst_size);
    assert(dst_buffer);
    assert(((int)dst_buffer % sizeof(uint64_t)) == 0);
    malloc_dst_buffer = 1;
  }
  
  compression_status status = COMPRESSION_STATUS_OK;
  
  compression_stream_flags flags;
  compression_stream stream;
  
  compression_stream_operation operation = COMPRESSION_STREAM_DECODE;
  
  status = compression_stream_init(&stream, operation, algorithm);
  
  if (status == COMPRESSION_STATUS_OK) {
    // Nop
  } else if (status == COMPRESSION_STATUS_ERROR) {
    assert(0);
  } else {
    assert(0);
  }
  
  // Setup input pointer and length since all src data is known
  
  stream.src_ptr = src_buffer;
  stream.src_size = src_size;
  
  //printf("initial input ptr offset %d\n", (int)(stream.src_ptr - src_buffer));
  //printf("initial input num bytes left %d\n", (int)stream.src_size);
  
  stream.dst_ptr = (uint8_t*) dst_buffer;
  stream.dst_size = dst_size;
  
  flags = 0;
  
  do {
    if (stream.src_size == 0) {
      // Read all input data
      
      flags = COMPRESSION_STREAM_FINALIZE;
      
      if (debugReadSizes) {
        printf("COMPRESSION_STREAM_FINALIZE: passed in as flag\n");
      }
    }
    
    status = compression_stream_process(&stream, flags);
    
    int numBytesDecoded = 0;
    
    switch (status) {
      case COMPRESSION_STATUS_OK: {
        // We are going to call compression_stream_process at least once more, so we prepare for that.
        
        numBytesDecoded = (int) (dst_size - stream.dst_size);
        
        if (debugReadSizes) {
          printf("COMPRESSION_STATUS_OK: numBytesDecoded %d\n", (int)numBytesDecoded);
        }
        
        if (numBytesDecoded == 0) {
          // No bytes returned by decompression operation
          assert(0);
        } else if (numBytesDecoded == dst_size) { // aka (stream.dst_size == 0)
          // Output buffer full.
        } else {
          // Output buffer not completely full, process N
          assert(0);
        }
        
        break;
      }
      case COMPRESSION_STATUS_END: {
        // Partial buffer decoded
        
        numBytesDecoded = (int) (dst_size - stream.dst_size);
        
        if (debugReadSizes) {
          printf("COMPRESSION_STATUS_END : decoded %d bytes\n", (int)numBytesDecoded);
        }
        
        break;
      }
      case COMPRESSION_STATUS_ERROR: {
        assert(0);
      }
      default: {
        break;
      }
    }
    
    if (numBytesDecoded > 0) {
      // Common block to handle N bytes being decoded
      
      if (bpp == 24) {
#if defined(DEBUG)
        if (status != COMPRESSION_STATUS_END) {
          assert(numBytesDecoded == dst_size);
        }
        assert((numBytesDecoded % 3) == 0);
#endif // DEBUG
        
        if ((numBytesDecoded == dst_size) && (status == COMPRESSION_STATUS_OK)) {
          // Full buffer of known fixed size
          
          if (debug) {
            for ( int i = 0; i < numBytesDecoded; i++) {
              if ((i != 0)&& ((i%4) == 0)) {
                printf("\n");
              }
              
              uint8_t bVal = ((uint8_t*)dst_buffer)[i];
              printf("0x%02X ", bVal);
            }
            
            printf("\n");
          }
          
          // Consume 3 words of input at a time and write 4 pixels
          // 3 words contains 4 condensed pixels, 12 word decode buffer is 48 bytes
          
          int s3 = 0;
          const int maxi = 4;
          
#if defined(DEBUG)
          assert((numWordsIn24BPPInputBuffer * 4) == numBytesDecoded);
#endif // DEBUG
          
          for ( int i = 0; i < maxi; i++, s3 += 3 ) {
            uint32_t inputWord0 = ((uint32_t*)dst_buffer)[s3+0];
            uint32_t inputWord1 = ((uint32_t*)dst_buffer)[s3+1];
            uint32_t inputWord2 = ((uint32_t*)dst_buffer)[s3+2];
            
            if (inputWord0 != 0 || inputWord1 != 0 || inputWord2 != 0) {
              if (debug) {
                printf("not zero\n");
              }
            }
            
            if (debug) {
              printf("loop %5d (%d %d)\n", i, s3+0, s3+2);
              printf("in word %5d : 0x%08X\n", s3+0, inputWord0);
              printf("in word %5d : 0x%08X\n", s3+1, inputWord1);
              printf("in word %5d : 0x%08X\n", s3+2, inputWord2);
            }
            
            uint32_t outWord;
            
            outWord = (0xFF << 24);
            outWord |= inputWord0 & 0x00FFFFFF; // -RGB
            
#if defined(DEBUG)
            assert(framebufferWritei < framebufferWriteiMax);
#endif // DEBUG
            framebufferPixelPtr[framebufferWritei++] = outWord;
            
            if (debug) {
              printf("out word 1 : 0x%08X\n", outWord);
            }
            
            outWord = (0xFF << 24);
            outWord |= (inputWord0 >> 24); // ---B
            outWord |= (inputWord1 & 0x0000FFFF) << 8; // -RG-
            
#if defined(DEBUG)
            assert(framebufferWritei < framebufferWriteiMax);
#endif // DEBUG
            framebufferPixelPtr[framebufferWritei++] = outWord;
            
            if (debug) {
              printf("out word 2 : 0x%08X\n", outWord);
            }
            
            outWord = (0xFF << 24);
            outWord |= (inputWord1 >> 16); // --GB
            outWord |= (inputWord2 & 0x000000FF) << 16; // -R--
            
#if defined(DEBUG)
            assert(framebufferWritei < framebufferWriteiMax);
#endif // DEBUG
            framebufferPixelPtr[framebufferWritei++] = outWord;
            
            if (debug) {
              printf("out word 3 : 0x%08X\n", outWord);
            }
            
            outWord = (0xFF << 24);
            outWord |= (inputWord2 >> 8); // -RGB
            
#if defined(DEBUG)
            assert(framebufferWritei < framebufferWriteiMax);
#endif // DEBUG
            framebufferPixelPtr[framebufferWritei++] = outWord;
            
            if (debug) {
              printf("out word 4 : 0x%08X\n", outWord);
            }
          }
        } else {
          for ( int numBytesProcessed = 0; numBytesProcessed < numBytesDecoded; numBytesProcessed += 3 ) {
            // Consume 3 bytes and write word to output
            
            uint32_t B = ((uint8_t*)dst_buffer)[numBytesProcessed];
            uint32_t G = ((uint8_t*)dst_buffer)[numBytesProcessed+1];
            uint32_t R = ((uint8_t*)dst_buffer)[numBytesProcessed+2];
            
            uint32_t pixel = (0xFF << 24);
            pixel |= B;
            pixel |= (G << 8);
            pixel |= (R << 16);
            
            // Word write to framebuffer
            
            framebufferPixelPtr[framebufferWritei++] = pixel;
            
            if (framebufferWritei == framebufferWriteiMax) {
              // Break out of write to framebuffer logic at this point
              // since more bytes can be returned than were originally
              // passed into the compression.
              break;
            }
          }
        }
        
        stream.dst_ptr = (uint8_t*) dst_buffer;
        stream.dst_size = dst_size;
      } else {
        // NOP: Words or halfwords already written to framebuffer
      }
    }
  } while (status == COMPRESSION_STATUS_OK);
  
  assert(stream.src_size == 0);
  
  compression_stream_destroy(&stream);
  
#if defined(DEBUG)
  if (bpp == 24) {
    int numBytesWritten = framebufferWritei * sizeof(uint32_t);
    assert(numBytesWritten == frameBufferNumBytes);
  }
#endif // DEBUG
  
  if (malloc_dst_buffer) {
    free(dst_buffer);
  }
  
  return TRUE;
}

@end

#endif // HAS_LIB_COMPRESSION_API
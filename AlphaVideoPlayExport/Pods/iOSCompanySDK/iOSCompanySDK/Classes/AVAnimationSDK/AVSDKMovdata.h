////  AVSDKMovdata.h
//  iOSCompanySDK
//
//  Created on 2020/9/3.
//  
//

#ifndef AVSDKMovdata_h
#define AVSDKMovdata_h

#include <stdio.h>
#include <assert.h>

extern const uint8_t* const extern_alphaTablesPtr;

#define PREMULT_TABLEMAX 256

// Execute premultiply logic on RGBA components split into componenets.
// For example, a pixel RGB (128, 0, 0) with A = 128
// would return (255, 0, 0) with A = 128
// 对拆分为多个分量的RGB分量执行预乘逻辑。
// 例如，A = 128的像素RGB（128，0，0）将返回A = 128的（255，0，0）
static
inline
uint32_t avsdkpremultiply_bgra_inline(uint32_t red, uint32_t green, uint32_t blue, uint32_t alpha)
{

#if defined(DEBUG)
  assert(red >= 0 && red <= 255);
  assert(green >= 0 && green <= 255);
  assert(blue >= 0 && blue <= 255);
  assert(alpha >= 0 && alpha <= 255);
#endif
  const uint8_t* const restrict alphaTable = &extern_alphaTablesPtr[alpha * PREMULT_TABLEMAX];
  uint32_t result = (alpha << 24) | (alphaTable[red] << 16) | (alphaTable[green] << 8) | alphaTable[blue];
  return result;
}






#endif /* AVSDKMovdata_h */

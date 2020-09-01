//
//  AV7zApng2MvidResourceLoader.h
//
//  Created by Moses DeJong on 5/2/11.
//
//  License terms defined in License.txt.
//
// This loader decompresses a 7zip resource that contains a .apng movie
// and converts to a .mvid video file. See AVApng2MvidResourceLoader.h
// for more info about APNG format support.
/** func:
 这是装载解压一个7zip资源，此资源包含了一个.apng视频和转换成一个.mvid后缀名的视频文件。
 详情可查看 AVApng2MvidResourceLoader.h 头文件包含了更多APNG格式的支持。
 
 */


#import <Foundation/Foundation.h>

#import "AV7zAppResourceLoader.h"

@interface AV7zApng2MvidResourceLoader : AV7zAppResourceLoader {
  BOOL m_alwaysGenerateAdler;
}

@property (nonatomic, assign) BOOL alwaysGenerateAdler;

+ (AV7zApng2MvidResourceLoader*) aV7zApng2MvidResourceLoader;

@end

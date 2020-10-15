////  AVSDKAssetAlphaJoinBgImgExportVideo.h
//  iOSCompanySDK
//
//  Created on 2020/9/3.
//  
//

/** func:
 带透明通道视频+底部图像 ==> 导出新的视频。

*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// 输出flag
#define NeedLogging 0
#define NeedProgress 0

// 打印日志
#if NeedLogging==1

//#define LOGGING

#endif

// 打印生成进程
#if NeedProgress==1

//#define PROGRESS 1

#endif




#define kAlphaVideoCombineImgFinishNotification @"AlphaVideoCombineImgFinishNotification"


//  模板定制 - 两个资源文件名称
#define kVideoColorStr @"mvRGB.mp4"
#define kVideoMaskStr @"mvAlpha.mp4"
#define kVideoJsonStr @"mvJson.json"

 
@interface AVSDKAssetAlphaJoinBgImgExportVideo : NSObject


//
+ (AVSDKAssetAlphaJoinBgImgExportVideo *)aVSDKAssetAlphaJoinBgImgExportVideo;



//  load resources
- (void)loadAVAnimationResourcesWithMovieRGBFilePath:(NSString *)rgbFilePath movieAlphaFilePath:(NSString *)movieAlphaFilePath outPath:(NSString *)outPath bgCoverImg:(UIImage *)bgCoverImg bgCoverImgPoint:(CGPoint)bgCoverImgPoint needCoverImgSize:(CGSize)needCoverImgSize;



@end

NS_ASSUME_NONNULL_END


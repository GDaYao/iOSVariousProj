////  AVAssetAlphaJoinBgImgExportVideo.h
//  AlphaVideoPlayExport
//
//  Created on 2020/9/3.
//


/** func:
 带透明通道视频+底部图像 ==> 导出新的视频。
 
 */

#import "AVAppResourceLoader.h"

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN



@interface AVAssetAlphaJoinBgImgExportVideo : AVAppResourceLoader {
    
    
}


// 后面背景图
@property (nonatomic,strong)UIImage *bgCoverImg;


// movie rgb file path name
@property (nonatomic, copy) NSString *movieRGBFilename;

// alpha movie file path name
@property (nonatomic, copy) NSString *movieAlphaFilename;

// export video path,example: ~/xxx/xxx.mp4
@property (nonatomic, copy) NSString *outPath;

//
+ (AVAssetAlphaJoinBgImgExportVideo *)aVAssetAlphaJoinBgImgExportVideo;



@end

NS_ASSUME_NONNULL_END

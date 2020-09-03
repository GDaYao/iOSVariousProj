////  AlphaVideoPlayExportViewController.h
//  AlphaVideoPlayExport
//
//  Created on 2020/8/28.
//  Copyright © 2020 dayao. All rights reserved.
//


/** func: 透明视频 -- 播放以及导出功能实现
 *
 *
 */


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/*  模板定制 - 两个资源文件名称    */
#define kVideoColorStr @"mvRGB.mp4"
#define kVideoMaskStr @"mvAlpha.mp4"
#define kVideoJsonStr @"mvJson.json"



@interface AlphaVideoPlayExportViewController : UIViewController


@property (nonatomic,strong)UIImage *bgCoverImg;


// 素材名称
@property (nonatomic,copy)NSString *mvColorStr;
@property (nonatomic,copy)NSString *mvMaskStr;
@property (nonatomic,copy)NSString *mvJsonPath; // json路径地址


/* 存放素材的路径地址 */
@property (nonatomic,copy)NSString *unzipVideoPath; // 路径地址-解压后的路径地址，不是资源地址。资源地址需从新拼接。
@property (nonatomic,copy)NSString *fileName; // mvid后缀--当前文件名称



@end

NS_ASSUME_NONNULL_END

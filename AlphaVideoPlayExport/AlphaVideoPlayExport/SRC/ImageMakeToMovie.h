//
//  CEMovieMaker.h
// func: 图片生成视频



@import AVFoundation;
@import Foundation;
@import UIKit;


typedef void(^CEMovieMakerCompletion)(NSURL *fileURL);

#if __has_feature(objc_generics) || __has_extension(objc_generics)
    #define CE_GENERIC_URL <NSURL *>
    #define CE_GENERIC_IMAGE <UIImage *>
#else
    #define CE_GENERIC_URL
    #define CE_GENERIC_IMAGE
#endif


@interface ImageMakeToMovie : NSObject

// test
@property (nonatomic,strong)AVPlayerLayer *avPlayerLayer1;
@property (nonatomic,strong)AVPlayerLayer *avPlayerLayer2;
@property (nonatomic,strong)AVPlayerLayer *avPlayerLayer3;



@property (nonatomic, strong) AVAssetWriter *assetWriter;
@property (nonatomic, strong) AVAssetWriterInput *writerInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *bufferAdapter;
@property (nonatomic, strong) NSDictionary *videoSettings;
@property (nonatomic, assign) CMTime frameTime;
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, copy) CEMovieMakerCompletion completionBlock;

+ (NSDictionary *)videoSettingsWithCodec:(NSString *)codec withWidth:(CGFloat)width andHeight:(CGFloat)height;
- (instancetype)initWithSettings:(NSDictionary *)videoSettings;

// 导入全部图片生成movie
- (void)createMovieFromImageURLs:(NSArray CE_GENERIC_URL*)urls withCompletion:(CEMovieMakerCompletion)completion;
- (void)createMovieFromImages:(NSArray CE_GENERIC_IMAGE*)images withCompletion:(CEMovieMakerCompletion)completion;

#pragma mark - 单个图片导入处理
// 初始化各参数
- (void)createMovieInitProperty;
- (void)createMovieAppenPixelBufferWithImage:(UIImage *)img imgIndex:(NSInteger)i;
// 全部图片导入完成
- (void)createMovieFinishWithCompletion:(CEMovieMakerCompletion)completion;



@end



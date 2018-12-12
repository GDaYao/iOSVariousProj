//
//  UIImage+WaterImg.h

//function: 自定义UIImage图像处理(添加水印)的方法

#import <UIKit/UIKit.h>

@interface UIImage (WaterImg)

// 给图片添加图片水印
/**
 具体使用
 UIImage *originImg = [UIImage iamgeName:@"bgImg"];
 UIImage *addWaterImg = [UIImage AddWaterImageWithImage:originImg waterImage:[UIImage imageNamed:@"waterImg.png"] waterImageRect:CGRectMake(originImg.size.width-waterImg.size.width*2-5, originImg.size.height-waterImg.size.height*2-5, waterImg.size.width*2, waterImg.size.height*2)];
*/

// 图片添加图片水印
+ (UIImage *)AddWaterImageWithImage:(UIImage *)image waterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect;
//图片添加图片和lab文字水印
+ (UIImage *)AddWaterImageWithImage:(UIImage *)image waterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect withLab:(UILabel *)waterLab withLabRect:(CGRect)labRect;

// 图片拼接
+ (UIImage *)addSlaveImage:(UIImage *)slaveImage toMasterImage:(UIImage *)masterImage;




@end




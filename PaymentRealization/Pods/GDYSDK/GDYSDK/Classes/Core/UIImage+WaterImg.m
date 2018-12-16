//
//  UIImage+WaterImg.m

#import "UIImage+WaterImg.h"

@implementation UIImage (WaterImg)

#pragma mark - 直接添加图片水印
+ (UIImage *)AddWaterImageWithImage:(UIImage *)image waterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect
{
    //1.获取图片
    //2.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //3.绘制背景图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //绘制水印图片到当前上下文
    [waterImage drawInRect:rect];
    //4.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}

#pragma mark - 给图片添加+图片水印+数文字lab
+ (UIImage *)AddWaterImageWithImage:(UIImage *)image waterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect withLab:(UILabel *)waterLab withLabRect:(CGRect)labRect{
    
    //1.获取图片
    //2.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //3.绘制背景图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //绘制水印图片到当前上下文
    [waterImage drawInRect:rect];
    [waterLab drawTextInRect:labRect];
    //4.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
}


#pragma mark -  图片拼接操作
/**
 masterImage  主图片，生成的图片的宽度为masterImage的宽度
 slaveImage   从图片，拼接在masterImage的下面
 */

+ (UIImage *)addSlaveImage:(UIImage *)slaveImage toMasterImage:(UIImage *)masterImage
{
    CGSize size;
    size.width = masterImage.size.width/2;
    size.height = masterImage.size.height/2 + slaveImage.size.height/2;
    
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0);
    
    //Draw masterImage
    [masterImage drawInRect:CGRectMake(0, 0, masterImage.size.width/2, masterImage.size.height/2)];
    
    //Draw slaveImage
    [slaveImage drawInRect:CGRectMake(0, masterImage.size.height/2, masterImage.size.width/2, slaveImage.size.height/2)];
    
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return resultImage;
}


@end




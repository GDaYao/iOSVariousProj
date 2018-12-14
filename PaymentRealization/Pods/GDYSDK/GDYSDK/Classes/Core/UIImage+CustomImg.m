//
//  UIImage+CustomImg.m


#import "UIImage+CustomImg.h"

@implementation UIImage (CustomImg)

#pragma mark - ---- capture image from UIView ----
+ (UIImage *)backImgFromView:(UIView *)specifilyView{
    UIGraphicsBeginImageContextWithOptions(specifilyView.bounds.size, specifilyView.opaque, 0.0); //specifilyView.bounds.size
    [specifilyView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

#pragma mark - ---- in GPU image to capture image from UIView ----
+ (UIImage *)captureImgWhenViewIsGPUImageV:(UIView *)view{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextConcatCTM(ctx, [view.layer affineTransform]);
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {//iOS 7+
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    } else {    //iOS 6
        [view.layer renderInContext:ctx];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(ctx);
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark - change image size
+ (UIImage *)changeImgSize:(UIImage *)currentImg changeSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [currentImg drawInRect:CGRectMake(0.0f, 0.0f, size.width,size.height)];
    currentImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return currentImg;
}





@end

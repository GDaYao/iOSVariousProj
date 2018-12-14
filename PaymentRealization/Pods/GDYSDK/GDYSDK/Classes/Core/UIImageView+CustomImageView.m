//
//  UIImageView+CustomImageView.m

#import "UIImageView+CustomImageView.h"

@implementation UIImageView (CustomImageView)

+ (UIImageView *)IVInitImageViewImage:(NSString *)imgName{
    UIImageView *iv = [[UIImageView alloc]init];
    iv.image = [UIImage imageNamed:imgName];
    iv.userInteractionEnabled = YES;
    iv.multipleTouchEnabled = YES;
    return iv;
}


@end

//
//  UIView+CustomView.m

#import "UIView+CustomView.h"

@implementation UIView (CustomView)

+ (UIView *)InitView:(UIColor *)bgColor initWithFrame:(CGRect)frame
{
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = bgColor;
    if (frame.size.width !=0 && frame.size.height!= 0) {
        v.frame = frame;
    }
    
    return v;
    
}


@end



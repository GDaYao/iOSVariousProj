//
//  UIScrollView+CustomScrollView.m

#import "UIScrollView+CustomScrollView.h"

@implementation UIScrollView (CustomScrollView)

+ (UIScrollView *)ScrollViewInitWithBGColor:(UIColor *)BGC withBounces:(BOOL)bounes withMaxScale:(float)maxScale withMinScale:(float)minScale withContentSize:(CGSize)contentSize withSVDelegate:(id)delegate
{
    UIScrollView *sv = [[UIScrollView alloc]init];
    sv.userInteractionEnabled = YES;
    sv.multipleTouchEnabled = YES;
    sv.scrollEnabled = YES;
    if (BGC) {
        sv.backgroundColor = BGC;        
    }
    sv.bounces  = bounes;
    if (maxScale >0 && minScale >0 ) {
        sv.maximumZoomScale = maxScale;
        sv.minimumZoomScale = minScale;
    }
    if((contentSize.width > 0) && (contentSize.height > 0)){
        sv.contentSize = contentSize;
    }
    sv.delegate = delegate;
    return sv;
}



@end

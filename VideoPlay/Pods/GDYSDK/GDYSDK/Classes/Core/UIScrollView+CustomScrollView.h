//
// 自定义UIScrollView

//function: 自定义UIScrollView,初始化并封装常用方法

#import <UIKit/UIKit.h>

@interface UIScrollView (CustomScrollView)

+ (UIScrollView *)ScrollViewInitWithBGColor:(UIColor *)BGC withBounces:(BOOL)bounes withMaxScale:(float)maxScale withMinScale:(float)minScale withContentSize:(CGSize)contentSize withSVDelegate:(id)delegate;

@end

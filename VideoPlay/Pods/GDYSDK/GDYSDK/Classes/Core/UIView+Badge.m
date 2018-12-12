//
//  UIView+Badge.m


#import "UIView+Badge.h"
#include <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "UIBadgeLable.h"
const static  void *badgeLableString = &badgeLableString;
@implementation UIView (Badge)

//只是设置圆点
-(void)makeRedBadge:(CGFloat)corner color:(UIColor *)cornerColor{
    
  //圆点大小
  //圆点颜色
    if ([self badgeLable]==nil) {//如果没有绑定就重新创建,然后绑定
        UIBadgeLable *badgeLable =[[UIBadgeLable alloc] init];
        objc_setAssociatedObject(self, badgeLableString, badgeLable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:badgeLable];
    }
    [[self badgeLable]setFrame:CGRectMake(self.frame.size.width-corner, -corner, corner*2.0, corner*2.0)];
   
    [[self  badgeLable] makeBrdgeViewWithCor:corner CornerColor:cornerColor];
    
}

#pragma mark - 配置角标属性使用
-(void)makeBadgeText:(NSString *)text
               textColor:(UIColor *)tColor
               backColor:(UIColor *)backColor
                    Font:(UIFont*)tfont{
    if ([self badgeLable]==nil) {//如果没有绑定就重新创建,然后绑定
        UIBadgeLable *badgeLable =[[UIBadgeLable alloc] init];
        objc_setAssociatedObject(self, badgeLableString, badgeLable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self addSubview:badgeLable];
    }
    CGSize textSize=[self sizeWithString:text font:tfont constrainedToWidth:self.frame.size.width];
        if ([self isKindOfClass:[UIButton class]]) {
            UIButton *weakButton=(UIButton*)self;
            [[self  badgeLable] makeBrdgeViewWithText:text textColor:tColor backColor:backColor textFont:tfont tframe:CGRectMake(weakButton.imageView.frame.size.width*0.5+weakButton.imageView.frame.origin.x,weakButton.imageView.frame.origin.y, textSize.width+8.0, textSize.height)];
        }else{
    
         [[self  badgeLable] makeBrdgeViewWithText:text textColor:tColor backColor:backColor textFont:tfont tframe:CGRectMake(self.frame.size.width-(textSize.width+8.0)*0.5, -textSize.height*0.5, textSize.width+8.0, textSize.height)];
        }
}
-(void)removeBadgeView{
    
    [[self badgeLable] removeFromSuperview];
  
}
-(UIBadgeLable *)badgeLable{
    
    UIBadgeLable *badgeLable=objc_getAssociatedObject(self, badgeLableString);
    return badgeLable;
}
#pragma mark sizeLableText--计算lab字体的宽度和高度
-(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font constrainedToWidth:(CGFloat)width{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)])
    {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:(NSStringDrawingUsesLineFragmentOrigin |
                                                 NSStringDrawingTruncatesLastVisibleLine)
                                     attributes:attributes
                                        context:nil].size;
    } else
    {
        textSize = [string sizeWithFont:textFont
                      constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                          lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                    options:(NSStringDrawingUsesLineFragmentOrigin |
                                             NSStringDrawingTruncatesLastVisibleLine)
                                 attributes:attributes
                                    context:nil].size;
#endif
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
    
}

@end

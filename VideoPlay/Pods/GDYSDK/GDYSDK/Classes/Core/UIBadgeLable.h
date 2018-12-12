//
//  UIBadgeLable.h


#import <UIKit/UIKit.h>



@interface UIBadgeLable : UILabel

-(void)makeBrdgeViewWithText:(NSString *)text textColor:(UIColor *)textColor   backColor:(UIColor *)backGColor textFont:(UIFont *)font tframe:(CGRect )frame;

-(void)makeBrdgeViewWithCor:(CGFloat )corner CornerColor:(UIColor *)cornerColor;


@end

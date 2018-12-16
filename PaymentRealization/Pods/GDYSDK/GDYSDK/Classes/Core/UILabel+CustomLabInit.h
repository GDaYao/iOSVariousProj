
//
// 自定义UILabel初始化时使用

//function: 自定义UILabel,初始化并封装常用方法

#import <UIKit/UIKit.h>

@interface UILabel (CustomLabInit)

/**
 init lab
 */
+ (UILabel *)InitLabWithBGColor:(NSString *)hexStr textColor:(UIColor *)txC fontName:(NSString *)fontName fontSize:(CGFloat)fontSize labText:(NSString *)labText txAlignment:(NSTextAlignment)txAlignment;


/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;



@end



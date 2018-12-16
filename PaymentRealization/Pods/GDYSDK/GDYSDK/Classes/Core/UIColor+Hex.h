//
//  UIColor+Hex.h

//function: 自定义UIColor色值转换方法

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

#pragma mark - hex string convert to color object
+ (UIColor *) colorWithHexString: (NSString *)hexString;

#pragma mark - color string  covert to 'R+G+B' int sum
+ (int)RGBSumWithHexString:(NSString *)hexString;

#pragma  mark -  UIColor covert to hex string
+ (NSString *) hexFromUIColor: (UIColor*) color;

#pragma mark - from current color to gray color
+ (int)RGBAddValueWithHextString:(NSString *)hexString colorFloat:(float)colorValue scale:(float)scale operateType:(int)type;

#pragma mark - color object covert to NSString object
- (NSString*)hexString;

#pragma mark - generate random color
+ (UIColor *) randomColor;






@end



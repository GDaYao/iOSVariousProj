//
//  UISlider+CustomSlider.h

// func: custom slider

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISlider (CustomSlider)

/**
 init lab
 */
+ (UISlider *)InitSliderWithMinValue:(float)minValue MaxValue:(float)maxValue defaultValue:(float)defaultValue isContinuous:(BOOL)isCon minimumColor:(UIColor *)minimumColor maximumColor:(UIColor *)maximumColor thumbColor:(UIColor *)thumbColor;


@end

NS_ASSUME_NONNULL_END

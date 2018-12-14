//
//  UISlider+CustomSlider.m


#import "UISlider+CustomSlider.h"

// use
//#import "CustomSlider.h"

@implementation UISlider (CustomSlider)


#pragma mark - init slider
+ (UISlider *)InitSliderWithMinValue:(float)minValue MaxValue:(float)maxValue defaultValue:(float)defaultValue isContinuous:(BOOL)isCon minimumColor:(UIColor *)minimumColor maximumColor:(UIColor *)maximumColor thumbColor:(UIColor *)thumbColor{
    UISlider *slider = [[UISlider alloc]init];

    slider.minimumValue = minValue;
    slider.maximumValue = maxValue;
    slider.value = defaultValue;    // 设置初始值
    slider.continuous = isCon;      // 设置可连续变化
    slider.minimumTrackTintColor = minimumColor;    // 滑轮左边部分滑动条颜色，如果设置了左边的图片就不会显示
    slider.maximumTrackTintColor = maximumColor;   // 滑轮右边部分滑动条颜色，如果设置了右边的图片就不会显示
    slider.thumbTintColor = thumbColor; // 滑轮颜色
    return slider;
    //[slider addTarget:self action:@selector(xxx) forControlEvents:UIControlEventValueChanged|UIControlEventTouchUpInside];// 针对值变化添加响应方法
    // reset  thumb slider size
//    [self.playSlider setThumbImage:testImg forState:UIControlStateNormal];
//    [self.playSlider setThumbImage:testImg forState:UIControlStateHighlighted];
}




@end

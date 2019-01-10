//
//  MusicSliderView.m
//  VideoPlay
//


#import "MusicSliderView.h"

@implementation MusicSliderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _nowTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        _nowTimeLabel.font = [UIFont systemFontOfSize:14];
        _nowTimeLabel.textAlignment = NSTextAlignmentCenter;
        _nowTimeLabel.text = @"00:00";
        [self addSubview:_nowTimeLabel];
        
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_nowTimeLabel.frame) + 10, 0, self.bounds.size.width - 100, 30)];
        _slider.continuous = YES;
        _slider.minimumTrackTintColor = [UIColor greenColor];   //滑轮左边颜色，如果设置了左边的图片就不会显示
        _slider.maximumTrackTintColor = [UIColor grayColor]; //滑轮右边颜色，如果设置了右边的图片就不会显示
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
        [self addSubview:_slider];
        
        _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_slider.frame) + 10, 0, 40, 30)];
        _totalTimeLabel.font = [UIFont systemFontOfSize:14];
        _totalTimeLabel.textAlignment = NSTextAlignmentCenter;
        _totalTimeLabel.text = @"00:00";
        [self addSubview:_totalTimeLabel];
        
    }
    return self;
}
- (void)sliderValueChanged:(UISlider *)slider
{
    self.sliderValueChangeWithCallback(slider);
}







@end

//
//  MusicSliderView.h
//  VideoPlay
//

// func: 时间进度滑动控制条


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface MusicSliderView : UIView


@property (nonatomic, strong) UILabel *nowTimeLabel;
@property (nonatomic, strong) UILabel *totalTimeLabel;
@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, strong) void (^sliderValueChangeWithCallback)(UISlider *slider);




@end




NS_ASSUME_NONNULL_END

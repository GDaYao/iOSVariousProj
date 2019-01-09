//
//  RotationView.h
//  VideoPlay
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RotationView : UIView

@property (assign, nonatomic) BOOL isPlay;

@property (strong, nonatomic)  UIButton *btn;

@property (strong, nonatomic)   UIImageView *CDimageView;

@property (nonatomic,strong) void(^playBlock)(BOOL isPlay);

- (void)playOrPause;


@end

NS_ASSUME_NONNULL_END

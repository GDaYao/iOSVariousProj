//
//  TanTanAnimationView.h
//  AnimationEffect
//

// func: 探探动画效果


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TanTanAnimationView : UIView

@property (nonatomic,strong)UIView *slideView;

@property (nonatomic,strong)UIView *showSaveView;


- (void)createCard;



@end

NS_ASSUME_NONNULL_END

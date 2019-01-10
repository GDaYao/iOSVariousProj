//
//  FreeStreamerView.h
//  VideoPlay
//


#import <UIKit/UIKit.h>

#import "RotationView.h"


NS_ASSUME_NONNULL_BEGIN


@interface FreeStreamerView : UIView


@property (nonatomic,strong) RotationView *centerRotationView;


// `block` play setting
@property (nonatomic,strong) void(^isPlayer)(BOOL yes);
@property (nonatomic,strong) void(^scrollViewDidEndDecelerating)(UIScrollView *scrollView, BOOL isScroll);


- (void)scrollRightWithNextOne;
- (void)scrollLeftWithLastOne;
- (void)playOrPause;
// 进入视图更新播放界面
- (void)reloadNew;




@end

NS_ASSUME_NONNULL_END



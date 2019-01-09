//
//  FreeStreamerView.h
//  VideoPlay
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FreeStreamerView : UIView



// block
@property (nonatomic,strong) void(^playBlock)(BOOL isPlay);




@end

NS_ASSUME_NONNULL_END

//
//  BarChartView.h
//  DrawGraph
//


// func:  柱状图效果实现 -- CGContextRef



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BarChartView : UIView

@property (nonatomic,copy)NSArray* numsArr;

@property (nonatomic,assign)float totalNum;



@end

NS_ASSUME_NONNULL_END



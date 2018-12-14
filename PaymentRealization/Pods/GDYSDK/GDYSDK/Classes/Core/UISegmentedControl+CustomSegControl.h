//
//  UISegmentedControl+CustomSegControl.h


#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN



@interface UISegmentedControl (CustomSegControl)

/**
 init UISegmentControl

 @param itemsArray `UISegmentControl` show object array.
 @param segFrame Set segment control frame.
 @param selectedIndex Set default index.
 @param tintColor Set tint color.
 @return Back `UISegmentedControl` object.
 */
+ (UISegmentedControl *)InitSegControlWithInitItems:(NSArray *)itemsArray segmentFrame:(CGRect)segFrame defaultSelectedSegmentIndex:(NSInteger)selectedIndex segTintColor:(UIColor *)tintColor;

@end


NS_ASSUME_NONNULL_END



//
//  UIPickerView+CustomPickerView.h

// func: custom `UIPickerView` use

#import <UIKit/UIKit.h>



@interface UIPickerView (CustomPickerView)

#pragma mark - UIPickerView init
+ (UIPickerView *)InitPickerView:(UIColor *)bgColor initWithFrame:(CGRect)frame withDelegateVC:(id)delegegateVC dataSourceVC:(id)dataSourceVC;

@end



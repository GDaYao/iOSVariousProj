//
//  UISegmentedControl+CustomSegControl.m


#import "UISegmentedControl+CustomSegControl.h"

@implementation UISegmentedControl (CustomSegControl)

#pragma mark - init segmented control
+ (UISegmentedControl *)InitSegControlWithInitItems:(NSArray *)itemsArray segmentFrame:(CGRect)segFrame defaultSelectedSegmentIndex:(NSInteger)selectedIndex segTintColor:(UIColor *)tintColor {
    
    /* such as `itemsArray`:
     [NSArray arrayWithObjects:
            [[UIImage imageNamed:@"red"]
                    imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
            [[UIImage imageNamed:@"yellow"]
                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal],
            nil]
     */
    UISegmentedControl *segCon = [[UISegmentedControl alloc]initWithItems:itemsArray];
    segCon.frame = segFrame;
    segCon.selectedSegmentIndex = selectedIndex;
    segCon.tintColor = [UIColor darkGrayColor];
    return segCon;
}





@end

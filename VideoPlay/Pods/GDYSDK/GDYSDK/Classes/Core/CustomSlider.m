//
//  CustomSlider.m

#import "CustomSlider.h"

@implementation CustomSlider

- (instancetype)initWithFrame:(CGRect)frame{
    self =  [super initWithFrame:frame];
    if(self){
        
    }
    return self;
}

#pragma mark - 重写trackRectForBounds:方法改变UISlider track rect
- (CGRect)trackRectForBounds:(CGRect)bounds{
    [super trackRectForBounds:bounds];
    
    return CGRectMake(0, 0, bounds.size.width, bounds.size.height);
}



@end

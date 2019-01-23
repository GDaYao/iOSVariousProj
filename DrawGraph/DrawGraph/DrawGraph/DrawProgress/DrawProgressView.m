//
//  DrawProgressView.m
//  DrawGraph
//


#import "DrawProgressView.h"

@implementation DrawProgressView


- (void)drawRect:(CGRect)rect {

    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:100 startAngle:0 endAngle:(self.progressValue/100.0)*M_PI*2 clockwise:YES];
    [[UIColor blueColor] set];
    [bezierPath setLineWidth:10.0];
    [bezierPath setLineCapStyle:kCGLineCapRound];
    [bezierPath stroke];
    
}




@end

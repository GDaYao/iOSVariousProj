//
//  DrawProgressView.m
//  DrawGraph
//
//  Created by AHZX on 2019/1/21.
//  Copyright © 2019 Dayao. All rights reserved.
//

#import "DrawProgressView.h"

@implementation DrawProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect {

    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:self.center radius:100 startAngle:0 endAngle:(self.progressValue/100.0)*M_PI*2 clockwise:YES];
    [[UIColor blueColor] set];
    [bezierPath setLineWidth:10.0];
    [bezierPath setLineCapStyle:kCGLineCapRound];
    [bezierPath stroke];
    
}




@end

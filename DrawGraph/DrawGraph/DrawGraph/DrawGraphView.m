//
//  DrawGraphView.m
//  DrawGraph
//


#import "DrawGraphView.h"

@implementation DrawGraphView




#pragma mark - init + drawRect
/**/
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    NSLog(@"log--drawRect");
    
    [self drawAddOneLine];
    
    [self drawIntersectionLine];
    
    [self drawQuadCurve];
    
    [self drawRect];
    
    [self drawFanShaped];
}


// 划一条线
- (void)drawAddOneLine{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, 10, 10);
    CGContextAddLineToPoint(ctx, 50, 50);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineWidth(ctx, 10.0);
    CGContextSetLineCap(ctx, kCGLineCapRound); // 设置线的头部方式
    CGContextStrokePath(ctx);
}

// 划两个相交线 -- 三个点依次创建,且不成线性点即可建立相交线段
- (void)drawIntersectionLine{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ctx, 60, 60);
    CGContextAddLineToPoint(ctx, 100, 100);
    CGContextAddLineToPoint(ctx, 220, 150);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(ctx, 10.0);
    CGContextSetLineJoin(ctx, kCGLineJoinRound); // 相交的方式
    CGContextSetLineCap(ctx, kCGLineCapRound); // 设置线的头部方式
    CGContextStrokePath(ctx);
}

// 绘制曲线
- (void)drawQuadCurve{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextMoveToPoint(ctx, 20, 40);
    CGContextAddQuadCurveToPoint(ctx, 100, 150, 200, 50);
    
    CGContextSetLineWidth(ctx, 20.0);
    CGContextSetStrokeColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextStrokePath(ctx);
    
}

// 绘制正方形
- (void)drawRect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextAddRect(ctx, CGRectMake(200, 200, 200, 200));
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor grayColor].CGColor);
    CGContextSetLineWidth(ctx, 10.0);
    
    // 1. 绘制矩形边框
    CGContextStrokePath(ctx);
    // 2. 绘制矩形内部
//    CGContextFillPath(ctx);
    
}

// 绘制扇形 --若需要绘制曲线弧度曲线使用UIBezierPath
- (void)drawFanShaped {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat centerX = 100;
    CGFloat centerY = 300;
    CGFloat radius = 50;
    CGContextMoveToPoint(ctx, centerX, centerY);
    CGContextAddArc(ctx, centerX, centerY, radius, M_PI, 90/180*M_PI, NO);
    CGContextClosePath(ctx); //闭合绘图
    
    CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
    CGContextSetLineWidth(ctx, 5.0);
    
//    CGContextFillPath(ctx); // 涂色扇形内部
    CGContextStrokePath(ctx); // 绘制扇形路径
}








@end






//
//  DrawGraphBezierPathView.m
//  DrawGraph
//
//  Created by AHZX on 2019/1/21.
//  Copyright © 2019 Dayao. All rights reserved.
//

#import "DrawGraphBezierPathView.h"

@implementation DrawGraphBezierPathView



/*
 */
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    [self drawLineWithBezierPath];
    
    [self drawLineUseBezierPathAndCG];
    
    [self drawRectWithUIBezierPath];
    
    [self drawCurveWithUIBezierPath];
}


#pragma mark - `UIBezierPath` function

// 划线
- (void)drawLineWithBezierPath{
    //1.创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //2.画线
    [path moveToPoint:CGPointMake(30, 50)];
    [path addLineToPoint:CGPointMake(30, 100)];
    
    //3.渲染
    [path stroke];
    
}

// 图形上下文 + 贝塞尔曲线 划线
- (void)drawLineUseBezierPathAndCG{
    //1.获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //2.创建路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    //3.画线
    [path moveToPoint:CGPointMake(40, 50)];
    [path addLineToPoint:CGPointMake(40, 100)];
    
    //4.将path添加到上下文
    CGContextAddPath(ctx, path.CGPath);
    
    //5.渲染
    CGContextStrokePath(ctx);
}

// 绘制矩形
- (void)drawRectWithUIBezierPath{
// 绘制空心的圆角矩形
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(60, 50, 100, 40) cornerRadius:10.0];
    [[UIColor grayColor] set];
    [bezierPath stroke];
    
// 绘制实心圆角矩形
    UIBezierPath *bezierPath2 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(60, 140, 100, 100) cornerRadius:10.0];
    [[UIColor greenColor] set];
    [bezierPath2 fill];
    
// 绘制实心圆
    UIBezierPath *bezierPath3 = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(60, 290, 100, 100) cornerRadius:50.0]; // 设置圆角半径为矩形的宽/高一半
    [[UIColor blueColor] set];
    [bezierPath3 fill];
}

// 绘制曲线
- (void)drawCurveWithUIBezierPath{
    /**
     *  绘制弧度曲线
     *
     *  ArcCenter 曲线中心
     *  radius       半径
     *  startAngle 开始的弧度
     *  endAngle 结束的弧度
     *  clockwise YES顺时针，NO逆时针
     */
    
//绘制一条半圆曲线
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(300, 150) radius:50 startAngle:0 endAngle:M_PI clockwise:YES];
    [[UIColor redColor] set];
    [path setLineWidth:10];
    [path setLineCapStyle:(kCGLineCapRound)];
    [path stroke];
    
//绘制一条3/4圆曲线
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(300, 350) radius:50 startAngle:0 endAngle:270/360.0*(M_PI * 2) clockwise:YES];
    [[UIColor yellowColor] set];
    [path2 setLineWidth:10];
    [path2 setLineCapStyle:(kCGLineCapRound)];
    [path2 stroke];
    
//绘制一个圆形曲线
    UIBezierPath *path3 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(300, 550) radius:50 startAngle:0 endAngle:(M_PI * 2) clockwise:YES];
    [[UIColor blueColor] set];
    [path3 setLineWidth:10];
    [path3 setLineCapStyle:(kCGLineCapRound)];
    [path3 stroke];
}







@end

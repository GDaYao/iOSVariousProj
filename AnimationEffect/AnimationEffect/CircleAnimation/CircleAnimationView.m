////  CircleAnimationView.m
//  AnimationEffect
//
//  Created on 2019/10/31.
//  Copyright © 2019 Dayao. All rights reserved.
//

#import "CircleAnimationView.h"

// first
#define KFirstShapelayerLineWidth 8

#define KFirstShapeLayerMargin 150 // 左
#define kFirstShapeLayerTop 300  // 上
#define KFirstShapeLayerWidth 80
#define KFirstShapeLayerRadius 40

// second
#define KSecondShapelayerLineWidth 8

#define KSecondShapeLayerMargin 125  // 左
#define kSecondShapeLayerTop 280    // 上
#define KSecondShapeLayerWidth 130
#define KSecondShapeLayerRadius 65


// 动画时间
#define KFirstAnimationDurationTime 2.5
#define KSecondAnimationDurationTime 1.5


@implementation CircleAnimationView

#pragma mark - init with frame
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        
        [self createCAShapeLayer];
        
        [self createSecondLayerAnimation];
        
    }
    return self;
}
// creat first layer
- (void)createCAShapeLayer {
    
     /// 底部的灰色layer
    CAShapeLayer *bottomShapeLayer = [CAShapeLayer layer];
    bottomShapeLayer.strokeColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    bottomShapeLayer.fillColor = [UIColor clearColor].CGColor;
    bottomShapeLayer.lineWidth = KFirstShapelayerLineWidth;
    bottomShapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(KFirstShapeLayerMargin, kFirstShapeLayerTop, KFirstShapeLayerWidth, KFirstShapeLayerWidth) cornerRadius:KFirstShapeLayerRadius].CGPath;
    [self.layer addSublayer:bottomShapeLayer];
    bottomShapeLayer.hidden = YES;
    
    /// 橘黄色的layer
    CAShapeLayer *ovalShapeLayer = [CAShapeLayer layer];
    ovalShapeLayer.strokeColor = [UIColor whiteColor].CGColor; // [UIColor colorWithRed:0.984 green:0.153 blue:0.039 alpha:1.000].CGColor;
    ovalShapeLayer.fillColor = [UIColor clearColor].CGColor;
    ovalShapeLayer.lineWidth = KFirstShapelayerLineWidth;
    ovalShapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(KFirstShapeLayerMargin, kFirstShapeLayerTop,KFirstShapeLayerWidth, KFirstShapeLayerWidth) cornerRadius:KFirstShapeLayerRadius].CGPath;
    [self.layer addSublayer:ovalShapeLayer];
//    ovalShapeLayer.masksToBounds = YES;
//    ovalShapeLayer.cornerRadius = 5.0;
    
    // 加入动画
    /// 起点动画
    CABasicAnimation * strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(-1);
    strokeStartAnimation.toValue = @(1.0);

    /// 终点动画
    CABasicAnimation * strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0.0);
    strokeEndAnimation.toValue = @(1.0);

    /// 组合动画
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
    animationGroup.duration = KFirstAnimationDurationTime;
    animationGroup.repeatCount = CGFLOAT_MAX;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    [ovalShapeLayer addAnimation:animationGroup forKey:nil];
    
    // 分割各个点
    // ovalShapeLayer.lineDashPattern = @[@6,@3];
     
}


// TODO: create second layer animation
- (void)createSecondLayerAnimation {
    
    /// 底部的灰色layer
       CAShapeLayer *bottomShapeLayer = [CAShapeLayer layer];
       bottomShapeLayer.strokeColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
       bottomShapeLayer.fillColor = [UIColor clearColor].CGColor;
       bottomShapeLayer.lineWidth = KSecondShapelayerLineWidth;
       bottomShapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(KSecondShapeLayerMargin, kSecondShapeLayerTop, KSecondShapeLayerWidth, KSecondShapeLayerWidth) cornerRadius:KSecondShapeLayerRadius].CGPath;
       [self.layer addSublayer:bottomShapeLayer];
    bottomShapeLayer.hidden = YES;
    
    
       /// 橘黄色的layer
       CAShapeLayer *ovalShapeLayer = [CAShapeLayer layer];
       ovalShapeLayer.strokeColor = [UIColor whiteColor].CGColor;  // [UIColor colorWithRed:0.984 green:0.153 blue:0.039 alpha:1.000].CGColor;
       ovalShapeLayer.fillColor = [UIColor clearColor].CGColor;
       ovalShapeLayer.lineWidth = KSecondShapelayerLineWidth;
       ovalShapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(KSecondShapeLayerMargin, kSecondShapeLayerTop,KSecondShapeLayerWidth, KSecondShapeLayerWidth) cornerRadius:KSecondShapeLayerRadius].CGPath;
       [self.layer addSublayer:ovalShapeLayer];
//    ovalShapeLayer.masksToBounds = YES;
//    ovalShapeLayer.cornerRadius = 5.0;
       
       // 加入动画
       /// 起点动画
       CABasicAnimation * strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(-0.5); // -0.5
    strokeStartAnimation.toValue = @(1.5);  // 1.5

       /// 终点动画
       CABasicAnimation * strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
       strokeEndAnimation.fromValue = @(0.5);  // 0.5
       strokeEndAnimation.toValue = @(1.5);     // 1.5

       /// 组合动画
       CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
       animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
       animationGroup.duration = KSecondAnimationDurationTime;
       animationGroup.repeatCount = CGFLOAT_MAX;
       animationGroup.fillMode = kCAFillModeForwards;
       animationGroup.removedOnCompletion = NO;
       [ovalShapeLayer addAnimation:animationGroup forKey:nil];
       
}





@end

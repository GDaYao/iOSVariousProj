//
//  DrawBoardView.m
//  DrawGraph
//


#import "DrawBoardView.h"

@implementation DrawBoardView
{
    CGPoint _beginPoint;
    CGPoint _lastPoint;
    CGPoint _currentPoint;
}

#pragma mark - init && drawRect:
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // self.backgroundColor = [UIColor whiteColor];
        NSLog(@"log--initWithFrame");
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    NSLog(@"log--drawRect");
    
    [self drawWithContext];
}


#pragma mark - draw board
- (void)addOperationGestureRecognizer{
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    
    UIPanGestureRecognizer *panDraw = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDrawInContext:)];
    [self addGestureRecognizer:panDraw];
    
}

- (void)panDrawInContext:(UIPanGestureRecognizer *)panGesReco{
    if (panGesReco.state == UIGestureRecognizerStateBegan) {
        // 获得初始点位置
        _beginPoint = [panGesReco locationInView:self];
        _lastPoint = _beginPoint;
    }
    
    CGPoint offsetPoint = [panGesReco translationInView:self];
    _currentPoint = CGPointMake(offsetPoint.x+_beginPoint.x, offsetPoint.y+_beginPoint.y);
    
    NSLog(@"log--offsetPoint:%@", NSStringFromCGPoint(offsetPoint));
 
    [self setNeedsDisplay]; //调用 `drawRect:`
    
}

- (void)drawWithContext{
    
    if (_currentPoint.x == 0 && _currentPoint.y ==0) {
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
//    CGContextSaveGState(ctx);
//    [[UIColor blackColor] set];
//    CGContextFillRect(ctx, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
//    CGContextRestoreGState(ctx);
//

    CGContextSetLineWidth(ctx, 8.0);
    
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);

    CGContextMoveToPoint(ctx, _lastPoint.x, _lastPoint.y);
    CGContextAddLineToPoint(ctx, _currentPoint.x,_currentPoint.y);
    
    CGContextStrokePath(ctx); // 绘制空心路径
    
    // 位置重置
    _lastPoint = _currentPoint;
    
}







@end





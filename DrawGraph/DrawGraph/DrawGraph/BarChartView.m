//
//  BarChartView.m
//  DrawGraph
//

#import "BarChartView.h"



@implementation BarChartView

- (float)totalNum{
    if (!_totalNum) {
        for (int i=0; i<self.numsArr.count; i++ ) {
            _totalNum = _totalNum + [self.numsArr[i] intValue];
        }
    }
    return _totalNum;
}

- (NSArray *)numsArr{
    if (!_numsArr) {
        _numsArr = @[@"10",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"90"];
    }
    return _numsArr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */


- (void)drawRect:(CGRect)rect {
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    float margin = 10; //
    float width =  (self.bounds.size.width-40 - (self.numsArr.count-1)*margin ) /self.numsArr.count;    //每个柱状图宽度
    

    for (int i=0; i<self.numsArr.count; i++) {
        // 倒放柱状图
        //  CGRect chartRect = CGRectMake(20+i*(margin+width),  self.bounds.size.height-100, width, ([self.numsArr[i] intValue]/self.totalNum)*self.bounds.size.height );
        // 正常柱状图
        CGRect chartRect = CGRectMake(20+i*(margin+width),  ( 1 - ([self.numsArr[i] intValue]/self.totalNum) ) * (self.bounds.size.height-100), width, ([self.numsArr[i] intValue]/self.totalNum)*(self.bounds.size.height-100) );
        CGContextAddRect(ctx, chartRect);
        
        NSLog(@"log--%d--输出比例:%f，输出高度:%f",i, [self.numsArr[i] intValue]/self.totalNum, ([self.numsArr[i] intValue]/self.totalNum)*self.bounds.size.height);
        
        CGFloat randRed = arc4random_uniform(256)/255.0;
        CGFloat randGreen = arc4random_uniform(256)/255.0;
        CGFloat randBlue = arc4random_uniform(256)/255.0;
        UIColor *randomColor = [UIColor colorWithRed:randRed green:randGreen blue:randBlue alpha:1];
        CGContextSetFillColorWithColor(ctx, randomColor.CGColor);
        CGContextFillPath(ctx);
        
    }
    
}









@end





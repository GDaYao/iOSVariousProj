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
    
    // 可参考链接: https://blog.csdn.net/u012265444/article/details/52218716
    
    
    
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    float margin = 10;
    float width =  (self.bounds.size.width-40) / (self.numsArr.count-1)*margin; //每个条形图宽度
    

    for (int i=0; i<self.numsArr.count; i++) {
        
        CGContextAddRect(ctx, CGRectMake(20, self.bounds.size.width-100, width, ([self.numsArr[i] intValue]/self.totalNum)*self.bounds.size.height));
        
        
    }
    
}








@end

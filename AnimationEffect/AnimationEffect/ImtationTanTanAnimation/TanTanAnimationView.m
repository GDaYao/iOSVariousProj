//
//  TanTanAnimationView.m
//  AnimationEffect
//



#import "TanTanAnimationView.h"

@implementation TanTanAnimationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - init life
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}



#pragma mark - create Card
- (void)createCard{
    // 用于滑动的UIView
    self.slideView = [[UIView alloc]init];
    self.slideView.layer.masksToBounds = YES;
    self.slideView.layer.cornerRadius = 10.0f;
    self.slideView.clipsToBounds = YES; // 把加入的多余图片边角裁掉
    
    
    
    // 底部留存不动的view
    self.showSaveView = [[UIView alloc]init];
    self.showSaveView.layer.masksToBounds = YES;
    self.showSaveView.layer.cornerRadius = 10.0f;
    self.showSaveView.clipsToBounds = YES; // 把加入的多余图片边角裁掉
    
    
    
    // 统一布局设置frame
    [self addSubview:self.showSaveView];
    [self addSubview:self.slideView];
    self.showSaveView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.slideView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    
    UIPanGestureRecognizer *panV = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panSlideView:)];
    [self.slideView addGestureRecognizer:panV];
    
    
    
    
    [self createSubview:self.slideView];
    [self createSubview:self.showSaveView];
    
    // test
    self.slideView.layer.borderWidth = 1.0f;
    self.slideView.layer.borderColor = [UIColor redColor].CGColor;
    self.showSaveView.layer.borderWidth = 1.0f;
    self.showSaveView.layer.borderColor = [UIColor blueColor].CGColor;
    
    
}

#pragma mark - create subview
- (void)createSubview:(UIView *)subview{
    UIImageView *iv = [[UIImageView alloc]init];
    [subview addSubview:iv];
    iv.frame = CGRectMake(0, 0, subview.bounds.size.width, subview.bounds.size.height-50);
    iv.image = [UIImage imageNamed:@"test.png"];
    
    // 右上角和左上角分别留有icon位置
    
}


#pragma mark - UIPanGestureRecognizer
- (void)panSlideView:(UIPanGestureRecognizer *)pan{
    
    // 操作图形拖动
    CGPoint position = [pan translationInView:self.slideView];
    self.slideView.transform = CGAffineTransformTranslate(self.slideView.transform, position.x, position.y);
    [pan setTranslation:CGPointZero inView:self.slideView];
    
    // 底部视图 放大缩小抖动，并且在出现 + 抖动条件
    float centerX = CGRectGetMaxX(self.slideView.bounds)/2;
    float scale = (position.x+centerX)/centerX;
    NSLog(@"log--scale:%f",scale);
    //if (position.x > centerX) {
    self.showSaveView.transform = CGAffineTransformMakeScale(scale, scale);
    //self.showSaveView.transform = CGAffineTransformScale(self.showSaveView.transform, scale,scale);
    
    //
    
    
}






@end




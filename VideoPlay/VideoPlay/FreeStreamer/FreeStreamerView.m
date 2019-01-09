//
//  FreeStreamerView.m
//  VideoPlay
//


#import "FreeStreamerView.h"

#import "RotationView.h"

@interface FreeStreamerView () <UIScrollViewDelegate>


@property (nonatomic,strong)UIScrollView *scrollView;


// rotationView
@property (nonatomic,strong) RotationView *leftRotationView;
@property (nonatomic,strong) RotationView *centerRotationView;
@property (nonatomic,strong) RotationView *rightRotationView;

// needle
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) UIImageView *imageView3;

@end


@implementation FreeStreamerView

#pragma mark - initWithFrame
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self buildUI];
    }
    return self;
}


#pragma mark - build UI
- (void)buildUI{
    
    [self buildScrollView];
    [self buildScrollView];
    [self turnTable];
    
}

- (void)buildScrollView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, 0);
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    //设置当前显示的位置为中间
    [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
    [self addSubview:self.scrollView];
}
// 音频播放器的转盘 控件
- (void)turnTable{
    // 新建 `RotationView` --> 实现三个转盘转动的效果
    for (int i = 0; i < 3; i++) {
        
        float rotationWidth = 300;
        RotationView *rotatV = [[RotationView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-(rotationWidth + 20))/2 + i * self.bounds.size.width, self.bounds.size.height/2 - (rotationWidth + 20)/2, rotationWidth + 20, rotationWidth + 20)];
        rotatV.CDimageView.image = nil;
        rotatV.isPlay = NO;
        
        __weak typeof(self) weakSelf = self;
        rotatV.playBlock = ^(BOOL yes){
            weakSelf.isPlayer(yes);
            if (yes) {
                [weakSelf startWithAnimation];
            }
            else
            {
                [weakSelf pauseWithAnimation];
            }
        };
        
        [self.scrollView addSubview:rotatV];
        
        if (i == 0) {
            _leftRotationView = rotatV;
        }
        else if (i == 1)
        {
            _centerRotationView = rotatV;
        }
        else if (i == 2)
        {
            _rightRotationView = rotatV;
        }
    }
}
// 转盘放置的指针
- (void)buildNeedle{
    _imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2+100,20, 70, 70)];
    _imageView1.image = [UIImage imageNamed:@"needle_2"];
    [self addSubview:_imageView1];
    
    //中间的唱针
    _imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(_imageView1.frame.origin.x - 10, - 70, 264*0.5, 485*0.5)];
    _imageView2.image = [UIImage imageNamed:@"needle_1"];
    _imageView2.layer.anchorPoint = CGPointMake(1, 0.15);   //锚点重设会导致x,y坐标发生偏移
    [self addSubview:_imageView2];
    CGAffineTransform transform = CGAffineTransformMakeRotation(-0.15);
    _imageView2.transform = transform;
    
    _imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(_imageView1.frame.origin.x +5, 27, 60, 60)];
    _imageView3.image = [UIImage imageNamed:@"needle_3"];
    [self addSubview:_imageView3];
}







@end




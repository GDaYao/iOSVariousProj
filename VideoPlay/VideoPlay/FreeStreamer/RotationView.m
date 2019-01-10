//
//  RotationView.m
//  VideoPlay
//


#import "RotationView.h"


@interface RotationView ()

@property (strong, nonatomic) UIImageView *ro;
@property (strong, nonatomic) UIImage *onImage;
@property (strong, nonatomic) UIImage *offImage;

@end



@implementation RotationView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _rotateIV = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2 - 65, self.bounds.size.height/2 - 65, 130, 130)];
        [self addSubview:_rotateIV];
        
        _ro = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 300)];
        _ro.image = [UIImage imageNamed:@"rotateImg"];
        [self addSubview:_ro];
        
        CGPoint center = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
        
        _onImage = [UIImage imageNamed:@"play"];
        _offImage = [UIImage imageNamed:@"stopPlay"];
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(0,0,_onImage.size.width * 1.3, _onImage.size.height * 1.3);
        [self.btn setCenter:center];
        [self.btn setImage:_onImage forState:UIControlStateNormal];
        [self.btn addTarget:self action:@selector(playOrPause) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btn];
        
    }
    return self;
}

- (void)addAnimation
{
    //Rotation
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 18;
    rotationAnimation.repeatCount = FLT_MAX;
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO; //No Remove
    [self.layer addAnimation:rotationAnimation forKey:@"rotation"];
    
}

- (void)playOrPause
{
    _isPlay = !_isPlay;
    
    if (self.isPlay) {
        
        [self startRotation];
        [self.btn setImage:_onImage forState:UIControlStateNormal];
        
    }else{
        [self pauseRotation];
        [self.btn setImage:_offImage forState:UIControlStateNormal];
        
    }
    _playBlock(_isPlay);
    
}

- (void)setIsPlay:(BOOL)aIsPlay{
    
    _isPlay = aIsPlay;
    
    if (self.isPlay) {
        [self start];
        
    }else{
        [self stop];
        
    }
}

- (void)startRotation{
    self.layer.speed = 1.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval pausedTime = [self.layer timeOffset];
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
    
}


- (void)pauseRotation{
    [UIView animateWithDuration:1 animations:^{
        CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        self.layer.speed = 0.0;
        self.layer.timeOffset = pausedTime;
    }];
    
}

- (void)start
{
    [self addAnimation];
    [self startRotation];
    [self.btn setImage:_onImage forState:UIControlStateNormal];
}

- (void)stop
{
    self.layer.speed = 0;
    [self.layer removeAllAnimations];
    [self.btn setImage:_offImage forState:UIControlStateNormal];
}





@end

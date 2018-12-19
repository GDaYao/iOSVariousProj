//
//  ViewController.m
//  iOSRecognizer
//


#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,retain)UIImageView *imageView;
@property (nonatomic,assign)NSInteger index;//下标
@property (nonatomic,retain)NSMutableArray *images;//图片名    字数组

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createRecognizer];
    
}

- (void)createRecognizer{
    
    //布局imageView
    [self layoutImageView];
    
    // TODO: 手势
    //1.创建轻拍手势
    [self tapGestureRecognizer];
    //2.创建轻扫手势
    [self swipeGestureRecognizer];
    //3.创建长按手势
    [self longPressGestureRecognizer];
    //4.创建平移手势  -- 此处创建的平移手势会和轻扫冲突覆盖
    [self panGestureTecognizer];
    //5.创建捏合手势
    [self pinchGestureRecognizer];
    //6.创建旋转手势
    [self rotationGestureRecognizer];
    //7.创建边缘手势
    [self screenEdgePanGestureRecognizer];
    
    
}

#pragma mark -  布局ImageView

-(void)layoutImageView
{
    //创建imageView 对象
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(50, 50, 375-50, 667-50)];
    imageView.layer.borderColor = [UIColor redColor].CGColor;
    imageView.layer.borderWidth = 2.0f;
    imageView.backgroundColor =[UIColor purpleColor];
    imageView.image =[UIImage imageNamed:@"test0.png"];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    //打开用户交互
    self.imageView.userInteractionEnabled =YES;
    self.images =[NSMutableArray array];
    for (int i = 0; i<6; i++) {
        NSString *imageName;
        if(i<3){
            imageName  =[NSString stringWithFormat:@"test%d.png",i];
        }else{
            imageName =[NSString stringWithFormat:@"test%d.jpg",i];
        }
        [_images addObject:imageName];
    }
    // _index =1;
    
}


#pragma mark - 轻拍手势
-(void)tapGestureRecognizer
{
    //创建手势对象
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(tapAction:)];
    //配置属性
    //轻拍次数
    tap.numberOfTapsRequired =1;
    //轻拍手指个数
    tap.numberOfTouchesRequired =1;
    //讲手势添加到指定的视图上
    [_imageView addGestureRecognizer:tap];
}
-(void)tapAction:(UITapGestureRecognizer *)tap
{
    //图片切换
    NSLog(@"log--拍一下");
    _index ++;
    if (_index == 6) {
        _index = 0;
    }
    self.imageView.image =[UIImage imageNamed:_images[_index]];
    
}


#pragma mark - 轻扫手势
-(void)swipeGestureRecognizer
{
    UISwipeGestureRecognizer *swipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    //配置属性
    //一个轻扫手势  只能有两个方向(上和下) 或者 (左或右)
    //如果想支持上下左右轻扫  那么一个手势不能实现  需要创建两个手势
    swipe.direction =UISwipeGestureRecognizerDirectionLeft;
    [_imageView addGestureRecognizer:swipe];
   
    UISwipeGestureRecognizer *swipe2 =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeAction:)];
    swipe2.direction =UISwipeGestureRecognizerDirectionRight;
    [_imageView addGestureRecognizer:swipe2];
    
}
-(void)swipeAction:(UISwipeGestureRecognizer *)swipe
{
    
    if (swipe.direction ==UISwipeGestureRecognizerDirectionRight)       {
        NSLog(@"向右轻扫");
        _index --;
        if (_index < 0) {
            _index =5;
        }
        _imageView.image =[UIImage imageNamed:_images[_index]];
    }else if(swipe.direction == UISwipeGestureRecognizerDirectionLeft){
        NSLog(@"向左扫一下");
        _index ++;
        if (_index == 6) {
            _index=0;
        }
        _imageView.image =[UIImage imageNamed:_images[_index]];
    }
    
}
#pragma mark - 长按手势
-(void)longPressGestureRecognizer
{
    UILongPressGestureRecognizer *longPress =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    //最短长按时间
    longPress.minimumPressDuration =1;
    //允许移动最大距离
    longPress.allowableMovement =1;
    
    [_imageView addGestureRecognizer:longPress];
    
}
-(void)longPressAction:(UILongPressGestureRecognizer *)longPress
{
    //对于长安有开始和 结束状态
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSLog(@"长按开始");
        //将图片保存到相册
        UIImage *image =[UIImage imageNamed:_images[_index]];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        // 没有保存完成的回调
    }else if (longPress.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"长按结束");
    }
    
}

#pragma mark - 平移手势
-(void)panGestureTecognizer
{
    
    UIPanGestureRecognizer *pan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    
    [_imageView addGestureRecognizer:pan];
    
}
-(void)panAction:(UIPanGestureRecognizer *)pan
{
    //获取手势（在平移视图上）的位置
    CGPoint position =[pan translationInView:_imageView];
    
    //通过stransform 进行平移交换
    _imageView.transform = CGAffineTransformTranslate(_imageView.transform, position.x, position.y);
    //将增量置为零
    [pan setTranslation:CGPointZero inView:_imageView];
    
}

#pragma mark - 捏合手势
-(void)pinchGestureRecognizer{
    UIPinchGestureRecognizer *pinch =[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
    [_imageView addGestureRecognizer:pinch];
    
}
-(void)pinchAction:(UIPinchGestureRecognizer *)pinch
{
    //通过 transform(改变) 进行视图的视图的捏合
    _imageView.transform =CGAffineTransformScale(_imageView.transform, pinch.scale, pinch.scale);
    //设置比例 为 1
    pinch.scale = 1;
    
}
#pragma mark - 旋转手势
-(void)rotationGestureRecognizer
{
    
    UIRotationGestureRecognizer *rotation =[[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationAction:)];
    [_imageView addGestureRecognizer:rotation];
    
}
-(void)rotationAction:(UIRotationGestureRecognizer *)rote
{
    
    //通过transform 进行旋转变换
    _imageView.transform = CGAffineTransformRotate(_imageView.transform, rote.rotation);
    //将旋转角度 置为 0
    rote.rotation = 0;
    
}
#pragma mark - 边缘手势 -- 只能添加到 `self.view`上
-(void)screenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenPan = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(screenPanAction:)];
    screenPan.edges = UIRectEdgeRight; // 右滑显示
    [self.view addGestureRecognizer:screenPan];
}
-(void)screenPanAction:(UIScreenEdgePanGestureRecognizer *)screenPan
{
    NSLog(@"log--边缘:%ld",(long)screenPan.state);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}







@end



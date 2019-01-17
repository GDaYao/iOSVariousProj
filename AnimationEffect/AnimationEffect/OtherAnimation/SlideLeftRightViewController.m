//
//  SlideLeftRightViewController.m
//  AnimationEffect
//


#import "SlideLeftRightViewController.h"

#import "SMSwipeView.h"

@interface SlideLeftRightViewController () <SMSwipeDelegate>

@property (nonatomic,strong)SMSwipeView *swipe;

@property (nonatomic,strong) NSArray * colors;

@end

@implementation SlideLeftRightViewController


#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUIView];
    
}

#pragma mark - create UIView
- (void)createUIView{
    
    
    self.swipe = [[SMSwipeView alloc]initWithFrame:CGRectMake(10, 50, self.view.bounds.size.width-2*10, self.view.bounds.size.height-2*50)];
    self.swipe.delegate = self;
    [self.view addSubview:self.swipe];
    
    
    self.colors = @[[UIColor redColor],[UIColor yellowColor],[UIColor blueColor]];
    
}

#pragma mark - swipView delegate realization
- (UITableViewCell*)SMSwipeGetView:(SMSwipeView *)swipe withIndex:(int)index{
    static NSString * identify=@"testIndentify";
    UITableViewCell * cell=[self.swipe dequeueReusableUIViewWithIdentifier:identify];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }else{
        NSLog(@"%@",@"not nil");
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d",index];
    cell.backgroundColor = self.colors[index];
    cell.layer.cornerRadius = 10;
    return cell;
}

-(NSInteger)SMSwipeGetTotaleNum:(SMSwipeView *)swipe{
    return 3;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/





@end



//
//  ViewController.m
//  AnimationEffect
//


#import "ViewController.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,copy)NSArray *dataArr;
@property (nonatomic,copy)NSArray *vcArr;

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createTableView];
}


#pragma mark - lazy load
- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"仿探探卡片滑动效果",@"上下滑动折叠动画",@"左右滑动动画",@"圆弧动画"];
    }
    return _dataArr;
}
- (NSArray *)vcArr{
    if (!_vcArr) {
        _vcArr = @[@"ImtationTantanViewController",@"SlideUpDownViewController",@"SlideLeftRightViewController",@"CircleAnimationViewController"];
    }
    return _vcArr;
}



#pragma mark - create UI
- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:(UITableViewStylePlain)];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // 去除多余横线
    self.tableView.tableFooterView = [UIView new];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellId];
    }
    
    cell.textLabel.text =self.dataArr[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *vcStr = self.vcArr[indexPath.row];
    Class class = NSClassFromString(vcStr);
    UIViewController *vc = [[class alloc]init];
    if (@available(iOS 13.0,*)) {
        vc.modalPresentationStyle =  UIModalPresentationFullScreen;
    }
    [self presentViewController:vc animated:YES completion:nil];
    
}






@end




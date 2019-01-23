//
//  ViewController.m
//  CameraFunctionDevelop
//


#import "ViewController.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)NSArray *dataArr;
@property (nonatomic,copy)NSArray *vcArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
    
}


- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"普通相机调用",@"美颜相机"];
    }
    return _dataArr;
}
- (NSArray *)vcArr{
    if (!_vcArr) {
        _vcArr = @[@"NormalViewController",@"BeautyCameraViewController"];
    }
    return _vcArr;
}


- (void)createUI{
    UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height-50) style:UITableViewStylePlain];
    [self.view addSubview:tv];
    tv.delegate = self;
    tv.dataSource = self;
    tv.tableFooterView = [UIView new];
    
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.dataArr[indexPath.row]];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *vcStr = self.vcArr[indexPath.row];
    Class class = NSClassFromString(vcStr);
    UIViewController *vc = [[class alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}



@end

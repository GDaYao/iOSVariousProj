//
//  ViewController.m
//  PaymentRealization
//


#import "ViewController.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)NSArray *dataArr;
@property (nonatomic,copy)NSArray *vcArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
    
}

- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"Alipay",@"WeiChat"];
    }
    return _dataArr;
}
- (NSArray *)vcArr{
    if (!_vcArr) {
        _vcArr = @[@"AliPayViewController",@"WeChatPayViewController"];
    }
    return _vcArr;
}

- (void)configUI{
    UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    [self.view addSubview:tv];
    [tv setBackgroundColor:[UIColor whiteColor]];
    tv.delegate = self;
    tv.dataSource = self;
    tv.tableFooterView = [UITableView new];
    
    
}


#pragma mark - UITableView delegate/dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell.textLabel setText:self.dataArr[indexPath.row]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *vcStr = self.vcArr[indexPath.row];
    Class vcClass = NSClassFromString(vcStr);
    UIViewController *vc = [[vcClass alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}




@end



//
//  HomeViewController.m
//  KVCAndKVO
//


#import "HomeViewController.h"

// 在使用Runtime都不需要import导入
//#import "KVCViewController.h"
//#import "KVOViewController.h"


#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kNavAndStatusH self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height

@interface HomeViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy)NSArray *dataArray;

@property (nonatomic,copy)NSArray *vcArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configUI];
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"KVCViewController",@"KVOViewController"];
    }
    return _dataArray;
}

- (NSArray *)vcArray{
    if (!_vcArray) {
        _vcArray = @[@"KVCViewController",@"KVOViewController"];
    }
    return _vcArray;
}

- (void)configUI{
    
    UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavAndStatusH, kScreenW, kScreenH) style:UITableViewStylePlain]; // UITableViewStyleGrouped
    tv.backgroundColor = [UIColor whiteColor];
    tv.delegate = self;
    tv.dataSource = self;
    tv.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:tv];
    
}

#pragma mark - UITableView delegate/dateSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.detailTextLabel.text = @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *vcStr = self.vcArray[indexPath.row];
    Class currentClass = NSClassFromString(vcStr);
    UIViewController *vc = [[currentClass alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}






@end



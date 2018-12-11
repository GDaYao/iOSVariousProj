//
//  ViewController.m
//  VideoPlay


#import "ViewController.h"

#import "AVPlayerViewController.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kNavAndStatusH self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height


@interface ViewController () <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)NSArray *dataArray;

@property (nonatomic,copy)NSArray *vcArray;

@end

@implementation ViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"";
    
    //
    //AVPlayerViewController *AVPlayerVC = [[AVPlayerViewController alloc]init];
    
    
    [self configUI];
    
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"AVPlayer",@"StreamingKit"];
    }
    return _dataArray;
}

- (NSArray *)vcArray{
    if (!_vcArray) {
        _vcArray = @[@"AVPlayerViewController",@"AVPlayerViewController"];
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
    [self.navigationController pushViewController:vc animated:YES];
}





@end



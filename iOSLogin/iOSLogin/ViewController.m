//
//  ViewController.m
//  iOSLogin
//


#import "ViewController.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray *dataArr;
@property (nonatomic,strong)NSArray *vcArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUI];
    
}


- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"微信登录",@"QQ登录",@"微博登录",@"Apple 登录"];
    }
    return _dataArr;
}
- (NSArray *)vcArr{
    if (!_vcArr) {
        _vcArr = @[@"WechatViewController",@"QQViewController",@"WeiboViewController",@"AppleViewController"];
    }
    return _vcArr;
}

#pragma mark - create ui
- (void)createUI{
    UITableView *homeTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height) style:UITableViewStylePlain];
    [self.view addSubview:homeTV];
    homeTV.delegate = self;
    homeTV.dataSource = self;
    homeTV.tableFooterView = [UIView new];
   
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

#pragma mark - cell for row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellId = @"cellId";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    
    return cell;
    
}

#pragma mark - did select
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Class class = NSClassFromString(self.vcArr[indexPath.row]);
    UIViewController *vc = [[class alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
    
}





@end




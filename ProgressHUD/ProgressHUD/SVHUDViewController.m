////  SVHUDViewController.m
//  ProgressHUD
//
//  Created on 2019/8/1.
//  Copyright © 2019 Dayao. All rights reserved.
//

#import "SVHUDViewController.h"
#import "SVProgressHUD+SVHUD.h"

@interface SVHUDViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation SVHUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
}

- (NSArray *)titleArray {
    return @[@"直接展示加载",@"带文字延时展示",@"带文字加载展示",@"进度展示-可多次调用",@"带文字进度展示",@"加载完成动画",@"移除loading加载",@"延迟移除loading加载"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [SVProgressHUD showLoadingUseSVProgress];
            break;
        case 1:
            [SVProgressHUD svprogressHUDShowWithMsg:@"文字延时展示" minTime:1.0 maxTime:1.5];
        case 2:
            [SVProgressHUD showLoadingUseSVProgressWithStatus:@"带文字加载展示"];
        case 3:
            [SVProgressHUD showLoadingProgressUseSVProgressWithFloat:100];
        case 4:
            [SVProgressHUD showLoadingProgressUseSVProgressWithFloat:100 status:@"进度展示"];
        case 5:
            [SVProgressHUD showCompletionInSVProgresssWithHint:@"加载完成动画"];
        case 6:
            [SVProgressHUD hiddenLoadingUseSVProgress];
        case 7:
            [SVProgressHUD hiddenLoadingUseSVProgressWithDelay:3.0];
            
        default:
            break;
    }
        [self performSelector:@selector(hide) withObject:nil afterDelay:3.0];
}

- (void)hide {
    [SVProgressHUD hiddenLoadingUseSVProgress];
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

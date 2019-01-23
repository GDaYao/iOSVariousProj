//
//  MessageViewController.m
//  ContactCallMessage
//


#import "MessageViewController.h"

// 导入发送信息框架库使用 + 并遵守协议
#import <MessageUI/MessageUI.h>

@interface MessageViewController () <MFMessageComposeViewControllerDelegate>

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self createUI];
    
    
}

- (void)createUI{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(50, 50, 200, 50);
    [btn setTitle:@"发信息"  forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 2.0f;
    [btn addTarget:self action:@selector(triggerSendMessage) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 发信息方法
- (void)triggerSendMessage{
    MFMessageComposeViewController *vc = [[MFMessageComposeViewController alloc] init];
    // 设置短信内容
    vc.body = @"设置短信内容";
    
    // 设置收件人列表
    vc.recipients = @[@"10086"];  // 号码数组
    // 设置代理
    vc.messageComposeDelegate = self;
    // 显示控制器
    [self presentViewController:vc animated:YES completion:nil];
}
-  (void)messageComposeViewController:(MFMessageComposeViewController*)controller didFinishWithResult:(MessageComposeResult)result
{
    // 关闭短信界面
    [controller dismissViewControllerAnimated:YES completion:nil];
    if(result == MessageComposeResultCancelled) {
        NSLog(@"取消发送");
    } else if(result == MessageComposeResultSent) {
        NSLog(@"已经发出");
    } else {
        NSLog(@"发送失败");
    }
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



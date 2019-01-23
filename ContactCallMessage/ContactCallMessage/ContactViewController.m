//
//  ContactViewController.m
//  ContactCallMessage
//





#import "ContactViewController.h"

// 导入使用通讯录框架
#import <Contacts/Contacts.h>

@interface ContactViewController () <UITableViewDelegate , UITableViewDataSource>

@property (nonatomic,copy)NSArray *contactArr;

@property (nonatomic,strong)UITableView *tv;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self requestContactsAuthor];
    
    [self createUI];
    
}


#pragma mark - 使用通讯录的方法
- (void)requestContactsAuthor{
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc]init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (error) {
                NSLog(@"log--通讯录授权失败,%@",error);
            }else{
                NSLog(@"log--通讯录授权成功！");
                
                [self getContacts];
            }
            
        }];
    }else if(status == CNAuthorizationStatusRestricted){
        NSLog(@"log--用户拒绝");
        [self showAlertViewAboutNotAuthorAccessContact];
    }else if(status == CNAuthorizationStatusDenied){
        NSLog(@"log--用户拒绝");
        [self showAlertViewAboutNotAuthorAccessContact];
    }else if(status == CNAuthorizationStatusAuthorized){
        NSLog(@"log--用户已经授权");
        
        [self getContacts];
    }
}

- (void)getContacts{
    NSMutableArray *mutableArr = [NSMutableArray array];
    
    /* ------------------------------------------------------- */
    
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSLog(@"-------------------------------------------------------");
        
        NSString *givenName = contact.givenName;
        NSString *familyName = contact.familyName;
        NSLog(@"givenName=%@, familyName=%@", givenName, familyName);
        //拼接姓名
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
        
        NSArray *phoneNumbers = contact.phoneNumbers;
        
        //        CNPhoneNumber  * cnphoneNumber = contact.phoneNumbers[0];
        
        //        NSString * phoneNumber = cnphoneNumber.stringValue;
        
        for (CNLabeledValue *labelValue in phoneNumbers) {
            //遍历一个人名下的多个电话号码
            NSString *label = labelValue.label;
            //   NSString *    phoneNumber = labelValue.value;
            CNPhoneNumber *phoneNumber = labelValue.value;
            
            NSString * string = phoneNumber.stringValue ;
            
            //去掉电话中的特殊字符
            string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSLog(@"姓名=%@, 电话号码是=%@", nameStr, string);
            
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:nameStr,@"nameStr",string,@"numStr", nil];
            [mutableArr addObject:dic];
        }
        
        // 停止循环，相当于break；
        //    *stop = YES;
        
    }];
    
    /* ------------------------------------------------------- */
    self.contactArr = [NSArray arrayWithArray:[mutableArr copy] ];
    
    // 在主线程执行刷新UI操作
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.tv reloadData];
        
    });
    
}



//提示没有通讯录权限
- (void)showAlertViewAboutNotAuthorAccessContact{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"请授权通讯录权限"
                                          message:@"请在iPhone的\"设置-隐私-通讯录\"选项中,允许花解解访问你的通讯录"
                                          preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - show  UI contact
- (void)createUI{
    
    UITableView *tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height-50) style:UITableViewStylePlain];
    [self.view addSubview:tv];
    tv.delegate = self;
    tv.dataSource = self;
    tv.tableFooterView = [UIView new];
    self.tv = tv;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contactArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    NSDictionary *dic = self.contactArr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",dic[@"nameStr"] ];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",dic[@"numStr"] ];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}




@end




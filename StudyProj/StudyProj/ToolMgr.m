//
//  ToolMgr.m
//  StudyProj
//

#import "ToolMgr.h"

@implementation ToolMgr






#pragma mark - get file size
+ (long long)getFileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}




#pragma mark - base64位加密



#pragma mark - 注释代码
// `UINavigationController` 跳转至指定控制器
//    CompanyDetailViewController *companyVC = [[CompanyDetailViewController alloc]init];
//    UIViewController *target = nil;
//    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
//        if ([controller isKindOfClass:[companyVC class]]) { //这里判断是否为你想要跳转的页面
//            target = controller;
//        }
//    }
//    if (target) {
//        [self.navigationController popToViewController:target animated:YES]; //跳转
//    }



@end






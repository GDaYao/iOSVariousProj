//
//  ViewController.m
//  StudyProj

#import "ViewController.h"

#import "StudyRuntime.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - life vie cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self testMethodRuntime];
    
    
    
}



#pragma mark - test method
- (void)testMethodRuntime{
    NSArray *tmpArray1 = [self getArrayWithType:@"SarlaryRange"];
    NSArray *tmpArray2 = [self getArrayWithType:@"WorkAge"];
    NSLog(@"log-tmpArray1:%@,%p",tmpArray1,tmpArray1);
    NSLog(@"log-tmpArray2:%@,%p",tmpArray2,tmpArray2);
}



- (NSMutableArray *)getArrayWithType:(NSString *)type {
    NSString *action = [NSString stringWithFormat:@"update%@Action", type];
    NSArray *tmpArray = [[NSArray alloc] init];
    SEL sel = NSSelectorFromString(action);
    if ([self respondsToSelector:sel]) {
        //[self methodForSelector:sel];
        tmpArray = [self performSelector:sel];
    }
    return tmpArray;
}

- (NSArray *)updateSarlaryRangeAction {
    NSArray *array = @[@"不限",@"3k~5K",@"5k~10k",@"10k~20k",@"20k~30k"];
    return array;
}
- (NSArray *)updateWorkAgeAction {
    NSArray *array = @[ @"不限", @"1年以下", @"1~3年", @"3~5年", @"5~10年" ];
    return array;
}



@end



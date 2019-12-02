//
//  NSArray+SafetyArray.m

#import "NSArray+SafetyArray.h"
#include "NSObject+Until.h"



@implementation NSArray (SafetyArray)
#pragma mark - 第一种方式:使用runTime替换系统方法,防止数组越界或空值引起的crash
+(void)load {
    // 无论如何都要保证方法只交换一次。
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            //交换NSArray中的objectAtIndex方法
            [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(runtimeSafeObjectAtIndex:) error:nil];
            //交换NSArray中的objectAtIndexedSubscript方法
            [objc_getClass("__NSArrayI") swizzleMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(runtimeSafeObjectAtIndexedSubscript:) error:nil];
        };
    });
}

- (id)runtimeSafeObjectAtIndex:(NSUInteger)index {
    
    NSLog(@"log-NSArray+SafetyArray-runtimeSafeObjectAtIndex");
    
    if (index < self.count) {
        return [self runtimeSafeObjectAtIndex:index];
    }
    return nil;//越界返回为nil
}

- (id)runtimeSafeObjectAtIndexedSubscript:(NSUInteger)idx{
    
    NSLog(@"log-NSArray+SafetyArray-runtimeSafeObjectAtIndexedSubscript");
    
    if (idx < self.count) {
        return [self runtimeSafeObjectAtIndexedSubscript:idx];
    }else{
        NSLog(@"log-NSArray+SafetyArray-数组越界：%ld   %ld", idx, self.count);
        return nil;
    }
}




#pragma mark - 数组分类添加方法
/**
 *  防止数组越界
 */
- (id)safetyArrayObjectAtIndexVerify:(NSUInteger)index{
    if (index < self.count) {
        return [self objectAtIndex:index];
    }else{
        return nil;
    }
}
/**
 *  防止数组越界
 */
- (id)safetyArrayObjectAtIndexedSubscriptVerify:(NSUInteger)idx{
    if (idx < self.count) {
        return [self objectAtIndexedSubscript:idx];
    }else{
        return nil;
    }
}












@end



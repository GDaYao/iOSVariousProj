////  NSMutableArray+SafetyMutableArray.m
//  CreativePapers


#import "NSMutableArray+SafetyMutableArray.h"
#import "NSObject+Until.h"


@implementation NSMutableArray (SafetyMutableArray)

/*
+(void)load{
    [super load];
    //无论怎样 都要保证方法只交换一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //交换NSMutableArray中的方法
        [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(runtimeSafeObjectAtIndex:) error:nil];
        //交换NSMutableArray中的方法
        [objc_getClass("__NSArrayM") swizzleMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(runtimeSafeObjectAtIndexedSubscript:) error:nil];
    });
}

- (id)runtimeSafeObjectAtIndex:(NSUInteger)index{
    
    NSLog(@"log-NSMutableArray+SafetyArrayruntimeSafeObjectAtIndex:%ld",index);
    
    if (index < self.count) {
        return [self runtimeSafeObjectAtIndex:index];
    }else{
        
        NSLog(@"log-NSMutableArray+SafetyMutableArray-数组越界：%ld   %ld   %@", index, self.count, [self class]);
        return nil;
    }
}
- (id)runtimeSafeObjectAtIndexedSubscript:(NSUInteger)index{
    
    NSLog(@"log-NSMutableArray+SafetyMutableArray-runtimeSafeObjectAtIndexedSubscript:%ld",index);
    
    if (index < self.count) {

        return [self runtimeSafeObjectAtIndexedSubscript:index];
    }else{
        NSLog(@"log-NSMutableArray+SafetyMutableArray-数组越界：%ld   %ld   %@", index, self.count, [self class]);
        return nil;
    }
}
*/


#pragma mark - 可变数组防越界分类方法
/**
 *  数组中插入数据
 */
- (void)safetyMutableArrInsertObjectVerify:(id)object atIndex:(NSInteger)index{
    if (index < self.count && object) {
        [self insertObject:object atIndex:index];
    }
}
/**
 *  数组中添加数据
 */
- (void)safetyMutableArrAddObjectVerify:(id)object{
    if (object) {
        [self addObject:object];
    }
}



@end

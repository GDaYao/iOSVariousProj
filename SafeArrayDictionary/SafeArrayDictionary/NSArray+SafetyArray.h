//
//  NSArray+SafetyArray.h


/**
 *  数组的扩展,可防止数组越界及添加的对象为nil引起的crash
 *
 *  由两种实现方式:1.runtime机制;2.自定义方法
 *  注：不可直接在pch中添加，否则会替换系统方法
 */

#import <Foundation/Foundation.h>


@interface NSArray (SafetyArray)



#pragma mark - NSArray数组分类添加方法
/**
 为数组分类添加的方法  可以在应用中直接调用 可以防止数组越界导致的crash

 @param index 传入的取值下标
 @return id类型的数据
 */
- (id)arrayObjectAtIndexVerify:(NSUInteger)index;
- (id)arrayObjectAtIndexedSubscriptVerify:(NSUInteger)idx;





@end




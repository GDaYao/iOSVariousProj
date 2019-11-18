////  NSMutableArray+SafetyMutableArray.h


/** func: 可变数组安全数组元素访问
 * 
 * 注:不可再pch文件中直接添加，此会替换系统使用可变数组方法，导致循环。
 *
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (SafetyMutableArray)


#pragma mark - NSMubaleArray可变数组分类添加方法
/**
 数组中插入数据

 @param object 数据
 @param index 下标
 */
- (void)mutableArrInsertObjectVerify:(id)object atIndex:(NSInteger)index;
/**
 数组中添加数据

 @param object 数据
 */
- (void)mutableArrAddObjectVerify:(id)object;


@end

NS_ASSUME_NONNULL_END

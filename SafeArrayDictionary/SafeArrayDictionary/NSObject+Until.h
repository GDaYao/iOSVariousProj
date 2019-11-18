//
//  NSObject+Until.h

/**
 *
 *  基于NSObject的扩展,用于修改替换系统方法
 */

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (Until)

/*! @method swizzleMethod:withMethod:error:
 @abstract 对系统方法进行替换
 @param oldSelector 想要替换的方法
 @param newSelector 实际替换为的方法
 @param error 替换过程中出现的错误，如果没有错误为nil
 */
+ (BOOL)swizzleMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector error:(NSError **)error;
@end

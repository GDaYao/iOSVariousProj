////  NSDictionary+Safety.h
//  SafeArrayDictionary
//
//  Created on 2019/11/18.
//  Copyright © 2019 dayao. All rights reserved.
//

/** func: 字典防越界处理
 *
 */

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Safety)


// TODO:判断某个key值是否存在
- (BOOL)safetyIsHaveKey:(NSString*)key;

// TODO:NSDictionary-取key值
- (id)safeObjectForKey:(NSString*)key;

// TODO:NSDictionary-深拷贝
- (NSMutableDictionary *)mutableDeepCopy;

@end

NS_ASSUME_NONNULL_END

////  NSDictionary+Safety.m
//  SafeArrayDictionary
//
//  Created on 2019/11/18.
//  Copyright © 2019 dayao. All rights reserved.
//

#import "NSDictionary+Safety.h"


@implementation NSDictionary (Safety)


#pragma mark - NSDictionary 扩展方法

// TODO:判断某个key值是否存在
- (BOOL)safetyIsHaveKey:(NSString*)key {
    NSDictionary *dict = [self copy];
    
    if ([self isBlankString:key]) {
        return NO;
    }
    if([[dict allKeys] containsObject:key]) {
        return YES;
    }else{
        return NO;
    }
}
// TODO:NSDictionary-取key值
- (id)safeObjectForKey:(NSString*)key {
    id object = [self objectForKey:key];
    
    if ([object isKindOfClass:[NSNull class]]) {
        
        object = nil;
    }
    return object;
}
// 深拷贝
- (NSMutableDictionary *)mutableDeepCopy{
    NSMutableDictionary *copyDict = [[NSMutableDictionary alloc]initWithCapacity:self.count];
    
    for (id key in self.allKeys) {
        id oneCopy = nil;
        
        id oneValue = [self valueForKey:key];
        
        if ([oneValue respondsToSelector:@selector(mutableDeepCopy)]) {
            oneCopy = [oneValue mutableDeepCopy];
        }else if ([oneValue respondsToSelector:@selector(copy)]){
            oneCopy = [oneValue copy];
        }
        [copyDict setValue:oneCopy forKey:key];
    }
    return copyDict;
}


#pragma mark - 判断当前字符串是否为空 -- 空-NO,非空-YES
- (BOOL)isBlankString:(NSString *)string
{
    if (string == nil || string == NULL)
    {
        return YES;
    }
    if ([string isEqualToString:@""]       ||
        [string isEqualToString:@"null"]   ||
        [string isEqualToString:@"<NULL>"] ||
        [string isEqualToString:@"<null>"] ||
        [string isEqualToString:@"NULL"]   ||
        [string isEqualToString:@"nil"]    ||
        [string isEqualToString:@"(null)"] )
    {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}




@end

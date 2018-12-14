//
//  ObjcRuntimeMgr.m


#import "ObjcRuntimeMgr.h"

@implementation ObjcRuntimeMgr


#pragma mark - objc

// selector whether responds method
+ (BOOL)whetherRespondsMethodWithSEL:(id)respondsSEL methodSEL:(SEL)methodSEL{
    BOOL whetherResponds = [respondsSEL respondsToSelector:methodSEL]; // methodSEL <==> @selector(whetherRespondsMethodWithSEL:methodSEL:)
    return whetherResponds;
}


// perform selector to call method without parameter
+ (void)callMethodToPerformSelector:(SEL)methodSEL withSelfSEL:(id)respondsSEL{
    if ([respondsSEL respondsToSelector:methodSEL]) {
        // It has warning.
        //[respondsSEL performSelector:methodSEL];
        
        // So you can this. ==> 通过类似C函数指针的方法通过地址调用这个方法
        //  方法名 -> 方法id -> 方法内存地址 -> 根据方法地址调用方法
        IMP imp = [self methodForSelector:methodSEL];
        void(* func)(id,SEL) = (typeof(func))imp; // (void *)imp ==> 告诉编译器不用报类型强转的warning
        func(respondsSEL,methodSEL);
    }
}
//+ (void)withParaCallMethodToPerformSelector:(SEL)methodSEL withSelfSEL:(id)respondsSEL{
//    SEL testSelector[] = {
//        @selector(testOne),
//        @selector(testTwo),
//        @selector(testThree),
//    };
//    SEL selector = NSSelectorFromString(@"testOne:testMethod:");
//    IMP imp = [respondsSEL methodForSelector:methodSEL];
//    BOOL (*func)(id, SEL, NSString *, NSString *) = (void *)imp;
//    BOOL result = respondsSEL ?
//    func(respondsSEL, methodSEL, paraStr, paraStrTwo) : NO;
//}






@end



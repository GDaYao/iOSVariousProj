//
//  KVOViewController.m
//  KVCAndKVO


/** KVO
 - (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
 - (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
 -  -   -   -   -
 observer:观察者，也就是KVO通知的订阅者。订阅者必须实现 `observeValueForKeyPath:ofObject:change:context:` 方法实现监听
 keyPath：描述将要观察的属性，相对于被观察者。
 options：KVO的一些属性配置；有四个选项。
 context: 上下文，这个会传递到订阅者的函数中，用来区分消息，一般应当是不同的。
 
 -  -   -   -   - options选项:
 NSKeyValueObservingOptionNew   :change字典包括改变后的值
 NSKeyValueObservingOptionOld   :change字典包括改变前的值
 NSKeyValueObservingOptionInitial :注册后立刻触发KVO通知
 NSKeyValueObservingOptionPrior     :值改变前是否也要通知（这个key决定了是否在改变前改变后通知两次）
 -  -   -   -   - 处理变更通知
 - (void)observeValueForKeyPath:(NSString *)keyPath
 ofObject:(id)object
 change:(NSDictionary *)change
 context:(void *)context
 
 */


/** 手动KVO
 *  这两个方法在手动实现键值观察时会用到
 - (void)willChangeValueForKey:(NSString *)key;
 - (void)didChangeValueForKey:(NSString *)key;
 -  -   - 可以和这个方法混用
 + (BOOL) automaticallyNotifiesObserversForKey:(NSString *)key {
     if ([key isEqualToString:@"xxx"]) {
     return NO;
     }
 
     return [super automaticallyNotifiesObserversForKey:key];
 }
 */

/** 键值观察依赖键
 *
 */




#import "KVOViewController.h"

@interface KVOViewController ()

@end

@implementation KVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    
    
    
}




@end

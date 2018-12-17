//
//  KVOViewController.h
//  KVCAndKVO

// func: KVO

/** KVO
 * KVO 即 Key-Value Observing -- 成键值观察。它是一种观察者模式的衍生。其基本思想是，对目标对象的某属性添加观察，当该属性发生变化时，通过触发观察者对象实现的KVO接口方法，来自动的通知观察者。
 * KVO 可以通过监听Key，来获得Value的变化，用来在对象之间监听状态变化。KVO的定义都是对NSObject的扩展来实现的，OC中的`NSKeyValueCoding`类别，所以所有继承了NSObject类型都可使用KVO。
 */




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KVOViewController : UIViewController

@end

NS_ASSUME_NONNULL_END

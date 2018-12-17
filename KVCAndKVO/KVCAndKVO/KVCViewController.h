//
//  KVCViewController.h
//  KVCAndKVO
//
// func: KVC use


/** KVC
 *  KVC（Key-value coding）键值编码，就是指iOS的开发中，可以允许开发者通过Key名直接访问对象的属性，或者给对象的属性赋值。而不需要调用明确的存取方法。
 *  这样就可以在运行时动态地访问和修改对象的属性。而不是在编译时确定。
 */

/**
 *  KVC的定义都是对NSObject的扩展来实现的，Objective-C中有个显式的 `NSKeyValueCoding` 类别名，所以对于所有继承了NSObject的类型，都能使用KVC(一些纯Swift类和结构体是不支持KVC的，因为没有继承NSObject)
 */

/**
 *  KVC 使用场景
 KVC动态的取值、设值
 用KVC来访问和修改私有变量(有些类里面的私有变量，OC是不可以直接访问，但是可以通过KVC实现)
 使用KVC实现Model和字典的相互转换
 修改某些控件的内部属性
 通过KVC实现对NSArray和NSSet集合的操作
 
 -  -   -
 KVC设值
 KVC取值
 KVC使用keyPath
 KVC处理异常
 KVC处理数值和结构体类型属性
 KVC键值验证（Key-Value Validation）
 KVC处理集合
 KVC处理字典
 KVCModel和字典
 -  -   -  -  -
 // key-value
 // KVC机制会搜索该类里面有没有名为<key>的成员变量，无论该变量是在类接口处定义，还是在类实现处定义，也无论用了什么样的访问修饰符，只在存在以<key>命名的变量，KVC都可以对该成员变量赋值。
 // 如果没有找到Set<Key>方法的话，会按照_key，_iskey，key，iskey的顺序搜索成员并进行赋值操作
 // get<Key>,<key>,is<Key>
 
 // keyPath
 在开发过程中，一个类的成员变量有可能是自定义类或其他的复杂数据类型，你可以先用KVC获取该属性，然后再次用KVC来获取这个自定义类的属性，
 但这样是比较繁琐的，对此，KVC提供了一个解决方案，那就是键路径keyPath。顾名思义，就是按照路径寻找key
 
 */







#import <UIKit/UIKit.h>

@interface KVCViewController : UIViewController




@end


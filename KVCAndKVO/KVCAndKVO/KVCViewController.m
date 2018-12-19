//
//  KVCViewController.m
//  KVCAndKVO
//


/**
 * KVC -- 重要方法
 
 - (void)setValue:(nullable id)value forKey:(NSString *)key;          // 通过Key来设值 -- key变量名，首字母大小写要和类属性相同，否则会报 `setValue:foUnderfinedKey:`
 - (nullable id)valueForKey:(NSString *)key;                          //直接通过Key来取值

 
 - (void)setValue:(nullable id)value forKeyPath:(NSString *)keyPath;  // 通过KeyPath来设值 -- 在使用keyPath路径寻找。如另一个对象的某个属性，需要先 `setValue`这个对象属性，以便找到设置其值。
 - (nullable id)valueForKeyPath:(NSString *)keyPath;                  //通过KeyPath来取值
 */

/**
 * NSValueCoding    其它方法
 
 //默认返回YES，表示如果没有找到Set<Key>方法的话，会按照_key，_iskey，key，iskey的顺序搜索成员，设置成NO就不这样搜索
 + (BOOL)accessInstanceVariablesDirectly;
 
 //KVC提供属性值正确性验证的API，它可以用来检查set的值是否正确、为不正确的值做一个替换值或者拒绝设置新值并返回错误原因。
 - (BOOL)validateValue:(inout id __nullable * __nonnull)ioValue forKey:(NSString *)inKey error:(out NSError **)outError;
 
 //这是集合操作的API，里面还有一系列这样的API，如果属性是一个NSMutableArray，那么可以用这个方法来返回。
 - (NSMutableArray *)mutableArrayValueForKey:(NSString *)key;
 
 //如果Key不存在，且没有KVC无法搜索到任何和Key有关的字段或者属性，则会调用这个方法，默认是抛出异常。
 - (nullable id)valueForUndefinedKey:(NSString *)key;
 
 //和上一个方法一样，但这个方法是设值。
 - (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key;
 
 //如果你在SetValue方法时面给Value传nil，则会调用这个方法
 - (void)setNilValueForKey:(NSString *)key;
 
 //输入一组key,返回该组key对应的Value，再转成字典返回，用于将Model转到字典。
 - (NSDictionary<NSString *, id> *)dictionaryWithValuesForKeys:(NSArray<NSString *> *)keys;

 */

/**
 *  iOS对一些容器类比如NSArray或者NSSet等，KVC有着特殊的实现
 
 // 有序集合
 -countOf<Key>//必须实现，对应于NSArray的基本方法count:2  -objectIn<Key>AtIndex:
 
 -<key>AtIndexes://这两个必须实现一个，对应于 NSArray 的方法 objectAtIndex: 和 objectsAtIndexes:
 
 -get<Key>:range://不是必须实现的，但实现后可以提高性能，其对应于 NSArray 方法 getObjects:range:
 
 -insertObject:in<Key>AtIndex:
 
 -insert<Key>:atIndexes://两个必须实现一个，类似于 NSMutableArray 的方法 insertObject:atIndex: 和 insertObjects:atIndexes:
 
 -removeObjectFrom<Key>AtIndex:
 
 -remove<Key>AtIndexes://两个必须实现一个，类似于 NSMutableArray 的方法 removeObjectAtIndex: 和 removeObjectsAtIndexes:
 
 -replaceObjectIn<Key>AtIndex:withObject:
 
 -replace<Key>AtIndexes:with<Key>://可选的，如果在此类操作上有性能问题，就需要考虑实现之
 
 
// 无序集合
 -countOf<Key>//必须实现，对应于NSArray的基本方法count:
 
 -objectIn<Key>AtIndex:
 
 -<key>AtIndexes://这两个必须实现一个，对应于 NSArray 的方法 objectAtIndex: 和 objectsAtIndexes:
 
 -get<Key>:range://不是必须实现的，但实现后可以提高性能，其对应于 NSArray 方法 getObjects:range:
 
 -insertObject:in<Key>AtIndex:
 
 -insert<Key>:atIndexes://两个必须实现一个，类似于 NSMutableArray 的方法 insertObject:atIndex: 和 insertObjects:atIndexes:
 
 -removeObjectFrom<Key>AtIndex:
 
 -remove<Key>AtIndexes://两个必须实现一个，类似于 NSMutableArray 的方法 removeObjectAtIndex: 和 removeObjectsAtIndexes:
 
 -replaceObjectIn<Key>AtIndex:withObject:
 
 -replace<Key>AtIndexes:with<Key>://这两个都是可选的，如果在此类操作上有性能问题，就需要考虑实现之
 
 */




#import "KVCViewController.h"


@interface TestViewController : UIViewController
@property (nonatomic,copy)NSString *testVCStr;

@property (nonatomic,assign)int age;

@end

@implementation TestViewController

@end


#pragma mark -
@interface Model:NSObject

@property (nonatomic,copy) NSString *reportCreateTime;
@property (nonatomic,copy) NSString *reportPath;
@property (nonatomic,copy) NSString *reportId;


@end

@implementation Model

@end


#pragma mark -
@interface KVCViewController ()


@property (nonatomic,copy) NSString *kvcStr;
@property (nonatomic,assign)int age;

@end

@implementation KVCViewController
{
    NSString *_kvcStrTwo;
    
    
    // 用于keyPath
    TestViewController *_testVC;
}

#pragma mark - view did load
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self KVCValueMethod];
    
//    [self kvcPathMethod];
    
//    [self KVCValidationMethod];
    
//    [self KVCArrayMethod];
    
    [self KVCDictionaryMethod];
    
}


#pragma mark - KVC value
- (void)KVCValueMethod{
    
    // KVC -- key-value
    [self setValue:@"kvcStr" forKey:@"kvcStr"];
    [self setValue:@"kvcStrTwo" forKey:@"kvcStrTwo"]; 
    
    NSString *getKVCStr = [self valueForKey:@"kvcStr"];
    NSString *getKVCStrTwo = [self valueForKey:@"kvcStrTwo"];
    
    NSLog(@"log--kvcStr:%@",getKVCStr);
    NSLog(@"log--kvcStrTwo:%@",getKVCStrTwo);
    NSLog(@"log--property:%@,%@",self.kvcStr,_kvcStrTwo); // KVC直接给对象赋值
}



#pragma mark - KVC keyPath
- (void)kvcPathMethod{
    TestViewController *testVC = [[TestViewController alloc]init];
    
    // 先 setValue,在keyPath
    [self setValue:testVC forKeyPath:@"_testVC"];
    [self setValue:@"testVCStr" forKeyPath:@"testVC.testVCStr"];
    
    NSLog(@"log--testVC-value:%@",[self valueForKey:@"testVC"]);
    NSLog(@"log--testVC-keyPath:%@",[self valueForKeyPath:@"testVC.testVCStr"]);
    
    
}

#pragma mark rewrite kvc subclass method.
+ (BOOL)accessInstanceVariablesDirectly {
    return YES; // 设为YES，key会按照_key，_iskey，key，iskey的顺序搜索成员并进行赋值操作；否则为NO即为key对应值。
}

#pragma mark - 异常处理
- (void)setNilValueForKey:(NSString *)key{
    NSLog(@"log--不能将%@设置成nil",key);
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"setValue出现异常，该key不存在%@", key);
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"valueForKey出现异常，该key不存在%@",key);
    return nil;
}


#pragma mark - KVC 处理数值和结构体类型
/**
 *  数值类型转换
 + (NSNumber*)numberWithChar:(char)value;
 + (NSNumber*)numberWithUnsignedChar:(unsignedchar)value;
 + (NSNumber*)numberWithShort:(short)value;
 + (NSNumber*)numberWithUnsignedShort:(unsignedshort)value;
 + (NSNumber*)numberWithInt:(int)value;
 + (NSNumber*)numberWithUnsignedInt:(unsignedint)value;
 + (NSNumber*)numberWithLong:(long)value;
 + (NSNumber*)numberWithUnsignedLong:(unsignedlong)value;
 + (NSNumber*)numberWithLongLong:(longlong)value;
 + (NSNumber*)numberWithUnsignedLongLong:(unsignedlonglong)value;
 + (NSNumber*)numberWithFloat:(float)value;
 + (NSNumber*)numberWithDouble:(double)value;
 + (NSNumber*)numberWithBool:(BOOL)value;
 + (NSNumber*)numberWithInteger:(NSInteger)valueNS_AVAILABLE(10_5,2_0);
 + (NSNumber*)numberWithUnsignedInteger:(NSUInteger)valueNS_AVAILABLE(10_5,2_0);
 */

/**
 *  NSValue类型转换 <== 结构体类型数据
 + (NSValue*)valueWithCGPoint:(CGPoint)point;
 + (NSValue*)valueWithCGSize:(CGSize)size;
 + (NSValue*)valueWithCGRect:(CGRect)rect;
 + (NSValue*)valueWithCGAffineTransform:(CGAffineTransform)transform;
 + (NSValue*)valueWithUIEdgeInsets:(UIEdgeInsets)insets;
 + (NSValue*)valueWithUIOffset:(UIOffset)insetsNS_AVAILABLE_IOS(5_0);
 */
- (void)KVCHandleNSNumberAndStruct{}


#pragma mark - KVC键值验证（Key-Value Validation）
- (BOOL)validateValue:(inout id __nullable * __nonnull)ioValue forKey:(NSString *)inKey error:(out NSError **)outError;{
    NSNumber *age = *ioValue;
    if (age.integerValue != 20) {
        return NO;
    }
    
    return YES;
}

- (void)KVCValidationMethod{
    
    NSNumber *age = @20;
    NSError* error;
    NSString *key = @"age";
    BOOL isValid = [self validateValue:&age forKey:key error:&error];
    if (isValid) {
        NSLog(@"键值匹配");
        [self setValue:age forKey:key];
    }
    else {
        NSLog(@"键值不匹配");
    }
    
    NSLog(@"log--年龄是%@", [self valueForKey:@"age"]);

}


#pragma mark - KVC处理集合 -- NSArray(xxx)
/*  @sum,@avg,@count,@min,@max
    @distinctUnionOfObjects,@unionOfObjects
 */
- (void)KVCArrayMethod{
    
    TestViewController *testVCOne = [TestViewController new];
    testVCOne.age = 10;
    TestViewController *testVCTwo = [TestViewController new];
    testVCTwo.age = 20;
    TestViewController *testVCThree = [TestViewController new];
    testVCThree.age = 30;
    TestViewController *testVCFour = [TestViewController new];
    testVCFour.age = 40;
    TestViewController *testVCFive = [TestViewController new];
    testVCFive.age = 10; // 用于测试数组重复性
    
    
    
    /* 简单集合运算符: @sum,@avg,@count,@min,@max  */
    NSArray *ageArr = @[testVCOne,testVCTwo,testVCThree,testVCFour,testVCFive];
    NSNumber* sum = [ageArr valueForKeyPath:@"@sum.age"];   // 几个对象存储在一个数组中，后可以取不同对象的相同属性值，并作出相关KVC操作，如sum/avg/
    NSLog(@"log--sum:%f",sum.floatValue);
    NSNumber* avg = [ageArr valueForKeyPath:@"@avg.age"];
    NSLog(@"log--avg:%f",avg.floatValue);
    NSNumber* count = [ageArr valueForKeyPath:@"@count"];
    NSLog(@"log--count:%f",count.floatValue);
    NSNumber* min = [ageArr valueForKeyPath:@"@min.age"];
    NSLog(@"log--min:%f",min.floatValue);
    NSNumber* max = [ageArr valueForKeyPath:@"@max.age"];
    NSLog(@"log--max:%f",max.floatValue);
    
    
    /* 以数组的方式返回指定内容:
     @distinctUnionOfObjects // 返回的元素是唯一的，去重后的结果
     @unionOfObjects    // 返回元素全集
     返回值都是NSArray
     */
    NSArray *distinctArr = [ageArr valueForKeyPath:@"@distinctUnionOfObjects.age"];
    [distinctArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"log--distinctUnionOfObjects:%f",[(NSNumber *)obj floatValue]);
    }];
    
    NSArray *unionArr = [ageArr valueForKeyPath:@"@unionOfObjects.age"];
    [unionArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"log--unionOfObjects:%f",[(NSNumber *)obj floatValue]);
    }];

    
}


#pragma mark - KVC处理字典 (NSDictionary) -- 可直接用于赋值model属性或者直接修改model属性数值。
/**
 - (NSDictionary<NSString *, id> *)dictionaryWithValuesForKeys:(NSArray<NSString *> *)keys; // 输入一组key，返回这组key对应的属性，再组成一个字典
 - (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *, id> *)keyedValues; // 用来修改Model中对应key的属性
*/
- (void)KVCDictionaryMethod{
    //  模型转字典
    Model *model = [Model new];
    model.reportCreateTime = @"2018";
    model.reportPath = @"path";
    model.reportId = @"0001";
    
    NSArray *propertyArr = @[@"reportCreateTime",@"reportPath",@"reportId"];
    NSDictionary *propertyDict = [model dictionaryWithValuesForKeys:propertyArr];
    NSLog(@"log--模型转字典:%@",propertyDict);
    
    //  字典转模型 -- 修改对应模型字典属性值
    NSDictionary  *propertyDictTwo = @{@"reportCreateTime":@"2019",@"reportPath":@"pathTwo",@"reportId":@"0002"};
    [model setValuesForKeysWithDictionary:propertyDictTwo];            //用key Value来修改Model的属性
    NSLog(@"log--reportCreateTime:%@  reportPath:%@ reportId:%@",model.reportCreateTime,model.reportPath,model.reportId);
    
}







@end



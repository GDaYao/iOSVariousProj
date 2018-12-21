//
//  Student+CoreDataProperties.h
//  
//
//  Created by AHZX on 2018/12/21.
//
//

#import "Student+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest;

@property (nullable, nonatomic, retain) NSObject *age;
@property (nullable, nonatomic, retain) NSObject *name;
@property (nullable, nonatomic, retain) NSObject *height;
@property (nullable, nonatomic, retain) NSObject *number;
@property (nullable, nonatomic, retain) NSObject *sex;

@end

NS_ASSUME_NONNULL_END

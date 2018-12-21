//
//  Student+CoreDataProperties.m
//  
//
//  Created by AHZX on 2018/12/21.
//
//

#import "Student+CoreDataProperties.h"

@implementation Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Student"];
}

@dynamic age;
@dynamic name;
@dynamic height;
@dynamic number;
@dynamic sex;

@end

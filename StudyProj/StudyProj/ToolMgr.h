//
//  ToolMgr.h
//  StudyProj

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToolMgr : NSObject



#pragma mark - get file size
+ (long long)getFileSizeAtPath:(NSString*)filePath;


@end


NS_ASSUME_NONNULL_END

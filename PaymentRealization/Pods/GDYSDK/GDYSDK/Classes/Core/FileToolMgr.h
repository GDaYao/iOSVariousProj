//
//  FileToolMgr.h



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileToolMgr : NSObject

#pragma mark - get iOS-App some file path
/**
 get iOS app three file content path
 
 @return `NSString`
 */
+ (NSString *)getDocumentFilePath;
+ (NSString *)getLibraryFilPath;
+ (NSString *)getCacheFilePath;


#pragma mark - create iOS App save work space file
+ (NSString *)createiOSAppSaveWorkFileWithPath:(NSString *)saveWorkPath;


#pragma mark - implement "NSString/path" substring in find "/" position
+ (NSString *)generateSubstringToLastWithString:(NSString *)stringOrPath;
+ (NSString *)generateSubstringFromBeginWithString:(NSString *)stringOrPath;

#pragma mark - delete file from file path
+ (void)removeItemWithPath:(NSString *)pathStr;

#pragma mark - move file or change path name
+ (void)moveFilePathOrChangePathName:(NSString *)pathString newFilePath:(NSString *)newPath;

#pragma mark - get file size at path
+ (long long)getFileSizeAtPath:(NSString*)filePath;



@end

NS_ASSUME_NONNULL_END

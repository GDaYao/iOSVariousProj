//
//  FileToolMgr.m


#import "FileToolMgr.h"

@implementation FileToolMgr


#pragma mark - ---- get iOS-App some file path ----
+ (NSString *)getDocumentFilePath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}
+ (NSString *)getLibraryFilPath{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}
+ (NSString *)getCacheFilePath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark - ---- create iOS App save work space file ----
+ (NSString *)createiOSAppSaveWorkFileWithPath:(NSString *)saveWorkPath{
    // get 'Documents' file
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentPath = [path objectAtIndex:0];
    // specifilly new file path
    NSString *collectSavedPath = [doucumentPath stringByAppendingPathComponent:saveWorkPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:collectSavedPath isDirectory:&isDir]) {
        // create new file
        [fileManager createDirectoryAtPath:collectSavedPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    // back complete path
    return collectSavedPath;
}


#pragma mark - ---- judge path exist ----
+ (NSString *)judgeParaPathNotExistCreateWithString:(NSString *)pathString pathSufix:(NSString *)pathPrefix{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fm fileExistsAtPath:pathPrefix isDirectory:&isDir]) {
        [fm createDirectoryAtPath:pathPrefix withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *myImgPath = [pathPrefix stringByAppendingPathComponent:pathString];
    return myImgPath;
}

#pragma mark - implement "NSString/path" substring from "/" position to end
+ (NSString *)generateSubstringToLastWithString:(NSString *)stringOrPath{
    NSRange range = [stringOrPath rangeOfString:@"/" options:NSBackwardsSearch] ;
    if(range.length == 0){
        return stringOrPath;
    }
    NSString *lastStr = [stringOrPath substringFromIndex:range.location+1];
    return lastStr;
}
+ (NSString *)generateSubstringFromBeginWithString:(NSString *)stringOrPath{
    NSRange range = [stringOrPath rangeOfString:@"/"] ;
    if(range.length == 0){
        return stringOrPath;
    }
    NSString *lastStr = [stringOrPath substringToIndex:range.location];
    return lastStr;
}

#pragma mark - ---- delete file from file path ----
+ (void)removeItemWithPath:(NSString *)pathStr
{
    if (pathStr.length == 0 || !pathStr) {
        return;
    }
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    if([fm fileExistsAtPath:pathStr isDirectory:&isDir])
    {
        [fm removeItemAtPath:pathStr error:nil];
    }
}

#pragma mark - move file or change path name
+ (void)moveFilePathOrChangePathName:(NSString *)pathString newFilePath:(NSString *)newPath{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    if([fm fileExistsAtPath:pathString isDirectory:&isDir])
    {
        [fm moveItemAtPath:pathString toPath:newPath error:nil];
    }
}

#pragma mark - get file size at path
+ (long long)getFileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}



@end

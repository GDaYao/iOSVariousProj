//
//  EncryptMgr.h


// func: use encrypt/decrypt

#import <Foundation/Foundation.h>


#define __BASE64( text )        [CommonFunc base64StringFromText:text]

#define __TEXT( base64 )        [CommonFunc textFromBase64String:base64]

@interface EncryptMgr : NSObject

#pragma mark - base64 covert string
// 将文本字符串转换为base64格式字符串
+(NSString *)base64StringFromText:(NSString *)text;
// 将base64格式字符串转换为文本字符串
+(NSString *)textFromBase64String:(NSString *)base64;

// 文本数据转换为base64格式字符串
+(NSString *)base64EncodedStringFrom:(NSData *)data;
// base64格式字符串转换为文本数据
+(NSData *)dataWithBase64EncodedString:(NSString *)string;

#pragma mark DES加密
//文本数据进行DES加密
+ (NSString*)encrypt:(NSString*)plainText;
// 文本数据进行DES解密
+ (NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key;
+ (NSString *) encryptUseDES:(NSString *)clearText ;

#pragma mark BASE64加密
// kCCEncrypt 加密
+(NSString *)encryptWithText:(NSString *)sText;
// kCCDecrypt 解密
+(NSString *)decryptWithText:(NSString *)sText;


#pragma mark - md5 encryption lock
/**
 md5 lock
 
 @param str Need encryption NSString
 @return new generate NSString
 */
+ (nonnull NSString *)md5:(nonnull NSString *)str;




@end


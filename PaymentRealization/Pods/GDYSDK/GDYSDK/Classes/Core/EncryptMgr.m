//
//  EncryptMgr.m
//

#import "EncryptMgr.h"
#import <CommonCrypto/CommonCrypto.h>
#import "GDYBase64.h"


#define LocalStr_None @""
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
#define gkey @"GDYSDKBASE64"
#define gIv @"01234567"


@implementation EncryptMgr

#pragma mark - 字符串转换
#pragma mark 将文本字符串转换为base64格式字符串
+ (NSString *)base64StringFromText:(NSString *)text{
    if (text && ![text isEqualToString:LocalStr_None]) {
        
        //取项目的bundleIdentifier作为KEY  改动了此处
        
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        
        //IOS 自带DES加密 Begin  改动了此处
        
        //data = [self DESEncrypt:data WithKey:key];
        
        //IOS 自带DES加密 End
        
        return [self base64EncodedStringFrom:data];
    }else {
        return LocalStr_None;
    }
}
#pragma mark 将base64格式字符串转换为文本字符串
+(NSString *)textFromBase64String:(NSString *)base64{
    if (base64 && ![base64 isEqualToString:LocalStr_None]) {
        
        //取项目的bundleIdentifier作为KEY  改动了此处
        
        //NSString *key = [[NSBundle mainBundle] bundleIdentifier];
        
        NSData *data = [self dataWithBase64EncodedString:base64];
        
        //IOS 自带DES解密 Begin    改动了此处
        
        // data = [self DESDecrypt:data WithKey:key];
        
        //IOS 自带DES加密 End
        
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }else {
        return LocalStr_None;
    }
}


+(NSData *)DESEncrypt:(NSData *)data WithKey:(NSString *)key{
    char keyPtr[kCCKeySizeAES256+1];
    
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          
                                          keyPtr, kCCBlockSizeDES,
                                          
                                          NULL,
                                          
                                          [data bytes], dataLength,
                                          
                                          buffer, bufferSize,
                                          
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
    }
    
    free(buffer);
    
    return nil;
    
}

#pragma mark - DES
#pragma mark 文本数据进行DES解密
+(NSData *)DESDecrypt:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          
                                          keyPtr, kCCBlockSizeDES,
                                          
                                          NULL,
                                          
                                          [data bytes], dataLength,
                                          
                                          buffer, bufferSize,
                                          
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess)
    {
        
        NSData*dic=[NSData dataWithBytes:buffer length:numBytesDecrypted];
        return dic;
        
    }
    
    free(buffer);
    
    return nil;
    
}

#pragma mark 文本数据进行DES加密
+ (NSString*)encrypt:(NSString*)plainText
{
    
    NSData * data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void * vplainText =(const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t * bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize =(plainTextBufferSize + kCCBlockSize3DES)&~(kCCBlockSize3DES-1);
    bufferPtr = malloc(bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr,0x0,bufferPtrSize);
    
    const void * vkey =(const void *)[gkey UTF8String];
    const void * vinitVec =(const void *)[gIv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding ,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData * myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString * result = [GDYBase64 stringByEncodingData:myData];
    
    return result;
}

#pragma mark - BASE64
#pragma mark 加密方法封装
+ (NSString *)encryptWithText:(NSString *)sText{
    // kCCEncrypt 加密
    return [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:gkey];
}

#pragma mark 解密方法封装
+ (NSString *)decryptWithText:(NSString *)sText{
    // kCCDecrypt 解密
    return [self encrypt:sText encryptOrDecrypt:kCCDecrypt key:gkey];
}
+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOperation == kCCDecrypt)//解密
    {
        NSData *EncryptData = [GDYBase64 decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else //加密
    {
        NSData* data = [sText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES)&~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *)[gkey UTF8String];
    const void * vinitVec =(const void *)[gIv UTF8String];
    ccStatus = CCCrypt(encryptOperation,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding ,
                       vkey,
                       kCCKeySize3DES,
                       
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result;
    
    if (encryptOperation == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding]
        ;
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GDYBase64 stringByEncodingData:myData];
    }
    
    return result;
    
}



#pragma mark - ---- md5 encryption lock ----
/**
 need import "#import <CommonCrypto/CommonDigest.h>"
 */
+ (nonnull NSString *)md5:(nonnull NSString *)str{
    NSString *md5_result = @"";
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), result ); // This is the md5 call
    
    md5_result = [NSString stringWithFormat:
                  @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                  result[0], result[1], result[2], result[3],
                  result[4], result[5], result[6], result[7],
                  result[8], result[9], result[10], result[11],
                  result[12], result[13], result[14], result[15]
                  ];
    return md5_result;
}





@end



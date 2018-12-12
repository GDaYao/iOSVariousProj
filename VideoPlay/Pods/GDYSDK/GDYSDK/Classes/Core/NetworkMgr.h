//
//  NetDataMgr.h

//  network request
//  need accompany 'CustomAFNetHTTPSessionMgr'


#import <Foundation/Foundation.h>

@interface NetDataMgr : NSObject

#pragma mark - ----AFNetworking----
/**
 if AFNetworking network request parameter need encrypt,please change AFNetworking some method.
 Beacuse AFNetworking only parse NSDictionary/json of parameter,encrypt parameter is subclass of NSString.
 */



/**
 use `AFNetworking` request
 if parameter string need encrypt,need change `AFNetworking` method.
 or attention set http header ticket.
 */

/**
 AFNet reachability status

 @param networkStatus A block object to be executed get current network status.
 */
+ (void)backCurrentNetworkWithStatusStr:(void(^)(NSString *netStr))networkStatus;

/**
 `POST` method -- net data request or net json request

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param success A block object to be executed when request finish success.This block takes `responseObject` arguments,created by the client response serializer.
 @param failure A block object to be executed when request finish failure.This block takes `error` arguments,describing the network or parsing error that occurred.
 */
+ (void)AFHttpDataTaskPostMethodWithURLString:(NSString *)URLString
                                   parameters:(id)parameters
                                      success:(void (^)(id _Nullable responseObject))success
                                      failure:(void (^)(NSError * _Nullable error))failure;

/**
 `GET` method -- net data request or net json request

 @param URLString The URL string used to create the request URL.
 @param parameters The parameters to be encoded according to the client request serializer.
 @param success A block object to be executed when request finish success.This block takes `responseObject` arguments,created by the client response serializer.
 @param failure A block object to be executed when request finish failure.This block takes `error` arguments,describing the network or parsing error that occurred.
 */
+ (void)AFHttpDataTaskGETMethodWithURLString:(NSString *)URLString
                                  parameters:(id)parameters
                                     success:(void (^)(id _Nullable responseObject))success
                                     failure:(void (^)(NSError * _Nullable error))failure;

/**
 download

 @param downloadStr Request URL.
 @param parameters Client request serializer.
 @param specifilyPath Finish download task to save path.
 @param ticketStr set http header ticket
 @param progress This progress description download task progress.
 */
+ (void)createDownloadTaskWithDownloadStr:(NSString *)downloadStr parameters:(id)parameters downloadSpecifilyPath:(NSString *)specifilyPath  httpHeaderTicket:(NSString *)ticketStr  downloadProgress:(void(^)(NSProgress * _Nonnull downloadProgress))progress;

/**
 directly download
 */
+ (void)executeDowloadFileWithStr:(NSString *)originStr;


/**
 upload -- directly

 @param uploadStr Upload Request URL.
 @param parameters Client request serializer.
 @param filePathStr Upload local or bundle file path.
 @param progress Upload progress.
 */
+ (void)createUploadTaskWithRequestUploadStr:(NSString *)uploadStr parameters:(id)parameters uploadFilePathStr:(NSString *)filePathStr progress:(void(^)(NSProgress * _Nonnull uploadProgress))progress;

/**
 use 'file url' upload

 @param uploadStr Upload Request URL.
 @param parameters Client request serializer.
 @param filePathStr File path string.
 @param interName Interface name.
 @param serverName Rename server file.
 @param uploadType Upload file type.
 @param progress Upload progress.
 */
+ (void)createUploadTaskWithStreamedRequestUploadStr:(NSString *)uploadStr parameters:(id)parameters uploadFilePathStr:(NSString *)filePathStr interfaceName:(NSString *)interName uploadServerName:(id)serverName uploadType:(id)uploadType progress:(void(^)(NSProgress * _Nonnull uploadProgress))progress;

/**
 use 'data' upload

 @param uploadStr Upload Request URL.
 @param parameters Client request serializer.
 @param data Upload data.
 @param interName Upload interface name.
 @param serverName Rename server file.
 @param uploadType Upload file type.
 @param progress Upload progress.
 */
+ (void)createUploadTaskWithStreamedRequestUploadStr:(NSString *)uploadStr parameters:(id)parameters localData:(NSData *)data interfaceName:(NSString *)interName uploadServerName:(id)serverName uploadType:(id)uploadType progress:(void(^)(NSProgress * _Nonnull uploadProgress))progress;


#pragma mark - ----NSURLConnection----
/**
  data task request and http request header
 */
+ (void)NSURLConnectionDataTaskPostMethodWithURLString:(NSString *)URLString
                                            parameters:(id)parameters
                                             ticketStr:(NSString *)ticketStr
                                               success:(void (^)(id _Nullable responseObject))success
                                               failure:(void (^)(NSError * _Nullable error))failure;

#pragma mark - success(responseObject) ==> NSDictionary
+ (id)responseResult:(id)response;






@end

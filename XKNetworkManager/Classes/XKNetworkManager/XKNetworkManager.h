//
//  XKNetworkManager.h
//  Minshuku
//
//  Created by Nicholas on 16/5/10.
//  Copyright © 2016年 Nicholas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#define XK_NetworkManager [XKNetworkManager shareManager]

@interface XKNetworkManager : NSObject

@property (nonatomic, copy) NSString *baseURL;
///请求超时,默认十秒
@property (nonatomic, assign) NSInteger timeout;
///https证书路径
@property (nonatomic, copy)   NSString *httpsCerPath;
///成功的code
@property (nonatomic, assign) NSInteger successfulCode;
///未登录的code
@property (nonatomic, assign) NSInteger logoutCode;
///返回消息的字段
@property (nonatomic, copy)   NSString *messageKey;
///code字段
@property (nonatomic, copy)   NSString *codeKey;
///登录行为
@property (nonatomic, copy)   void(^xkLoginAction)(void);
///请求完成但请求失败
@property (nonatomic, copy)   void(^xkReqeustCompletedButFailedAction)(NSInteger code, NSString *message);
///配置manager
@property (nonatomic, copy) void(^xkConfigSessionManager)(AFHTTPSessionManager *manager);

///单例
+ (instancetype)shareManager;

- (AFHTTPSessionManager *)sessionManager;

/**
 直接拼接

 @param urlString 地址
 @param parameters 参数
 @return 拼接后的地址
 */
+ (NSString *)xk_appendURLWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters;

/**
 拼接参数

 @param parameters 参数
 @return 拼接后的参数
 */
+ (NSString *)xk_appendParameters:(NSDictionary *)parameters;

/**
 按所给的keys顺序拼接参数

 @param parameters 参数
 @param keys key
 @return 拼接后的参数
 */
+ (NSString *)xk_appendParameters:(NSDictionary *)parameters keys:(NSArray *)keys;

/**
 GET

 @param urlString 地址
 @param parameters 参数
 @param progress 进度回调
 @param success 成功回调
 @param failure 失败回调
 */
- (NSURLSessionDataTask *)xk_GETRequestWithUrlString:(NSString *)urlString parameters:(id)parameters progress:(void(^)(CGFloat progress))progress success:(void(^)(NSDictionary* responseDict, id dataValue, BOOL result, NSString *errorMessage))success failure:(void(^)(NSError *error, NSString *errorMessage, NSInteger code))failure;

/**
 POST

 @param urlString 地址
 @param parameters 参数
 @param progress 进度回调
 @param success 成功回调
 @param failure 失败回调
 */
- (NSURLSessionDataTask *)xk_POSTRequestWithUrlString:(NSString *)urlString parameters:(id)parameters progress:(void(^)(CGFloat progress))progress success:(void(^)(NSDictionary* responseDict, id dataValue, BOOL result, NSString *errorMessage))success failure:(void(^)(NSError *error, NSString *errorMessage, NSInteger code))failure;

- (NSURLSessionDataTask *)xk_JsonPostRequestWithUrlString:(NSString *)urlString progress:(void(^)(CGFloat progress))progress parameters:(NSDictionary *)parameters success:(void(^)(NSDictionary* responseDict, id dataValue, BOOL result, NSString *errorMessage))success failure:(void(^)(NSError *error, NSString *errorMessage, NSInteger code))failure;

/**
 上传图片，一张一张的上传

 @param images 图片
 @param urlString 地址
 @param parameters 参数
 @param progress 进度
 @param success 成功回调
 @param failure 失败回调
 */
- (NSURLSessionDataTask *)xk_uploadImages:(NSArray *)images toURL:(NSString *)urlString parameters:(id)parameters progress:(void (^)(CGFloat progress, NSInteger index))progress success:(void (^)(id responseObject, NSInteger index, BOOL finished))success failure:(void (^)(NSError *error,NSInteger index))failure;

/**
 批量上传图片,一次性上传

 @param images 图片
 @param urlString 地址
 @param parameters 参数
 @param imageNames 图片名
 @param progress 进度回调
 @param success 成功回调
 @param failure 失败回调
 */
- (NSURLSessionDataTask *)xk_uploadImages:(NSArray *)images toURL:(NSString *)urlString parameters:(id)parameters imageNmaes:(NSArray *)imageNames progress:(void (^)(CGFloat progress))progress success:(void (^)(NSDictionary *responseDict, BOOL result, NSString *message))success failure:(void (^)(NSError *error, NSString *errorMessage))failure;

/**
 上传视频
 
 @param videos 视频
 @param urlString 地址
 @param parameters 参数
 @param videoNames 视频名
 @param progress 进度回调
 @param success 成功回调
 @param failure 失败回调
 */
- (NSURLSessionDataTask *)xk_uploadVideos:(NSArray *)videos toURL:(NSString *)urlString parameters:(id)parameters videoNmaes:(NSArray *)videoNames progress:(void (^)(CGFloat progress))progress success:(void (^)(NSDictionary *responseDict, BOOL result, NSString *message))success failure:(void (^)(NSError *error, NSString *errorMessage))failure;

///**
// 上传视频
//
// @param videoUrl 视频url
// @param urlString 接口地址
// @param parameters 参数
// @param videoName 是拼命
// @param coverImage 视频封面图
// @param imageName 封面图名字
// @param progress 进度回调
// @param success 成功回调
// @param failure 失败回调
// */
//- (void)xk_uploadVideo:(NSURL *)videoUrl toURL:(NSString *)urlString parameters:(id)parameters videoName:(NSString *)videoName coverImage:(NSData *)coverImage imageName:(NSString *)imageName  progress:(void (^)(CGFloat progress))progress success:(void (^)(NSDictionary *responseDict, BOOL result, NSString *message))success failure:(void (^)(NSError *error, NSString *errorMessage))failure;

///取消上一个POST
- (void)xk_cancelLastPOSTTask;
///取消上一个GET
- (void)xk_cancelLastGETTask;
///取消
- (void)xk_canceAllTask;

@end

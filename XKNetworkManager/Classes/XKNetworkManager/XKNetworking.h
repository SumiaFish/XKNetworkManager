//
//  XKNetworking.h
//  XKNetworkManager
//
//  Created by Mac on 12/31/20.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, XKNetworking_Methond) {
    XKNetworkingMethond_GET,
    XKNetworkingMethond_POST,
    XKNetworkingMethond_UPLOAD,
};

@class XKNetworking;

typedef XKNetworking* _Nullable (^ XKNetworkingSetter) (id value);

typedef XKNetworking* _Nullable (^ XKNetworkingConfManager) (AFHTTPSessionManager *manager);

typedef void (^ XKNetworkingProgress) (CGFloat progress, NSURLSessionDataTask *task);

typedef void (^ XKNetworkingSucc) (id response, NSURLSessionDataTask *task);

typedef NSError* _Nullable (^ XKNetworkingHandleResponse) (id response, NSURLSessionDataTask *task);

typedef BOOL (^ XKNetworkingInterceptor) (NSString *url, NSDictionary *params);

typedef void (^ XKNetworkingWillSend) (NSString *url, NSDictionary *params);

typedef void (^ XKNetworkingFailed) (NSError *error, NSURLSessionDataTask *task);

typedef void (^ XKNetworkingFinaly) (NSError * _Nullable error, id _Nullable response, NSURLSessionDataTask *task);

typedef void (^ XKNetworkingSend) (void);

@interface XKNetworking : NSObject

@property (copy, nonatomic, readonly) XKNetworking* _Nullable (^ manager) (XKNetworkingConfManager setter);

@property (copy, nonatomic, readonly) XKNetworkingSetter url;

@property (copy, nonatomic, readonly) XKNetworkingSetter methond;

//@property (copy, nonatomic, readonly) XKNetworkingSetter path;

@property (copy, nonatomic, readonly) XKNetworkingSetter params;

@property (copy, nonatomic, readonly)  XKNetworking* _Nullable (^ progress) (XKNetworkingProgress setter);

@property (copy, nonatomic, readonly)  XKNetworking* _Nullable (^ succ) (XKNetworkingSucc setter);

@property (copy, nonatomic, readonly)  XKNetworking* _Nullable (^ failed) (XKNetworkingFailed setter);

@property (copy, nonatomic, readonly)  XKNetworking* _Nullable (^ finaly) (XKNetworkingFinaly setter);

@property (copy, nonatomic, readonly)  XKNetworking* _Nullable (^ handleResponse) (XKNetworkingHandleResponse setter);

@property (copy, nonatomic, readonly)  XKNetworking* _Nullable (^ interceptor) (XKNetworkingInterceptor setter);

@property (copy, nonatomic, readonly)  XKNetworking* _Nullable (^ willSend) (XKNetworkingWillSend setter);

@property (copy, nonatomic, readonly) XKNetworkingSend send;

+ (AFHTTPSessionManager *)sessionManager;
- (AFHTTPSessionManager *)sessionManager;
- (NSURLSessionDataTask *)task;
- (NSString *)urlString;
- (NSDictionary *)paramsDict;
- (XKNetworking_Methond)methondValue;

@end

XKNetworking* XKN(void);

NS_ASSUME_NONNULL_END

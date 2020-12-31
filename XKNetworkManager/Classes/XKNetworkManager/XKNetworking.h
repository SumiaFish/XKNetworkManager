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

typedef XKNetworking* _Nullable (^ XKNetworkingProgress) (CGFloat progress, NSURLSessionDataTask *task);

typedef XKNetworking* _Nullable (^ XKNetworkingSucc) (id response, NSURLSessionDataTask *task);

typedef XKNetworking* _Nullable (^ XKNetworkingFailed) (NSError *error, NSURLSessionDataTask *task);

typedef XKNetworking* _Nullable (^ XKNetworkingFinaly) (NSError * _Nullable error, id _Nullable response, NSURLSessionDataTask *task);

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

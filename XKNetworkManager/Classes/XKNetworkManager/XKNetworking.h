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

@property (copy, nonatomic, readonly) XKNetworkingConfManager manager;

@property (copy, nonatomic, readonly) XKNetworkingSetter url;

@property (copy, nonatomic, readonly) XKNetworkingSetter methond;

@property (copy, nonatomic, readonly) XKNetworkingSetter params;

@property (copy, nonatomic, readonly)  XKNetworking* _Nullable (^ progress) (XKNetworkingProgress setter);

@property (copy, nonatomic, readonly)  XKNetworking* _Nullable (^ succ) (XKNetworkingSucc setter);

@property (copy, nonatomic, readonly)  XKNetworking* _Nullable (^ failed) (XKNetworkingFailed setter);

@property (copy, nonatomic, readonly)  XKNetworking* _Nullable (^ finaly) (XKNetworkingFinaly setter);

@property (copy, nonatomic, readonly)  XKNetworking* _Nullable (^ handleResponse) (XKNetworkingHandleResponse setter);

@property (copy, nonatomic, readonly)  XKNetworking* _Nullable (^ interceptor) (XKNetworkingInterceptor setter);

@property (copy, nonatomic, readonly)  XKNetworking* _Nullable (^ willSend) (XKNetworkingWillSend setter);

@property (copy, nonatomic, readonly) XKNetworkingSetter retry;

@property (copy, nonatomic, readonly) XKNetworkingSend send;

@property (copy, nonatomic, readonly) NSString *identifier;

- (AFHTTPSessionManager *)sessionManager;
- (NSURLSessionDataTask *)task;
- (NSString *)urlValue;
- (NSDictionary *)paramsValue;
- (XKNetworking_Methond)methondValue;

@end

@class XKNetworkingContainer;

typedef XKNetworkingContainer* _Nullable (^ XKNetworkingContainerSetter) (id value);

typedef void (^ XKNetworkingContainerProgress) (NSDictionary<NSString *, NSNumber *> *progressMap);

typedef void (^ XKNetworkingContainerSucc) (NSDictionary<NSString *, id> *responseMap);

typedef void (^ XKNetworkingContainerFailed) (NSDictionary<NSString *, NSError *> *errorMap, NSDictionary<NSString *, id> *responseMap);

typedef void (^ XKNetworkingContainerFinaly) (NSDictionary<NSString *, NSError *> *errorMap, NSDictionary<NSString *, id> *responseMap);

typedef void (^ XKNetworkingContainerSend) (void);

typedef NS_ENUM(NSInteger, XKNetworkingMergeType) {
    XKNetworkingMergeType_All,
    XKNetworkingMergeType_Any,
    XKNetworkingMergeType_Sequence,
};

@interface XKNetworkingContainer : NSObject

@property (copy, nonatomic, readonly)  XKNetworkingContainer* _Nullable (^ progress) (XKNetworkingContainerProgress setter);

@property (copy, nonatomic, readonly)  XKNetworkingContainer* _Nullable (^ succ) (XKNetworkingContainerSucc setter);

@property (copy, nonatomic, readonly)  XKNetworkingContainer* _Nullable (^ failed) (XKNetworkingContainerFailed setter);

@property (copy, nonatomic, readonly)  XKNetworkingContainer* _Nullable (^ finaly) (XKNetworkingContainerFinaly setter);

@property (copy, nonatomic, readonly) XKNetworkingContainerSend send;

@property (copy, nonatomic, readonly) NSArray<XKNetworking *> *requests;

@property (assign, nonatomic, readonly) XKNetworkingMergeType type;

@property (copy, nonatomic, readonly) NSString *identifier;

+ (instancetype)all:(NSArray<XKNetworking *> *)requests;
+ (instancetype)any:(NSArray<XKNetworking *> *)requests;
+ (instancetype)sequence:(NSArray<XKNetworking *> *)requests;

@end

XKNetworking* XKN(void);

NS_ASSUME_NONNULL_END

//
//  XKNetworking.m
//  XKNetworkManager
//
//  Created by Mac on 12/31/20.
//

#import "XKNetworking.h"
#import "XKNetworkManager.h"

@interface XKNetworking ()

@property (copy, nonatomic, readwrite) XKNetworking* _Nullable (^ manager) (XKNetworkingConfManager setter);

@property (copy, nonatomic, readwrite) XKNetworkingSetter url;

@property (copy, nonatomic, readwrite) XKNetworkingSetter methond;

//@property (copy, nonatomic, readonly) XKNetworkingSetter path;

@property (copy, nonatomic, readwrite) XKNetworkingSetter params;

@property (copy, nonatomic, readwrite)  XKNetworking* _Nullable (^ progress) (XKNetworkingProgress setter);

@property (copy, nonatomic, readwrite)  XKNetworking* _Nullable (^ succ) (XKNetworkingSucc setter);

@property (copy, nonatomic, readwrite)  XKNetworking* _Nullable (^ failed) (XKNetworkingFailed setter);

@property (copy, nonatomic, readwrite)  XKNetworking* _Nullable (^ finaly) (XKNetworkingFinaly setter);

@property (copy, nonatomic, readwrite)  XKNetworking* _Nullable (^ handleResponse) (XKNetworkingHandleResponse setter);

@property (copy, nonatomic, readwrite)  XKNetworking* _Nullable (^ interceptor) (XKNetworkingInterceptor setter);

@property (copy, nonatomic, readwrite)  XKNetworking* _Nullable (^ willSend) (XKNetworkingWillSend setter);

@property (copy, nonatomic, readwrite) XKNetworkingSetter retry;

@property (copy, nonatomic, readwrite) XKNetworkingSend send;

@end

@implementation XKNetworking
{
    NSString *__url;
    NSNumber *__methond;
    NSDictionary *__params;
    XKNetworkingProgress __progress;
    XKNetworkingSucc __succ;
    XKNetworkingFailed __failed;
    XKNetworkingFinaly __finaly;
    XKNetworkingHandleResponse __handleResponse;
    XKNetworkingInterceptor __interceptor;
    XKNetworkingWillSend __willSend;
    NSNumber *__retry;
    NSURLSessionDataTask *__task;
}

- (instancetype)init {
    if (self = [super init]) {
        
        __weak typeof(self) weakself = self;
        
        self.manager = ^XKNetworking * _Nullable(XKNetworkingConfManager setter) {
            setter([weakself sessionManager]);
            return weakself;
        };
        
        self.url = ^XKNetworking * _Nullable(id  _Nonnull value) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__url = [value isKindOfClass:NSString.class] ? [value copy] : @"";
            return weakself;
        };
        
        self.methond = ^XKNetworking * _Nullable(id  _Nonnull value) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__methond = [value isKindOfClass:NSNumber.class] ? [value copy] : @(XKNetworkingMethond_GET);
            return weakself;
        };
        
        self.params = ^XKNetworking * _Nullable(id  _Nonnull value) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__url = [value isKindOfClass:NSDictionary.class] ? [value copy] : @{};
            return weakself;
        };
        
        self.succ = ^(XKNetworkingSucc setter) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__succ = [setter copy];
            return weakself;
        };
        
        self.progress = ^(XKNetworkingProgress setter) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__progress = [setter copy];
            return weakself;
        };
        
        self.failed = ^(XKNetworkingFailed setter) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__failed = [setter copy];
            return weakself;
        };
        
        self.finaly = ^(XKNetworkingFinaly setter) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__finaly = [setter copy];
            return weakself;
        };
        
        self.handleResponse = ^XKNetworking * _Nullable(XKNetworkingHandleResponse setter) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__handleResponse = [setter copy];
            return weakself;
        };
        
        self.interceptor = ^XKNetworking * _Nullable(XKNetworkingInterceptor setter) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__interceptor = [setter copy];
            return weakself;
        };
        
        self.willSend = ^XKNetworking * _Nullable(XKNetworkingWillSend setter) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__willSend = [setter copy];
            return weakself;
        };
        
        self.retry = ^XKNetworking * _Nullable(id  _Nonnull value) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__retry = [value isKindOfClass:NSNumber.class] ? [value copy] : @(0);
            return weakself;
        };
        
        self.send = ^{
            [weakself impSend];
        };
    }
    
    return self;
}

- (void)impSend {
    // 拦截请求
    if (![self onInterceptor]) {
        return;
    }
    
    // 开始请求
    if (self->__methond.integerValue == XKNetworkingMethond_GET) {
        [self willSend];
        
        self->__task = [XKNetworkManager.shareManager xk_GETRequestWithUrlString:self->__url parameters:self->__params progress:^(CGFloat progress) {
            [self onProgress:progress];
            
        } success:^(NSDictionary *responseDict, id dataValue, BOOL result, NSString *errorMessage) {
            [self onSucc:responseDict];
            
        } failure:^(NSError *error, NSString *errorMessage, NSInteger code) {
            [self onFailed:error];
            
        }];
        
    } else if (self->__methond.integerValue == XKNetworkingMethond_POST) {
        [self willSend];
        
        self->__task = [XKNetworkManager.shareManager xk_POSTRequestWithUrlString:self->__url parameters:self->__params progress:^(CGFloat progress) {
            [self onProgress:progress];
            
        } success:^(NSDictionary *responseDict, id dataValue, BOOL result, NSString *errorMessage) {
            [self onSucc:responseDict];
            
        } failure:^(NSError *error, NSString *errorMessage, NSInteger code) {
            [self onFailed:error];
            
        }];
        
    } else if (self->__methond.integerValue == XKNetworkingMethond_UPLOAD) {
     
        
    }
}

- (BOOL)onInterceptor {
    if (self->__interceptor) {
        return self->__interceptor(self->__url, self->__params);
    }
    
    return YES;
}

- (void)onWillSend {
    if (self->__willSend) {
        self->__willSend(self->__url, self->__params);
    }
}

- (void)onProgress:(CGFloat)progress {
    self->__progress(progress, self->__task);
}

- (void)onSucc:(id)responseObject {
    if (self->__handleResponse) {
        NSError *error = self->__handleResponse(responseObject, self->__task);
        if (error) {
            [self onFailed:error];
            return;
        }
    }
    
    self->__succ(responseObject, self->__task);
}

- (void)onFailed:(NSError *)error {
    if (self->__retry.integerValue > 0) {
        self->__retry = @(MAX(self->__retry.integerValue - 1, 0));
        [self->__task resume];
        return;
    }
    
    self->__failed(error, self->__task);
}

+ (AFHTTPSessionManager *)sessionManager {
    return XKNetworkManager.shareManager.sessionManager;
}

- (AFHTTPSessionManager *)sessionManager {
    return [self.class sessionManager];
}

- (NSURLSessionDataTask *)task {
    return __task;
}

- (NSString *)urlString {
    return __url;
}

- (NSDictionary *)paramsDict {
    return __params;
}

- (XKNetworking_Methond)methondValue {
    return __methond.integerValue;
}

@end

XKNetworking* XKN(void) {
    return XKNetworking.new;
}

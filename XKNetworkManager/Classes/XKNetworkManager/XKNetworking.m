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
}

- (instancetype)init {
    if (self = [super init]) {
        
        __weak typeof(self) weakself = self;
        
        self.manager = ^XKNetworking * _Nullable(XKNetworkingConfManager setter) {
            if (setter) {
                setter([weakself sessionManager]);
            }
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
        
        self.succ = ^XKNetworking * _Nullable(XKNetworkingSucc setter) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__succ = [setter copy];
            return weakself;
        };
        
        self.progress = ^XKNetworking * _Nullable(XKNetworkingProgress setter) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__progress = [setter copy];
            return weakself;
        };
        
        self.failed = ^XKNetworking * _Nullable(XKNetworkingFailed setter) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__failed = [setter copy];
            return weakself;
        };
        
        self.finaly = ^XKNetworking * _Nullable(XKNetworkingFinaly setter) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__finaly = [setter copy];
            return weakself;
        };
        
        self.send = ^{
            [weakself impSend];
        };
    }
    
    return self;
}

- (void)impSend {
    if (self->__methond.integerValue == XKNetworkingMethond_GET) {
        [XKNetworkManager.shareManager xk_GETRequestWithUrlString:self->__url parameters:self->__params progress:self->__progress success:^(NSDictionary *responseDict, id dataValue, BOOL result, NSString *errorMessage) {
            
        } failure:<#^(NSError *error, NSString *errorMessage, NSInteger code)failure#>]
        
    } else if (self->__methond.integerValue == XKNetworkingMethond_POST) {
        
    } else if (self->__methond.integerValue == XKNetworkingMethond_UPLOAD) {
        
    }
    
    
    
}

+ (AFHTTPSessionManager *)sessionManager {
    return XKNetworkManager.shareManager.sessionManager;
}

- (AFHTTPSessionManager *)sessionManager {
    return [self.class sessionManager];
}

@end

XKNetworking* XKN(void) {
    return XKNetworking.new;
}

//
//  XKNetworking.m
//  XKNetworkManager
//
//  Created by Mac on 12/31/20.
//

#import "XKNetworking.h"

@interface XKNetworkingCenter : NSObject

@property (strong, nonatomic) NSMutableSet *tasks;

@end

@implementation XKNetworkingCenter

+ (instancetype)shareManager {
    static XKNetworkingCenter *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [XKNetworkingCenter new];
    });
    return manager;
}

- (NSMutableSet *)tasks {
    if (!_tasks) {
        _tasks = NSMutableSet.set;
    }
    
    return _tasks;
}

@end

@interface XKNetworking ()

@property (copy, nonatomic, readwrite) XKNetworking* _Nullable (^ manager) (void (^) (AFHTTPSessionManager *manager));

@property (copy, nonatomic, readwrite) XKNetworkingSetter url;

@property (copy, nonatomic, readwrite) XKNetworkingSetter methond;

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

@property (copy, nonatomic, readwrite) NSString *identifier;

@property (weak, nonatomic) XKNetworkingContainer *container;

@end

@interface XKNetworkingContainer ()

@property (copy, nonatomic, readwrite)  XKNetworkingContainer* _Nullable (^ progress) (XKNetworkingContainerProgress setter);

@property (copy, nonatomic, readwrite)  XKNetworkingContainer* _Nullable (^ succ) (XKNetworkingContainerSucc setter);

@property (copy, nonatomic, readwrite)  XKNetworkingContainer* _Nullable (^ failed) (XKNetworkingContainerFailed setter);

@property (copy, nonatomic, readwrite)  XKNetworkingContainer* _Nullable (^ finaly) (XKNetworkingContainerFinaly setter);

@property (copy, nonatomic, readwrite) XKNetworkingContainerSetter retry;

@property (copy, nonatomic, readwrite) XKNetworkingSend send;

@property (nonatomic, assign, readwrite) XKNetworkingMergeType type;

@property (copy, nonatomic, readwrite) NSArray<XKNetworking *> *requests;

@property (copy, nonatomic, readwrite) NSDictionary<NSString *, XKNetworking *> *requestsMap;

@property (copy, nonatomic, readwrite) NSString *identifier;

@property (strong, nonatomic) NSMutableDictionary<NSString *, NSNumber *> *progressMap;

@property (strong, nonatomic) NSMutableDictionary<NSString *, id> *succMap;

@property (strong, nonatomic) NSMutableDictionary<NSString *, NSError *> *errorMap;

@property (strong, nonatomic) NSMutableOrderedSet<NSString *> *completedTasks;

- (void)onProgress:(CGFloat)progress task:(XKNetworking *)task;

- (void)onSucc:(id)responseObject task:(XKNetworking *)task;

- (void)onFailed:(NSError *)error task:(XKNetworking *)task;

@end

@implementation XKNetworking
{
    AFHTTPSessionManager *__manager;
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
        
        AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
        sessionManager.requestSerializer  = [AFHTTPRequestSerializer serializer];
        sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        __manager = sessionManager;
        
        __weak typeof(self) weakself = self;
        
        self.manager = ^XKNetworking * _Nullable(void (^ block)(AFHTTPSessionManager *manager)) {
            __strong typeof(weakself) strongSelf = weakself;
            !block ?: block(strongSelf->__manager);
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
    //
    [[XKNetworkingCenter shareManager].tasks addObject:self];
    
    // 拦截请求
    if (![self onInterceptor]) {
        [[XKNetworkingCenter shareManager].tasks removeObject:self];
        return;
    }
    
    // 开始请求
    if (self->__methond.integerValue == XKNetworkingMethond_GET) {
        [self willSend];
        
        self->__task = [self.sessionManager GET:self->__url parameters:self->__params progress:^(NSProgress * _Nonnull downloadProgress) {
            [self onProgress:downloadProgress.fractionCompleted];
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self onSucc:responseObject];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self onFailed:error];
            
        }];
        
    } else if (self->__methond.integerValue == XKNetworkingMethond_POST) {
        [self willSend];
        
        self->__task = [self.sessionManager POST:self->__url parameters:self->__params progress:^(NSProgress * _Nonnull downloadProgress) {
            [self onProgress:downloadProgress.fractionCompleted];
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self onSucc:responseObject];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self onFailed:error];
            
        }];
        
    } else if (self->__methond.integerValue == XKNetworkingMethond_UPLOAD) {
     
        
    }
}

- (BOOL)onInterceptor {
    return !self->__interceptor ? YES : self->__interceptor(self->__url, self->__params);
}

- (void)onWillSend {
    !self->__willSend ?: self->__willSend(self->__url, self->__params);
}

- (void)onProgress:(CGFloat)progress {
    !self->__progress ?: self->__progress(progress, self->__task);
}

- (void)onSucc:(id)responseObject {
    if (self->__handleResponse) {
        NSError *error = self->__handleResponse(responseObject, self->__task);
        if (error) {
            [self onFailed:error];
            return;
        }
    }
    
    !self->__succ ?: self->__succ(responseObject, self->__task);
    [self onFinaly:nil responseObject:responseObject];
    [self.container onSucc:responseObject task:self];
}

- (void)onFailed:(NSError *)error {
    if (self->__retry.integerValue > 0) {
        self->__retry = @(MAX(self->__retry.integerValue - 1, 0));
        [self->__task resume];
        return;
    }
    
    !self->__failed ?: self->__failed(error, self->__task);
    [self onFinaly:error responseObject:nil];
    [self.container onFailed:error task:self];
}

- (void)onFinaly:(NSError *)error responseObject:(id)responseObject {
    !self->__finaly ?: self->__finaly(error, responseObject, self->__task);
    [[XKNetworkingCenter shareManager].tasks removeObject:self];
}

- (AFHTTPSessionManager *)sessionManager {
    return __manager;
}

- (NSURLSessionDataTask *)task {
    return __task;
}

- (NSString *)urlValue {
    return __url;
}

- (NSDictionary *)paramsValue {
    return __params;
}

- (XKNetworking_Methond)methondValue {
    return __methond.integerValue;
}

- (NSString *)identifier {
    if (!_identifier) {
        _identifier = NSUUID.UUID.UUIDString;
    }
    
    return _identifier;
}

@end

XKNetworking* XKN(void) {
    return XKNetworking.new;
}

@implementation XKNetworkingContainer
{
    XKNetworkingContainerProgress __progress;
    XKNetworkingContainerSucc __succ;
    XKNetworkingContainerFailed __failed;
    XKNetworkingContainerFinaly __finaly;
}

+ (instancetype)all:(NSArray<XKNetworking *> *)requests {
    XKNetworkingContainer *res = XKNetworkingContainer.new;
    res.type = XKNetworkingMergeType_All;
    NSMutableDictionary *map = NSMutableDictionary.dictionary;
    res.requests = requests ? requests.copy : @[];
    [res.requests enumerateObjectsUsingBlock:^(XKNetworking * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.container = res;
        map[obj.identifier] = obj;
    }];
    res.requestsMap = map.copy;
    return res;
}

+ (instancetype)any:(NSArray<XKNetworking *> *)requests {
    XKNetworkingContainer *res = XKNetworkingContainer.new;
    res.type = XKNetworkingMergeType_Any;
    NSMutableDictionary *map = NSMutableDictionary.dictionary;
    res.requests = requests ? requests.copy : @[];
    [res.requests enumerateObjectsUsingBlock:^(XKNetworking * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.container = res;
        map[obj.identifier] = obj;
    }];
    res.requestsMap = map.copy;
    return res;
}

+ (instancetype)sequence:(NSArray<XKNetworking *> *)requests {
    XKNetworkingContainer *res = XKNetworkingContainer.new;
    res.type = XKNetworkingMergeType_Sequence;
    NSMutableDictionary *map = NSMutableDictionary.dictionary;
    res.requests = requests ? requests.copy : @[];
    [res.requests enumerateObjectsUsingBlock:^(XKNetworking * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.container = res;
        map[obj.identifier] = obj;
    }];
    res.requestsMap = map.copy;
    return res;
}

- (instancetype)init {
    if (self = [super init]) {
        
        __weak typeof(self) weakself = self;
        
        self.succ = ^(XKNetworkingContainerSucc setter) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__succ = [setter copy];
            return weakself;
        };
        
        self.progress = ^(XKNetworkingContainerProgress setter) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__progress = [setter copy];
            return weakself;
        };
        
        self.failed = ^(XKNetworkingContainerFailed setter) {
            __strong typeof(weakself) strongSelf = weakself;
            strongSelf->__failed = [setter copy];
            return weakself;
        };
        
        self.finaly = ^(XKNetworkingContainerFinaly setter) {
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
    [[XKNetworkingCenter shareManager].tasks addObject:self];
    
    if (self.type == XKNetworkingMergeType_Any ||
        self.type == XKNetworkingMergeType_All) {
        [self.requests enumerateObjectsUsingBlock:^(XKNetworking * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.send();
        }];
    }
    
    else if (self.type == XKNetworkingMergeType_Sequence) {
        self.requests.firstObject.send();
    }
}

- (void)onProgress:(CGFloat)progress task:(XKNetworking *)task {
    self.progressMap[task.identifier] = [[NSNumber alloc] initWithFloat:progress];
    !self->__progress ?: self->__progress(self, self.progressMap);
}

- (void)onSucc:(id)responseObject task:(XKNetworking *)task {
    [self.completedTasks addObject:task.identifier];
    
    self.succMap[task.identifier] = responseObject;
    
    if (self.type == XKNetworkingMergeType_Any) {
        !self->__succ ?: self->__succ(self, self.succMap);
        [self onFinaly];
        return;
    }
    
    if (self.type == XKNetworkingMergeType_All) {
        if (self.completedTasks.count >= self.requests.count) {
            !self->__succ ?: self->__succ(self, self.succMap);
            [self onFinaly];
        }
        return;
    }
    
    if (self.type == XKNetworkingMergeType_Sequence) {
        if (self.completedTasks.count >= self.requests.count) {
            !self->__succ ?: self->__succ(self, self.succMap);
            [self onFinaly];
        } else {
            self.requests[self.completedTasks.count].send();
        }
        return;
    }
}

- (void)onFailed:(NSError *)error task:(XKNetworking *)task {
    [self.completedTasks addObject:task.identifier];
    
    self.errorMap[task.identifier] = error;
    
    if (self.type == XKNetworkingMergeType_Any) {
        if (self.requests.count >= self.completedTasks.count) {
            !self->__failed ?: self->__failed(self, self.errorMap, self.succMap);
            [self finaly];
        }
        return;
    }
    
    if (self.type == XKNetworkingMergeType_All) {
        !self->__failed ?: self->__failed(self, self.errorMap, self.succMap);
        [self onFinaly];
        return;
    }
    
    if (self.type == XKNetworkingMergeType_Sequence) {
        !self->__failed ?: self->__failed(self, self.errorMap, self.succMap);
        [self onFinaly];
        return;
    }
}

- (void)onFinaly {
    !self->__finaly ?: self->__finaly(self, self.errorMap, self.succMap);
    
    [[XKNetworkingCenter shareManager].tasks removeObject:self];
    
    self->__progress = nil;
    self->__succ = nil;
    self->__failed = nil;
    self->__finaly = nil;
}

- (NSMutableDictionary<NSString *,id> *)succMap {
    if (!_succMap) {
        _succMap = NSMutableDictionary.dictionary;
    }
    
    return _succMap;
}

- (NSMutableDictionary<NSString *,NSError *> *)errorMap {
    if (!_errorMap) {
        _errorMap = NSMutableDictionary.dictionary;
    }
    
    return _errorMap;
}

- (NSMutableDictionary<NSString *,NSNumber *> *)progressMap {
    if (!_progressMap) {
        _progressMap = NSMutableDictionary.dictionary;
    }
    
    return _progressMap;
}

- (NSMutableOrderedSet<NSString *> *)completedTasks {
    if (!_completedTasks) {
        _completedTasks = NSMutableOrderedSet.orderedSet;
    }
    
    return _completedTasks;
}

- (NSString *)identifier {
    if (!_identifier) {
        _identifier = NSUUID.UUID.UUIDString;
    }
    
    return _identifier;
}

@end

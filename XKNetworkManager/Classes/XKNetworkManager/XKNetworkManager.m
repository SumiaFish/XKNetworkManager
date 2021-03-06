//
//  XKNetworkManager.m
//  Minshuku
//
//  Created by Nicholas on 16/5/10.
//  Copyright © 2016年 Nicholas. All rights reserved.
//

#import "XKNetworkManager.h"

#define XKWeakSelf __weak typeof(self) weakSelf = self;

@interface XKNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@property (nonatomic, weak) NSURLSessionDataTask *lastGETTask;
@property (nonatomic, weak) NSURLSessionDataTask *lastPOSTTask;

@end

@implementation XKNetworkManager

#pragma mark 单例
+ (instancetype)shareManager {
    static XKNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [XKNetworkManager new];
    });
    return manager;
}
- (instancetype)init {
    if (self = [super init]) {
        
        
        self.sessionManager = [AFHTTPSessionManager manager];
        //    manager.securityPolicy = securityPolicy;
        self.sessionManager.requestSerializer  = [AFHTTPRequestSerializer serializer];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.timeout = 10;
        
        //        NSMutableSet *types = [NSMutableSet setWithSet:self.sessionManager.responseSerializer.acceptableContentTypes];
        //        [types addObjectsFromArray:@[@"application/json", @"text/html", @"text/json", @"image/png", @"text/plain"]];
        //        self.sessionManager.responseSerializer.acceptableContentTypes = types;
    }
    return self;
}

#pragma mark 超时设置
- (void)setTimeout:(NSInteger)timeout {
    _timeout = timeout;
    self.sessionManager.requestSerializer.timeoutInterval = 10.0;
}

#pragma mark 直接拼接参数到域名
+ (NSString *)xk_appendURLWithURLString:(NSString *)urlString parameters:(NSDictionary *)parameters {
    
    if (urlString == nil) {
        return nil;
    }
    
    NSMutableString *imageURL = [[NSMutableString alloc] initWithString:urlString];
    NSInteger index = 0;
    for (NSString *key in parameters.allKeys) {
        
        id value = [parameters valueForKey:key];
        
        index==0 ? [imageURL appendString:@"?"] : [imageURL appendString:@"&"];
        
        [imageURL appendString:key];
        [imageURL appendString:@"="];
        [imageURL appendString:[NSString stringWithFormat:@"%@",value]];
        
        index++;
    }
    return imageURL;
}
#pragma mark 拼接参数
+ (NSString *)xk_appendParameters:(NSDictionary *)parameters {
    NSMutableString *imageURL = [NSMutableString string];
    NSInteger index = 0;
    for (NSString *key in parameters.allKeys) {
        
        id value = [parameters valueForKey:key];
        if (index != 0) {
            [imageURL appendString:@"&"];
        }
        [imageURL appendString:key];
        [imageURL appendString:@"="];
        [imageURL appendString:[NSString stringWithFormat:@"%@",value]];
        
        index++;
    }
    return imageURL;
}
+ (NSString *)xk_appendParameters:(NSDictionary *)parameters keys:(NSArray *)keys {
    NSMutableString *imageURL = [NSMutableString string];
    
    for (int i = 0; i < keys.count; i++) {
        NSString *key   = keys[i];
        id value = parameters[key];
        
        if (i != 0) {
            [imageURL appendString:@"&"];
        }
        [imageURL appendString:key];
        [imageURL appendString:@"="];
        [imageURL appendString:[NSString stringWithFormat:@"%@",value]];
    }
    
    return imageURL;
    
}


#pragma mark - 设置https
- (void)setHttpsCerPath:(NSString *)httpsCerPath {
    _httpsCerPath = httpsCerPath;
    self.sessionManager.securityPolicy = [self _getSecurityPolicy];
}
- (AFSecurityPolicy *)_getSecurityPolicy {
    
    //https
    //    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    NSData * certData =[NSData dataWithContentsOfFile:self.httpsCerPath]; //cerPath
    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    // 是否允许,NO-- 不允许无效的证书
    [securityPolicy setAllowInvalidCertificates:YES];
    [securityPolicy setValidatesDomainName:NO];
    // 设置证书
    [securityPolicy setPinnedCertificates:certSet];
    
    return securityPolicy;
}

#pragma mark - GET
- (NSURLSessionDataTask *)xk_GETRequestWithUrlString:(NSString *)urlString parameters:(id)parameters progress:(void (^)(CGFloat))progress success:(void (^)(NSDictionary *, id, BOOL, NSString *))success failure:(void (^)(NSError *, NSString *, NSInteger))failure {
    
    if (self.baseURL && [urlString containsString:@"http"] == NO) {
        urlString = [self.baseURL stringByAppendingPathComponent:urlString];
    }
    NSLog(@"path: %@\nparameters: %@",urlString,parameters);
    !self.xkConfigSessionManager ?: self.xkConfigSessionManager(self.sessionManager);
    XKWeakSelf
    NSURLSessionDataTask *task = self.lastGETTask = [self.sessionManager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        //上传进度
        if (progress) progress(downloadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        !success ?: success(responseObject, nil, YES, @"");
//        [weakSelf successfulAction:responseObject success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMsg = nil;
        if (error.code == NSURLErrorCannotConnectToHost) errorMsg = @"未能连接到服务器";
        else if (error.code == NSURLErrorTimedOut) errorMsg = @"连接超时";
        else errorMsg = error.localizedDescription;
        if (failure) failure(error,errorMsg,error.code);
        
    }];
    
    return task;
}

#pragma mark - POST
- (NSURLSessionDataTask *)xk_POSTRequestWithUrlString:(NSString *)urlString parameters:(id)parameters progress:(void (^)(CGFloat))progress success:(void (^)(NSDictionary *, id, BOOL, NSString *))success failure:(void (^)(NSError *, NSString *, NSInteger))failure {
    
    if (self.baseURL && [urlString containsString:@"http"] == NO) {
        urlString = [self.baseURL stringByAppendingPathComponent:urlString];
    }
    NSLog(@"path: %@\nparameters: %@",urlString,parameters);
    
    !self.xkConfigSessionManager ?: self.xkConfigSessionManager(self.sessionManager);
    NSURLSessionDataTask *task = self.lastPOSTTask = [self.sessionManager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        if (progress) progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        !success ?: success(responseObject, nil, YES, @"");
//        [self successfulAction:responseObject success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorMsg = nil;
        if (error.code == NSURLErrorCannotConnectToHost) errorMsg = @"未能连接到服务器";
        else if (error.code == NSURLErrorTimedOut) errorMsg = @"连接超时";
        else errorMsg = error.localizedDescription;
        if (failure) failure(error,errorMsg,error.code);
        
    }];
    
    return task;
}

// 外部校验
//- (void)successfulAction:(id)responseObject success:(void (^)(NSDictionary *, id, BOOL, NSString *))success failure:(void (^)(NSError *, NSString *, NSInteger))failure {
    
    
    
//    NSString *message = [responseObject objectForKey:self.messageKey];
//    NSInteger code    = [[responseObject objectForKey:self.codeKey] integerValue];
//    BOOL result       = code == self.successfulCode;
//
//    if (result == NO) {
//
//        if (failure) {
//            failure(nil, message, code);
//        }
//        //未登录
//        if ([[responseObject objectForKey:self.codeKey] integerValue] == self.logoutCode) {
//
//            if (self.xkLoginAction) self.xkLoginAction();
//        }
//        else {
//            if (self.xkReqeustCompletedButFailedAction) self.xkReqeustCompletedButFailedAction(code, message);
//        }
//    }
//    else {
//        if (success) {
//            success(responseObject,[responseObject objectForKey:@"data"],result,message);
//        }
//    }
//}
- (NSURLSessionDataTask *)xk_JsonPostRequestWithUrlString:(NSString *)urlString progress:(void (^)(CGFloat))progress parameters:(id)parameters success:(void (^)(NSDictionary *, id, BOOL, NSString *))success failure:(void (^)(NSError *, NSString *, NSInteger))failure {
    
    if (self.baseURL && [urlString containsString:@"http"] == NO) {
        urlString = [self.baseURL stringByAppendingPathComponent:urlString];
    }
    NSLog(@"path: %@\nparameters: %@",urlString,parameters);
    __weak typeof(self) weakSelf = self;
    
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    !self.xkConfigSessionManager ?: self.xkConfigSessionManager(self.sessionManager);
    
    NSURLSessionDataTask *task = self.lastPOSTTask = [self.sessionManager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        if (progress) progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        weakSelf.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        !success ?: success(responseObject, nil, YES, @"");
//        [weakSelf successfulAction:responseObject success:success failure:failure];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        weakSelf.sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        NSString *errorMsg = nil;
        if (error.code == NSURLErrorCannotConnectToHost) errorMsg = @"未能连接到服务器";
        else if (error.code == NSURLErrorTimedOut) errorMsg = @"连接超时";
        else errorMsg = error.localizedDescription;
        if (failure) failure(error,errorMsg,error.code);
        
    }];
    
    return task;
}

#pragma mark - 取消task
- (void)xk_cancelLastGETTask {
    if (self.lastGETTask) [self.lastGETTask cancel];
}
- (void)xk_cancelLastPOSTTask {
    if (self.lastPOSTTask) [self.lastPOSTTask cancel];
}
- (void)xk_canceAllTask {
    [self.sessionManager.operationQueue cancelAllOperations];
}
#pragma mark - 上传图片
- (NSURLSessionDataTask *)xk_uploadImages:(NSArray *)images toURL:(NSString *)urlString parameters:(id)parameters progress:(void (^)(CGFloat, NSInteger))progress success:(void (^)(id, NSInteger, BOOL))success failure:(void (^)(NSError *, NSInteger))failure {
    
    if (self.baseURL && [urlString containsString:@"http"] == NO) {
        urlString = [self.baseURL stringByAppendingPathComponent:urlString];
    }
    NSLog(@"path: %@\nparameters: %@",urlString,parameters);
    
    !self.xkConfigSessionManager ?: self.xkConfigSessionManager(self.sessionManager);
    return [self _uploadImages:images toURL:urlString parameters:parameters progress:progress success:success failure:failure index:0];
    
}
- (NSURLSessionDataTask *)_uploadImages:(NSArray *)images toURL:(NSString *)urlString parameters:(id)parameters progress:(void (^)(CGFloat progress, NSInteger index))progress success:(void (^)(id responseObject, NSInteger index, BOOL finished))success failure:(void (^)(NSError *error, NSInteger index))failure index:(NSInteger)index {
    
    XKWeakSelf
    NSURLSessionDataTask *task = [self.sessionManager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        id imageData = [images firstObject];
        if ([imageData isKindOfClass:[UIImage class]]) {
            imageData = UIImageJPEGRepresentation(imageData, 0.5);
        }
        [formData appendPartWithFileData:imageData name:@"upload" fileName:@"img_userImage.jpg" mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        if (progress) {
            progress(uploadProgress.fractionCompleted,index);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //请求成功
        if (success) {
            
            success(responseDict,index,images.count == 1);
        }
        if (images.count != 1) {
            
            [weakSelf _uploadImages:[images subarrayWithRange:NSMakeRange(1, images.count-1)] toURL:urlString parameters:parameters progress:progress success:success failure:failure index:(index+1)];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        if (failure) {
            //            failure(error,index);
            if (failure) failure(error,index);
        }
    }];
    
    return task;
}

#pragma mark 批量上传图片
- (NSURLSessionDataTask *)xk_uploadImages:(NSArray *)images toURL:(NSString *)urlString parameters:(id)parameters imageNmaes:(NSArray *)imageNames progress:(void (^)(CGFloat))progress success:(void (^)(NSDictionary *, BOOL, NSString *))success failure:(void (^)(NSError *, NSString *))failure {
    
    if (self.baseURL && [urlString containsString:@"http"] == NO) {
        urlString = [self.baseURL stringByAppendingPathComponent:urlString];
    }
    NSLog(@"path: %@\nparameters: %@",urlString,parameters);
    
    !self.xkConfigSessionManager ?: self.xkConfigSessionManager(self.sessionManager);
    XKWeakSelf
    NSURLSessionDataTask *task = [self.sessionManager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (images.count > 0) {
            
            id firstItem = images.firstObject;
            
            if ([firstItem isKindOfClass:[UIImage class]]) {
                for (int i = 0; i < images.count; i++) {
                    
                    UIImage *image = [images objectAtIndex:i];
                    
                    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
                    [formData appendPartWithFileData:imageData name:imageNames[i] fileName:[imageNames[i] stringByAppendingString:@".jpg"] mimeType:@"image/jpeg"];
                }
            }
            else {
                
                for (int i = 0; i < images.count; i++) {
                    
                    NSData *imageData = [images objectAtIndex:i];
                    
                    [formData appendPartWithFileData:imageData name:imageNames[i] fileName:[imageNames[i] stringByAppendingString:@".jpg"] mimeType:@"image/jpeg"];
                    
                }
            }
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        if (progress) progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code = [responseObject[self.codeKey] integerValue];
        
        if (code == weakSelf.logoutCode) {
            if (weakSelf.xkLoginAction) {
                weakSelf.xkLoginAction();
            }
        }
        //请求成功
        if (success) success(responseObject,code == self.successfulCode,responseObject[self.messageKey]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        NSString *errorMsg = nil;
        if (error.code == NSURLErrorCannotConnectToHost) errorMsg = @"未能连接到服务器";
        else if (error.code == NSURLErrorTimedOut) errorMsg = @"连接超时";
        else errorMsg = error.localizedDescription;
        if (failure) failure(error,errorMsg);
    }];
    
    return task;
}
#pragma mark 上传视频
- (NSURLSessionDataTask *)xk_uploadVideos:(NSArray *)videos toURL:(NSString *)urlString parameters:(id)parameters videoNmaes:(NSArray *)videoNames progress:(void (^)(CGFloat progress))progress success:(void (^)(NSDictionary *responseDict, BOOL result, NSString *message))success failure:(void (^)(NSError *error, NSString *errorMessage))failure {
    
    if (self.baseURL && [urlString containsString:@"http"] == NO) {
        urlString = [self.baseURL stringByAppendingPathComponent:urlString];
    }
    NSLog(@"path: %@\nparameters: %@",urlString,parameters);
    
    !self.xkConfigSessionManager ?: self.xkConfigSessionManager(self.sessionManager);
    XKWeakSelf
    NSURLSessionDataTask *task = [self.sessionManager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (videos.count > 0) {
            
            for (int i = 0; i < videos.count; i++) {
                
                NSData *videoData = [NSData dataWithContentsOfFile:videos[i]];
                
                [formData appendPartWithFileData:videoData name:videoNames[i] fileName:[videoNames[i] stringByAppendingString:@".mp4"] mimeType:@"application/octet-stream"];
                
            }
            
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //打印下上传进度
        if (progress) progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSInteger code = [responseObject[self.codeKey] integerValue];
        
        if (code == weakSelf.logoutCode) {
            if (weakSelf.xkLoginAction) {
                weakSelf.xkLoginAction();
            }
        }
        //请求成功
        if (success) success(responseObject,code == self.successfulCode,responseObject[self.messageKey]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        NSString *errorMsg = nil;
        if (error.code == NSURLErrorCannotConnectToHost) errorMsg = @"未能连接到服务器";
        else if (error.code == NSURLErrorTimedOut) errorMsg = @"连接超时";
        else errorMsg = error.localizedDescription;
        if (failure) failure(error,errorMsg);
    }];
    
    return task;
}

@end

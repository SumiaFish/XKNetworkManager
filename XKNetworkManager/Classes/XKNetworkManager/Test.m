//
//  Test.m
//  XKNetworkManager
//
//  Created by Mac on 1/4/21.
//

#import "Test.h"

#import "XKNetworking.h"

@implementation Test

- (void)todo {
    XKNetworking.new
        .url(@"")
        .methond(@(XKNetworkingMethond_GET))
        .params(@{})
        .retry(@(1))
        .interceptor(^BOOL(NSString * _Nonnull url, NSDictionary * _Nonnull params) {
            return YES;
        })
        .willSend(^(NSString * _Nonnull url, NSDictionary * _Nonnull params) {
            
        })
        .progress(^(CGFloat progress, NSURLSessionDataTask * _Nonnull task) {
            
        })
        .handleResponse(^NSError * _Nullable(id  _Nonnull response, NSURLSessionDataTask * _Nonnull task) {
            return nil;
        })
        .succ(^(id  _Nonnull response, NSURLSessionDataTask * _Nonnull task) {
            
        })
        .failed(^(NSError * _Nonnull error, NSURLSessionDataTask * _Nonnull task) {
            
        })
        .finaly(^(NSError * _Nullable error, id  _Nullable response, NSURLSessionDataTask * _Nonnull task) {
            
        })
        .send();
    
    XKNetworking *x1 = XKNetworking.new;
    x1.url(@"https://www.baidu.com")
    .succ(^(id  _Nonnull response, NSURLSessionDataTask * _Nonnull task) {
        NSLog(@"succ: %@", task.originalRequest.URL.absoluteString);
    });
    
    XKNetworking *x2 = XKNetworking.new;
    x2.url(@"https://sina.cn")
    .succ(^(id  _Nonnull response, NSURLSessionDataTask * _Nonnull task) {
        NSLog(@"succ: %@", task.originalRequest.URL.absoluteString);
    });
    
//    XKNetworking *x3 = XKNetworking.new;
//    x3.url(@"https://sina11111.cn")
//    .succ(^(id  _Nonnull response, NSURLSessionDataTask * _Nonnull task) {
//        NSLog(@"succ: %@", task.originalRequest.URL.absoluteString);
//    })
//    .failed
    
    XKNetworkingContainer *container = [XKNetworkingContainer all:@[x1, x2]];
    container.succ(^(NSDictionary<NSString *,id> * _Nonnull responseMap) {
        NSLog(@"succ: %@", responseMap);
    });
}

@end

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
    XKNetworking.new.url(@"")
        .params(@{})
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
}

@end

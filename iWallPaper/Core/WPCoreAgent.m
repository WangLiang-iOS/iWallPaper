//
//  WPCoreAgent.m
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import "WPCoreAgent.h"
#import "WPDevice.h"
#import "WPNetworkOperation.h"
#import "WPURLType.h"
#import "ASIHTTPRequest.h"

@interface WPCoreAgent()
@property(nonatomic,strong)WPNetworkOperation *networkOp;
@end
static NSObject *lockSuccess = nil;
static NSObject *lockFailed = nil;
@implementation WPCoreAgent
+(WPCoreAgent*)sharedInstance{
    static WPCoreAgent *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(id)init{
    if (self = [super init]) {
        _covers = nil;
        _networkOp = [[WPNetworkOperation alloc] init];
        _requestQueue = [[NSOperationQueue alloc] init];
        //3g信号只允许并发2个连接
        _requestQueue.maxConcurrentOperationCount = 2;
        lockSuccess = [[NSObject alloc] init];
        lockFailed = [[NSObject alloc] init];
    }
    return self;
}
-(void)startWork{
    Device_type d_type = [UIDevice deviceType];
    NSString *downloadUrl = nil;
    switch (d_type) {
        case IPhone4:
            downloadUrl = kDownloadUrlByiP4;
            break;
        case IPhone5:
            downloadUrl = kDownloadUrlByiP5;
            break;
        case IPhone6:
            downloadUrl = kDownloadUrlByiP6;
            break;
        case IPhone6p:
            downloadUrl = kDownloadUrlByiP6s;
            break;
        default:
            break;
    }
    if (downloadUrl) {
        //start download from url
        [self.networkOp downloadRequest:downloadUrl onSuccessed:^(NSString *Identifer,NSString *url,NSData *data){
            //parse html from data
            
        }onFailed:^(NSString *Identifer,NSString *url,NSError *error){
            
        }progress:^(double progress){
            
        }];
    }
}
//请确保正确使用参数index,大于0小于等于30，30是根据网页定制的，最多就只有30页，超过30返回最后一页的数据
- (void)requestData:(URLType)urlType pageIndex:(NSUInteger)index onSuccessed:(WPRequestSuccessedBlock)successedBlock onFailed:(WPRequestFailedBlock)failedBlock progress:(WPProgressBlock)pgBlock {
    Device_type d_type = [UIDevice deviceType];
    NSString *preDownloadUrl = nil;
    NSString *subDownloadUrl = nil;
    NSString *downloadUrl = nil;
    switch (d_type) {
        case IPhone4:
            preDownloadUrl = kDownloadUrlByiP4;
            break;
        case IPhone5:
            preDownloadUrl = kDownloadUrlByiP5;
            break;
        case IPhone6:
            preDownloadUrl = kDownloadUrlByiP6;
            break;
        case IPhone6p:
            preDownloadUrl = kDownloadUrlByiP6s;
            break;
        default:
            preDownloadUrl = kDownloadUrlByiP4;
            break;
    }
    switch (urlType) {
        case URLTypeNewest:
            subDownloadUrl = [NSString stringWithFormat:@"%d.html",index];
            break;
        case URLTypeHotest:
            subDownloadUrl = [NSString stringWithFormat:@"hot_%d.html",index];
            break;
        case URLTypeRandom:
            subDownloadUrl = [NSString stringWithFormat:@"good_%d.html",index];
            break;
        default:
            break;
    }
    if (preDownloadUrl && subDownloadUrl) {
        downloadUrl = [NSString stringWithFormat:@"%@%@",preDownloadUrl,subDownloadUrl];
    }

    NSURL *URL = [NSURL URLWithString:downloadUrl];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    request.tag = 0; //0 for requesting for cover data
    request.userInfo =  [[NSDictionary alloc] initWithObjectsAndKeys:successedBlock, @"success", failedBlock, @"failed", pgBlock, @"progress", nil];
    [request setDelegate:self];
//    [request startAsynchronous];
    //request is subclass of NSOperation
    [self.requestQueue addOperation:request];
}
- (void)requestData:(NSString *)url onSuccessed:(WPRequestSuccessedBlock)successedBlock onFailed:(WPRequestFailedBlock)failedBlock progress:(WPProgressBlock)pgBlock {
    NSURL *URL = [NSURL URLWithString:url];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:URL];
    request.tag = 1; //1 for requesting for pages url data
    request.userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:successedBlock, @"success", failedBlock, @"failed", pgBlock, @"progress", nil];
    [request setDelegate:self];
//    [request startAsynchronous];
    //request is subclass of NSOperation
    [self.requestQueue addOperation:request];
}
#pragma market - ASIHTTPRequest Delgate
- (void)requestFinished:(ASIHTTPRequest *)request{
    @synchronized(lockSuccess) {
        int status = [request responseStatusCode];
        if (status == 200) {
            WPRequestSuccessedBlock successedBlock = [request.userInfo objectForKey:@"success"];
            if (successedBlock) {
                successedBlock(request.url.absoluteString, request.responseString);
            }
        } else {
            WPRequestFailedBlock failedBlock = [request.userInfo objectForKey:@"failed"];
            if (failedBlock) {
                failedBlock(request.url.absoluteString, request.error);
            }
        }
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    @synchronized(lockFailed) {
        NSError *error = [request error];
        NSLog(@"request failed error:%@",error);
        WPRequestFailedBlock failedBlock = [request.userInfo objectForKey:@"failed"];
        if (failedBlock) {
            failedBlock(request.url.absoluteString, error);
        }
    }
}
@end

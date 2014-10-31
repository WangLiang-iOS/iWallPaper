//
//  WPNetworkOperation.m
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import "WPHttpTransfer.h"
#import "MKNetworkEngine.h"

@interface WPHttpTransfer ()
@property(nonatomic,strong)MKNetworkEngine *engine;
@property(nonatomic,strong)NSMutableDictionary *allOperations;
@end
@implementation WPHttpTransfer

-(id)init{
    if (self = [super init]) {
        _engine = [[MKNetworkEngine alloc] init];
        _allOperations = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)dealloc{
    _engine = nil;
    [_allOperations removeAllObjects];
}

-(NSString *) downloadRequest:(NSString *) url
                  onSuccessed:(WPRequestSuccessedBlock) successedBlock
                     onFailed:(WPRequestFailedBlock) failedBlock
                     progress:(WPProgressBlock) pgBlock{
    if ([url length] == 0) {
        return nil;
    }
    NSString *identity = [url md5];
    __weak typeof(self) wSelf = self;
    MKNetworkOperation *operation = [self.engine operationWithURLString:url];
    [operation addCompletionHandler:^(MKNetworkOperation* completedOperation){
        if (successedBlock) {
            successedBlock(completedOperation.url,[completedOperation responseData]);
        }
        [wSelf _removeRequest:completedOperation];
    }errorHandler:^(MKNetworkOperation* completedOperation, NSError* error){
        if (failedBlock) {
            failedBlock(completedOperation.url,error);
        }
        [wSelf _removeRequest:completedOperation];
    }];
    
    if (pgBlock) {
        [operation onDownloadProgressChanged:^(double progress){
            pgBlock(progress);
        }];
    }
    
    [self _addRequest:operation];
    [self.engine enqueueOperation:operation];
    return identity;
}


-(void) cancelAll{
    for (MKNetworkOperation *operation in self.allOperations) {
        [operation cancel];
    }
    [self.allOperations removeAllObjects];
}

-(void) cancelIdentity:(NSString *) identity{
    if ([identity length]) {
        MKNetworkOperation *operation = [self.allOperations objectForKey:identity];
        if (operation) {
            [operation cancel];
            [self.allOperations removeObjectForKey:identity];
        }
    }
}

-(void)_addRequest:(MKNetworkOperation*)op{
    @synchronized(self){
        if (op && [op.url length]) {
            [self.allOperations setObject:op forKey:[op.url md5]];
        }
    }
}

-(void)_removeRequest:(MKNetworkOperation*)op{
    @synchronized(self){
        if (op && [op.url length]) {
            [self.allOperations removeObjectForKey:[op.url md5]];
        }
    }
}
@end

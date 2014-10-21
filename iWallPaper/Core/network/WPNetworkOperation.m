//
//  WPNetworkOperation.m
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import "WPNetworkOperation.h"
#import "MKNetworkEngine.h"

@implementation WPNetworkOperation

-(id)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(NSString *) downloadRequest:(NSString *) url
                  onSuccessed:(WPDataSuccessedBlock) successedBlock
                     onFailed:(WPDataFailedBlock) failedBlock
                     progress:(WPProgressBlock) pgBlock{
    NSString *identity = [url md5];
    return identity;
}

-(void) cancelAll{
    
}
-(void) cancelIdentity:(NSString *) identity{
    
}
@end

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
@interface WPCoreAgent()
@property(nonatomic,strong)WPNetworkOperation *networkOp;
@end

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
@end

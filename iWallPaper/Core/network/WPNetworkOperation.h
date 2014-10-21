//
//  WPNetworkOperation.h
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WPDataSuccessedBlock) (NSString *Identifer,NSString *url,NSData *data);
typedef void (^WPDataFailedBlock) (NSString *Identifer,NSString *url,NSError *error);
typedef void (^WPProgressBlock) (double progress);

@interface WPNetworkOperation : NSObject
-(NSString *) downloadRequest:(NSString *) url
                  onSuccessed:(WPDataSuccessedBlock) successedBlock
                     onFailed:(WPDataFailedBlock) failedBlock
                     progress:(WPProgressBlock) pgBlock;
-(void) cancelAll;
-(void) cancelIdentity:(NSString *) identity;
@end

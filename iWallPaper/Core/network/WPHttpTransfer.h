//
//  WPHttpTransfer.h
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^WPRequestSuccessedBlock) (NSString *url,NSData *responseData);
typedef void (^WPRequestFailedBlock) (NSString *url,NSError *error);
typedef void (^WPProgressBlock) (double progress);

@interface WPHttpTransfer : NSObject
-(NSString *) downloadRequest:(NSString *) url
                  onSuccessed:(WPRequestSuccessedBlock) successedBlock
                     onFailed:(WPRequestFailedBlock) failedBlock
                     progress:(WPProgressBlock) pgBlock;
-(void) cancelAll;
-(void) cancelIdentity:(NSString *) identity;
@end

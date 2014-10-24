//
//  WPCoreAgent.h
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPCoverModel.h"
#import "WPURLType.h"
typedef void (^WPRequestSuccessedBlock) (NSString *url,NSString *responseString);
typedef void (^WPRequestFailedBlock) (NSString *url,NSError *error);
typedef void (^WPProgressBlock) (double progress);
@interface WPCoreAgent : NSObject
@property (nonatomic,strong,readonly)WPCoverModel *covers;
@property (nonatomic,strong) NSOperationQueue *requestQueue;
+(WPCoreAgent*)sharedInstance;
-(void)startWork;
//根据url的类型和指定页面索引申请数据
- (void)requestData:(URLType)urlType
          pageIndex:(NSUInteger)index
        onSuccessed:(WPRequestSuccessedBlock) successedBlock
           onFailed:(WPRequestFailedBlock) failedBlock
           progress:(WPProgressBlock) pgBlock;
// 根据指定cover获得图片地址
- (void)requestData:(NSString *)url
        onSuccessed:(WPRequestSuccessedBlock) successedBlock
           onFailed:(WPRequestFailedBlock) failedBlock
           progress:(WPProgressBlock) pgBlock;
@end

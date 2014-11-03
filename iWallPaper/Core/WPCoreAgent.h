//
//  WPCoreAgent.h
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPCoverModel.h"

typedef enum {
    CoverType_Unknown = 0,
    CoverType_Newest,
    CoverType_Hotest,
    CoverType_Random
}WPCoverType;

typedef void (^WPGetCoversCompletionBlock) (NSArray *covers,NSError *error,WPCoverType type);
typedef void (^WPGetImageCompletionBlock) (UIImage *image,NSError *error);
typedef void (^WPGetImageProgressBlock) (double progress);

@interface WPCoreAgent : NSObject
+(WPCoreAgent*)sharedInstance;

-(void)getCoversWithType:(WPCoverType)coverType index:(int)index completion:(WPGetCoversCompletionBlock)completionBlock;

-(void)getImageWithUrl:(NSString*)url cover:(WPCoverModel*)cover completion:(WPGetImageCompletionBlock)completionBlock progress:(WPGetImageProgressBlock)progressBlock;

@end

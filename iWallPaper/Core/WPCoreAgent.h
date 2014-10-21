//
//  WPCoreAgent.h
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPCoverModel.h"

@interface WPCoreAgent : NSObject
@property(nonatomic,strong,readonly)WPCoverModel *covers;

+(WPCoreAgent*)sharedInstance;
-(void)startWork;
@end

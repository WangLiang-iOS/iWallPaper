//
//  WPCoverViewController.h
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/29.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import "WPBaseViewController.h"
#import "WPCoreAgent.h"

@interface WPCoverViewController : WPBaseViewController
@property (assign, nonatomic) int pageIndex;
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL isLastPage;
- (id)initWithCoverType:(WPCoverType)coverType;
@end

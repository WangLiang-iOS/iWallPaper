//
//  WPBaseViewController.h
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPCoreAgent.h"
#import "WPParser.h"
#import "WPCoverModel.h"
#import "WPPaperItem.h"
@interface WPBaseViewController : UIViewController
@property (strong, nonatomic) NSMutableArray *allCovers;
@property (assign, nonatomic) NSUInteger pageIndex;
@property BOOL isLoading;
@property BOOL isLastPage;
@end

//
//  WPBaseViewController.m
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import "WPBaseViewController.h"

@implementation WPBaseViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.allCovers = [[NSMutableArray alloc] init];
    self.pageIndex = 1;
    self.isLoading = NO;
    self.isLastPage = NO;
}

@end

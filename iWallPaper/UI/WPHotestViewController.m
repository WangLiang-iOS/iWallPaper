//
//  WPHotestViewController.m
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import "WPHotestViewController.h"
#import "WPTableViewController.h"

@interface WPHotestViewController ()
@property(nonatomic,strong)WPTableViewController *listView;
@end

@implementation WPHotestViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData{
    if (self.isLoading || self.isLastPage) {
        return;
    }
    if (self.pageIndex > 0) {
        self.isLoading = YES;
        WPCoreAgent *agent = [WPCoreAgent sharedInstance];
        __weak typeof(self) wself = self;
        [agent requestData:URLTypeHotest
                 pageIndex:wself.pageIndex
               onSuccessed:^(NSString *url, NSString *responseString) {
                   wself.isLoading = NO;
                   wself.pageIndex += 1;
                   if (wself.pageIndex > kDownloadMaxPages) {
                       wself.isLastPage = YES;
                   }
                   NSMutableArray *covers = [WPParser getAllCovers:responseString];
                   for (WPCoverModel *cover in covers) {
                       [wself.allCovers addObject:cover];
                       NSLog(@"hotest----%@",cover.title);
                       //去加载图片信息
                       [self loadPagesForCover:cover];
                   }
                   //刷新ui
               }
                  onFailed:^(NSString *url, NSError *error) {
                      wself.isLoading = NO;
                  }
                  progress:^(double progress) {
                      
                  }];
    }
}
- (void)loadPagesForCover:(WPCoverModel *)cover {
    if (cover != nil) {
        WPCoreAgent *agent = [WPCoreAgent sharedInstance];
        NSMutableArray *papers = [[NSMutableArray alloc] init];
        [agent requestData:cover.contentUrl
               onSuccessed:^(NSString *url, NSString *responseString) {
                   NSMutableArray *pictures = [WPParser getAllPictures:responseString];
                   for (NSString *pictureUrl in pictures) {
                       WPPaperItem *paper = [[WPPaperItem alloc] init];
                       paper.originalUrl = pictureUrl;
                       [papers addObject:paper];
                   }
                   cover.paperItems = papers;
               }
                  onFailed:^(NSString *url, NSError *error) {
                      
                  }
                  progress:^(double progress) {
                      
                  }];
    }
}
@end

//
//  WPMainViewController.m
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import "WPMainViewController.h"
#import "WPPageContainer.h"
#import "WPCoverViewController.h"

@interface WPMainViewController ()
@property(nonatomic,strong)WPPageContainer *pageContainer;
@end

@implementation WPMainViewController

- (void)loadView{
    [super loadView];
    self.pageContainer = [[WPPageContainer alloc] init];
    [self.pageContainer willMoveToParentViewController:self];
    self.pageContainer.pageItemsTitleColor = [UIColor blackColor];
    self.pageContainer.topBarBackgroundColor = WPColor(0xf7, 0xf7, 0xf7);
    self.pageContainer.selectedPageItemColor = [UIColor colorWithRed:0/255.f green:122/255.f blue:255/255.f alpha:1.f];
    self.pageContainer.pageIndicatorColor = [UIColor colorWithRed:0/255.f green:122/255.f blue:255/255.f alpha:1.f];
    self.pageContainer.topBarItemLabelsFont = [UIFont systemFontOfSize:15.];
    [self.pageContainer didMoveToParentViewController:self];
    [self.view addSubview:self.pageContainer.view];
    

    WPCoverViewController *newestVC = [[WPCoverViewController alloc] initWithCoverType:CoverType_Newest];
    newestVC.title = @"最新";
    WPCoverViewController *hotestVC = [[WPCoverViewController alloc] initWithCoverType:CoverType_Hotest];
    hotestVC.title = @"最热";
    WPCoverViewController *randomVC = [[WPCoverViewController alloc] initWithCoverType:CoverType_Random];
    randomVC.title = @"随机";
    self.pageContainer.viewControllers = @[newestVC,hotestVC,randomVC];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = WPColor(0xf7, 0xf7, 0xf7);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

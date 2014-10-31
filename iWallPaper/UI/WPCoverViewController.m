//
//  WPCoverViewController.m
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/29.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import "WPCoverViewController.h"
#import "WPCoverCell.h"
#import "WPPhotosViewController.h"
#import "AppDelegate.h"
#import "SVPullToRefresh.h"

@interface WPCoverViewController ()<UITableViewDataSource,UITableViewDelegate,WPCoverCellDelegate>
@property(nonatomic,strong)NSMutableArray *allCovers;
@property(nonatomic,strong)UITableView *coverTableView;
@property(nonatomic,strong)NSMutableArray *cellDatas;
@property(nonatomic,assign)WPCoverType coverType;
@property(nonatomic,assign)BOOL isPushing;
@end


@implementation WPCoverViewController
- (id)initWithCoverType:(WPCoverType)coverType{
    if (self = [super init]) {
        _pageIndex = 1;
        _isLoading = NO;
        _isLastPage = NO;
        _isPushing = NO;
        _allCovers = [NSMutableArray array];
        _coverType = coverType;
        _cellDatas = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect rt = self.view.frame;
    rt.size.height -= kTopBarHeight + PHONE_STATUSBAR_HEIGHT;
    _coverTableView = [[UITableView alloc] initWithFrame:rt style:UITableViewStylePlain];
    _coverTableView.backgroundColor = [UIColor clearColor];
    _coverTableView.dataSource = self;
    _coverTableView.delegate = self;
    _coverTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_coverTableView];
    
    __weak WPCoverViewController *weakSelf = self;
    
    [self.coverTableView addPullToRefreshWithActionHandler:^{
        [weakSelf _loadTopData];
    }];
    
    [self.coverTableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf _loadMoreData];
    }];
    [self.coverTableView triggerPullToRefresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.isPushing = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cellDatas count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentify = @"WPCoverCellIdentify";
    WPCoverCell *coverCell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!coverCell) {
        coverCell = [[WPCoverCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
        coverCell.selectionStyle = UITableViewCellSelectionStyleNone;
        coverCell.delegate = self;
    }
    [coverCell setCovers:[self.cellDatas objectAtIndex:indexPath.row]];
    return coverCell;
}


-(void)didSelectedCell:(WPCoverCell *)cell cover:(WPCoverModel *)cover{
    if (self.isPushing) {
        return;
    }
    self.isPushing = YES;
    WPPhotosViewController *photosVC = [[WPPhotosViewController alloc] init];
    photosVC.coverTitle = cover.title;
    [((AppDelegate*)[UIApplication sharedApplication].delegate).rootNavigation pushViewController:photosVC animated:YES];
}
#pragma mark - private methods
-(void)_refreshView{
    [self.cellDatas removeAllObjects];
    int row = 0;
    int rowItems = 2;
    if ([self.allCovers count] % rowItems == 0) {
        row = (int)[self.allCovers count] / rowItems;
    }else{
        row = (int)[self.allCovers count] / rowItems + 1;
    }
    for (int i = 0; i < row; i++) {
        int count = rowItems;
        if ([self.allCovers count] - rowItems*i == 1) {
            count--;
        }
        [self.cellDatas addObject:[self.allCovers subarrayWithRange:NSMakeRange(i*2, count)]];
    }
    [self.coverTableView reloadData];
}


-(void)_loadTopData{
    if (self.isLoading) {
        return;
    }
    self.pageIndex = 1;
    [self _loadData];
}

-(void)_loadMoreData{
    if (self.isLoading || self.isLastPage) {
        return;
    }
    [self _loadData];
}

- (void)_loadData{
    if (self.pageIndex > 0) {
        self.isLoading = YES;
        __weak typeof(self) wself = self;
        [[WPCoreAgent sharedInstance] getCoversWithType:self.coverType index:self.pageIndex completion:^(NSArray *covers,NSError *error,WPCoverType type){
            wself.isLoading = NO;
            if (!error && type == wself.coverType) {
                if (wself.pageIndex == 1) {
                    [wself.allCovers removeAllObjects];
                }
                wself.pageIndex += 1;
                if (wself.pageIndex > kDownloadMaxPages) {
                    wself.isLastPage = YES;
                }
                [wself.allCovers addObjectsFromArray:covers];
                
                if ([wself.allCovers count] > 0) {
                    [wself _refreshView];
                }
            }
            
            [wself.coverTableView.pullToRefreshView stopAnimating];
        }];
    }
}
@end

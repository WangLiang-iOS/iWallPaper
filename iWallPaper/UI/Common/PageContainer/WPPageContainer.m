//
//  WPPageContainer.m
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import "WPPageContainer.h"
#import "WPPageTopBar.h"
#import "WPPageIndicatorView.h"
//#define TABBAR_HEIGHT_IPHONE 49

@interface WPPageContainer ()<UIScrollViewDelegate,WPPageTopBarDelelgate>
@property (strong, nonatomic) WPPageTopBar *topBar;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak,   nonatomic) UIScrollView *observingScrollView;
@property (strong, nonatomic) WPPageIndicatorView *pageIndicatorView;
@property (assign, nonatomic) BOOL shouldObserveContentOffset;
@property (assign, nonatomic) CGFloat scrollWidth;
@property (assign, nonatomic) CGFloat scrollHeight;
- (void)layoutSubviews;
- (void)startObservingContentOffsetForScrollView:(UIScrollView *)scrollView;
- (void)stopObservingContentOffset;
@end

@implementation WPPageContainer
- (id)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)dealloc
{
    [self stopObservingContentOffset];
    self.scrollView = nil;
    self.topBar = nil;
    self.pageIndicatorView = nil;
}

// default
- (void)setUp
{
    _topBarHeight = kTopBarHeight;
    _topBarBackgroundColor = [UIColor colorWithWhite:0.9 alpha:1.];
    _topBarItemLabelsFont = [UIFont systemFontOfSize:12];
    _pageIndicatorViewSize = CGSizeMake(17., 2.);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.shouldObserveContentOffset = YES;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.,self.topBarHeight+PHONE_STATUSBAR_HEIGHT,self.view.bounds.size.width,self.view.bounds.size.height - self.topBarHeight-PHONE_STATUSBAR_HEIGHT)];
    self.scrollView.autoresizingMask = UIViewAutoresizingNone;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.scrollView];
    
    [self startObservingContentOffsetForScrollView:self.scrollView];
    
    // top bar
    self.topBar = [[WPPageTopBar alloc] initWithFrame:CGRectMake(0.,PHONE_STATUSBAR_HEIGHT,self.view.bounds.size.width,self.topBarHeight)];
    self.topBar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    self.topBar.delegate = self;
    [self.view addSubview:self.topBar];
    
    // indicator
    self.pageIndicatorView = [[WPPageIndicatorView alloc] initWithFrame:CGRectMake(0.,
                                                                                   self.topBarHeight-self.pageIndicatorViewSize.height+PHONE_STATUSBAR_HEIGHT,
                                                                                   self.pageIndicatorViewSize.width,
                                                                                   self.pageIndicatorViewSize.height)];
    [self.view addSubview:self.pageIndicatorView];
    self.topBar.backgroundColor = self.topBarBackgroundColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutSubviews];
}

#pragma mark - Public

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated
{
    UIButton *previosSelectdItem = self.topBar.itemsView[self.selectedIndex];
    UIButton *nextSelectdItem = self.topBar.itemsView[selectedIndex];
    if (abs((int)(self.selectedIndex - selectedIndex)) <= 1) {
        [self.viewControllers[self.selectedIndex] resignFirstResponder];
        //        [self.scrollView setContentOffset:CGPointMake(selectedIndex * self.scrollWidth, 0.) animated:animated];
        if (selectedIndex == _selectedIndex) {
            self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:selectedIndex].x,self.pageIndicatorView.center.y);
        }
        [UIView animateWithDuration:(animated) ? 0.3 : 0. delay:0. options:UIViewAnimationOptionBeginFromCurrentState animations:^
         {
             [self.scrollView setContentOffset:CGPointMake(selectedIndex * self.scrollWidth, 0.)];
             [previosSelectdItem setTitleColor:self.pageItemsTitleColor forState:UIControlStateNormal];
             [nextSelectdItem setTitleColor:self.selectedPageItemColor forState:UIControlStateNormal];
         } completion:^(BOOL finished) {
             self.scrollView.userInteractionEnabled = YES;
             //             [self.scrollView setContentOffset:CGPointMake(selectedIndex * self.scrollWidth, 0.)];
         }];
    } else {
        // This means we should "jump" over at least one view controller
        [self.viewControllers[self.selectedIndex] resignFirstResponder];
        self.shouldObserveContentOffset = NO;
        BOOL scrollingRight = (selectedIndex > self.selectedIndex);
        UIViewController *leftViewController = self.viewControllers[MIN(self.selectedIndex, selectedIndex)];
        UIViewController *rightViewController = self.viewControllers[MAX(self.selectedIndex, selectedIndex)];
        leftViewController.view.frame = CGRectMake(0., 0., self.scrollWidth, self.scrollView.frame.size.height);
        rightViewController.view.frame = CGRectMake(self.scrollWidth, 0., self.scrollWidth, self.scrollView.frame.size.height);
        self.scrollView.contentSize = CGSizeMake(2 * self.scrollWidth, self.scrollView.frame.size.height);
        
        CGPoint targetOffset;
        if (scrollingRight) {
            self.scrollView.contentOffset = CGPointZero;
            targetOffset = CGPointMake(self.scrollWidth, 0.);
        } else {
            self.scrollView.contentOffset = CGPointMake(self.scrollWidth, 0.);
            targetOffset = CGPointZero;
            
        }
        [self.scrollView setContentOffset:targetOffset animated:YES];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:selectedIndex].x,
                                                        self.pageIndicatorView.center.y);
            self.topBar.scrollView.contentOffset = [self.topBar contentOffsetForSelectedItemAtIndex:selectedIndex];
            [previosSelectdItem setTitleColor:self.pageItemsTitleColor forState:UIControlStateNormal];
            [nextSelectdItem setTitleColor:self.selectedPageItemColor forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            for (NSUInteger i = 0; i < self.viewControllers.count; i++) {
                UIViewController *viewController = self.viewControllers[i];
                viewController.view.frame = CGRectMake(i * self.scrollWidth, 0., self.scrollWidth, self.scrollView.frame.size.height);
                [self.scrollView addSubview:viewController.view];
            }
            self.scrollView.contentSize = CGSizeMake(self.scrollWidth * self.viewControllers.count, self.scrollView.frame.size.height);
            [self.scrollView setContentOffset:CGPointMake(selectedIndex * self.scrollWidth, 0.) animated:NO];
            self.scrollView.userInteractionEnabled = YES;
            self.shouldObserveContentOffset = YES;
        }];
    }
    _selectedIndex = selectedIndex;
}

#pragma mark -- setters --

- (void)setPageIndicatorViewSize:(CGSize)size
{
    if (!CGSizeEqualToSize(self.pageIndicatorView.frame.size, size)) {
        _pageIndicatorViewSize = size;
        [self layoutSubviews];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setTopBarBackgroundColor:(UIColor *)topBarBackgroundColor
{
    _topBarBackgroundColor = topBarBackgroundColor;
    self.topBar.backgroundColor = topBarBackgroundColor;
}

- (void)setPageIndicatorColor:(UIColor *)pageIndicatorColor
{
    self.pageIndicatorView.bgColor = pageIndicatorColor;
}

- (void)setSelectedPageItemColor:(UIColor *)selectedPageItemColor
{
    _selectedPageItemColor = selectedPageItemColor;
}

- (void)setPageItemsTitleColor:(UIColor *)pageItemsTitleColor
{
    _pageItemsTitleColor = pageItemsTitleColor;
    self.topBar.titleColor = pageItemsTitleColor;
}

- (void)setTopBarHeight:(NSUInteger)topBarHeight
{
    if (_topBarHeight != topBarHeight) {
        _topBarHeight = topBarHeight;
        [self layoutSubviews];
    }
}

- (void)setTopBarItemLabelsFont:(UIFont *)font
{
    self.topBar.titleFont = font;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    if (_viewControllers != viewControllers) {
        _viewControllers = viewControllers;
        self.topBar.itemsTitle = [viewControllers valueForKey:@"title"];
        CGFloat x =0 ;
        for (UIViewController *viewController in viewControllers) {
            [viewController willMoveToParentViewController:self];
            viewController.view.frame = CGRectMake(x, 0., CGRectGetWidth(self.scrollView.frame), self.scrollHeight);
            x += CGRectGetWidth(self.scrollView.frame);
            [self.scrollView addSubview:viewController.view];
            [viewController didMoveToParentViewController:self];
        }
        self.scrollView.contentSize = CGSizeMake(x, self.scrollHeight);
        [self layoutSubviews];
        self.selectedIndex = 0;
        self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x,
                                                    self.pageIndicatorView.center.y);
    }
}

#pragma mark - Private

- (void)layoutSubviews
{
    self.topBar.frame = CGRectMake(0., PHONE_STATUSBAR_HEIGHT, CGRectGetWidth(self.view.bounds), self.topBarHeight);
    UIButton *btn = [self.topBar.itemsView objectAtIndex:self.selectedIndex];
    self.pageIndicatorView.frame = CGRectMake(0.,
                                              self.topBarHeight-self.pageIndicatorViewSize.height+PHONE_STATUSBAR_HEIGHT,
                                              btn.frame.size.width,
                                              self.pageIndicatorViewSize.height);
    
    [self.scrollView setContentOffset:CGPointMake(self.selectedIndex * self.scrollWidth, 0.) animated:YES];
    self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x, self.pageIndicatorView.center.y);
    
    self.topBar.scrollView.contentOffset = [self.topBar contentOffsetForSelectedItemAtIndex:self.selectedIndex];
    self.scrollView.userInteractionEnabled = YES;
}

- (CGFloat)scrollHeight
{
    return self.view.frame.size.height - self.topBarHeight-PHONE_STATUSBAR_HEIGHT;
}

- (CGFloat)scrollWidth
{
    return self.scrollView.frame.size.width;
}

- (void)startObservingContentOffsetForScrollView:(UIScrollView *)scrollView
{
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    self.observingScrollView = scrollView;
}

- (void)stopObservingContentOffset
{
    if (self.observingScrollView) {
        [self.observingScrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.observingScrollView = nil;
    }
}

#pragma mark - TopBar delegate
- (void)itemAtIndex:(NSUInteger)index didSelectedAtFTPageIndicatorTopBar:(WPPageTopBar *)bar
{
    [self setSelectedIndex:index animated:YES];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.selectedIndex = scrollView.contentOffset.x / self.scrollView.frame.size.width;
    self.scrollView.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        self.selectedIndex = scrollView.contentOffset.x / self.scrollView.frame.size.width;
        self.scrollView.userInteractionEnabled = YES;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.scrollView.userInteractionEnabled = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.scrollView.userInteractionEnabled = NO;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    CGFloat oldX = self.selectedIndex * self.scrollView.frame.size.width;
    if (oldX != self.scrollView.contentOffset.x && self.shouldObserveContentOffset) {
        BOOL scrollingTowards = (self.scrollView.contentOffset.x > oldX);
        NSInteger targetIndex = (scrollingTowards) ? self.selectedIndex + 1 : self.selectedIndex - 1;
        if (targetIndex >= 0 && targetIndex < self.viewControllers.count) {
            
            // scroll
            CGFloat ratio = self.scrollView.frame.size.width != 0 ? (self.scrollView.contentOffset.x - oldX) / self.scrollView.frame.size.width : 0;
            CGFloat previousItemPageIndicatorX = [self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x;
            CGFloat nextItemPageIndicatorX = [self.topBar centerForSelectedItemAtIndex:targetIndex].x;
            
            // set title color.
            UIButton *previousSelectedItem = self.topBar.itemsView[self.selectedIndex];
            UIButton *nextSelectedItem = self.topBar.itemsView[targetIndex];
            [previousSelectedItem setTitleColor:self.selectedPageItemColor forState:UIControlStateNormal];
            [nextSelectedItem setTitleColor:self.pageItemsTitleColor forState:UIControlStateNormal];
            
            if (scrollingTowards) {
                self.pageIndicatorView.center = CGPointMake(previousItemPageIndicatorX +
                                                            (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,
                                                            self.pageIndicatorView.center.y);
                
            } else {
                self.pageIndicatorView.center = CGPointMake(previousItemPageIndicatorX -
                                                            (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,
                                                            self.pageIndicatorView.center.y);
            }
        }
    }
}
@end

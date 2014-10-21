//
//  WPPageTopBar.m
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import "WPPageTopBar.h"

#define ItemOffset 5.

@interface WPPageTopBar ()
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSArray *itemsView;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,assign) BOOL isPreviousActionCompleted;
-(UIButton *) _addItemView;
-(void)_layoutItemViews;
@end

@implementation WPPageTopBar
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleFont = [UIFont systemFontOfSize:14.f];
        _titleColor = [UIColor grayColor];
        _lineColor = WPColorA(0xb2, 0xb2, 0xb2,0.6);
        _lineHeight = 1.0;
        [self addSubview:self.scrollView];
        [self addSubview:self.lineView];
        _isPreviousActionCompleted = YES;
    }
    return self;
}

- (void)setItemsTitle:(NSArray *)itemsTitle
{
    if (_itemsTitle != itemsTitle) {
        _itemsTitle = itemsTitle;
        NSMutableArray *mutableItemViews = [NSMutableArray arrayWithCapacity:itemsTitle.count];
        for (NSUInteger i = 0; i < itemsTitle.count; i++) {
            UIButton *itemView = [self _addItemView];
            [itemView setTitle:itemsTitle[i] forState:UIControlStateNormal];
            [mutableItemViews addObject:itemView];
            [self.scrollView addSubview:itemView];
        }
        self.itemsView = [NSArray arrayWithArray:mutableItemViews];
        [self _layoutItemViews];
    }
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if (![_titleFont isEqual:titleFont]) {
        _titleFont = titleFont;
        for (UIButton *itemView in self.itemsView) {
            [itemView.titleLabel setFont:titleFont];
        }
    }
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    for (UIButton *btn in self.itemsView) {
        [btn.titleLabel setTextColor:titleColor];
        [btn.titleLabel setNeedsDisplay];
    }
}

-(void)setLineColor:(UIColor *)lineColor
{
    if (![_lineColor isEqual:lineColor]) {
        _lineColor = lineColor;
        self.lineView.backgroundColor = lineColor;
    }
}

-(void)setLineHeight:(CGFloat)lineHeight
{
    if (_lineHeight != lineHeight) {
        _lineHeight = lineHeight;
        CGRect rect = self.lineView.frame;
        rect.origin.y = self.bounds.size.height - lineHeight;
        rect.size.height = lineHeight;
        self.lineView.frame = rect;
    }
}

-(void)_layoutItemViews
{
    CGFloat x = 0;
    CGFloat iWidth = self.itemsView.count > 0? CGRectGetWidth(self.frame) / self.itemsView.count : 0;
    for (NSUInteger i = 0; i < self.itemsView.count; i++) {
        CGFloat width = [self.itemsTitle[i] sizeWithFont:self.titleFont].width;
        width = width > iWidth ? width : iWidth;
        UIView *itemView = self.itemsView[i];
        itemView.frame = CGRectMake(x, 0., width, CGRectGetHeight(self.frame));
        x += width;
    }
    self.scrollView.contentSize = CGSizeMake(x, self.scrollView.frame.size.height);
    CGRect frame = self.scrollView.frame;
    if (CGRectGetWidth(self.frame) > x) {
        frame.origin.x = (CGRectGetWidth(self.frame) - x) / 2.;
        frame.size.width = x;
    } else {
        frame.origin.x = 0.;
        frame.size.width = CGRectGetWidth(self.frame);
    }
    self.scrollView.frame = frame;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self _layoutItemViews];
}


- (CGPoint)centerForSelectedItemAtIndex:(NSUInteger)index
{
    CGPoint center = ((UIView *)self.itemsView[index]).center;
    //    CGPoint offset = [self contentOffsetForSelectedItemAtIndex:index];
    //    center.x -= offset.x - (CGRectGetMinX(self.scrollView.frame));
    return center;
}

- (CGPoint)contentOffsetForSelectedItemAtIndex:(NSUInteger)index
{
    if (self.itemsView.count < index || self.itemsView.count == 1) {
        return CGPointZero;
    } else {
        CGFloat totalOffset = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
        return CGPointMake(index * totalOffset / (self.itemsView.count - 1), 0.);
    }
}

#pragma mark -- subview --

-(UIView *) lineView
{
    if (!_lineView) {
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - self.lineHeight;
        rect.size.height = self.lineHeight;
        _lineView = [[UIView alloc] initWithFrame:rect];
        _lineView.backgroundColor = self.lineColor;
    }
    return _lineView;
}

-(UIButton *) _addItemView
{
    UIButton *itemView = [[UIButton alloc] init];
    [itemView addTarget:self action:@selector(itemViewAction:) forControlEvents:UIControlEventTouchUpInside];
    itemView.titleLabel.font = self.titleFont;
    [itemView setTitleColor:self.titleColor forState:UIControlStateNormal];
    return itemView;
}

- (UIScrollView *) scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.showsVerticalScrollIndicator = NO;
#if UIAUTOMATION
        [_scrollView setIsAccessibilityElement:NO];
        [_scrollView setAccessibilityLabel:@"topTabBar"];
#endif
    }
    return _scrollView;
}

#pragma mark -- action --

-(void) itemViewAction:(id) sender
{
    if (!self.isPreviousActionCompleted) {
        return;
    }
    self.isPreviousActionCompleted = NO;
    int64_t delta = 300 * NSEC_PER_MSEC;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, delta);
    dispatch_after(when, dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(itemAtIndex:didSelectedAtFTPageIndicatorTopBar:)]) {
            [self.delegate itemAtIndex:[self.itemsView indexOfObject:sender] didSelectedAtFTPageIndicatorTopBar:self];
        }
        self.isPreviousActionCompleted = YES;
    });
}
@end

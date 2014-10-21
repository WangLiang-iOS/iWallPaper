//
//  WPPageTopBar.h
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPPageTopBar;
@protocol WPPageTopBarDelelgate <NSObject>
-(void) itemAtIndex:(NSUInteger) index didSelectedAtFTPageIndicatorTopBar:(WPPageTopBar *) bar;
@end

@interface WPPageTopBar : UIView
@property (nonatomic,strong) NSArray *itemsTitle;
@property (nonatomic,strong) UIFont  *titleFont;
@property (nonatomic,strong) UIColor *titleColor;
@property (nonatomic,strong) UIColor *bgColor;
@property (nonatomic,weak) id<WPPageTopBarDelelgate> delegate;
@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,assign) CGFloat lineHeight;
@property (nonatomic,strong,readonly) UIScrollView *scrollView;
@property (nonatomic,strong,readonly) NSArray *itemsView;

- (CGPoint)centerForSelectedItemAtIndex:(NSUInteger)index;
- (CGPoint)contentOffsetForSelectedItemAtIndex:(NSUInteger)index;

@end

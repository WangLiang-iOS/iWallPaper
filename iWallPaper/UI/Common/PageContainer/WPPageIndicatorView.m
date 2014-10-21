//
//  WPPageIndicatorView.m
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import "WPPageIndicatorView.h"

@implementation WPPageIndicatorView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        _bgColor = [UIColor grayColor];  // default
    }
    return self;
}

- (void)setBgColor:(UIColor *)bgColor
{
    if (![_bgColor isEqual:bgColor]) {
        _bgColor = bgColor;
        [self setNeedsLayout];
    }
}

-(void) layoutSubviews
{
    self.backgroundColor = self.bgColor;
}
@end

//
//  WPCoverItemView.m
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/30.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import "WPCoverItemView.h"
#define kImageViewMargin 8.f
#define kLabelHeight  15.f
@interface WPCoverItemView ()
@property(nonatomic,strong)UIImageView *coverImageView;
@property(nonatomic,strong)UILabel *coverTitleLable;
@end

@implementation WPCoverItemView
-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        _coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageViewMargin, kImageViewMargin, frame.size.width - 2*kImageViewMargin, frame.size.height - 2*kImageViewMargin)];
        _coverImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_coverImageView];
//        _coverTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, _coverImageView.frame.size.height-kLabelHeight, _coverImageView.frame.size.width, kLabelHeight)];
//        _coverTitleLable.textAlignment = NSTextAlignmentCenter;
//        _coverTitleLable.backgroundColor = [UIColor whiteColor];
//        _coverTitleLable.textColor = [UIColor blackColor];
//        [_coverImageView addSubview:_coverTitleLable];
    }
    return self;
}

-(void)dealloc{
    self.delegate = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//-(void)setTitle:(NSString *)title{
//    _coverTitleLable.text = title;
//}

-(void)setImage:(UIImage *)image{
    _coverImageView.image = image;
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedItem:)]) {
        [self.delegate didSelectedItem:self];
    }
}
@end

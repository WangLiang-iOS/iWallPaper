//
//  WPCoverCell.m
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/29.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import "WPCoverCell.h"
#import "WPCoverItemView.h"
#import "WPCoreAgent.h"
@interface WPCoverCell()<WPCoverItemViewDelegate>
@property(nonatomic,strong)NSMutableArray *itemViews;
@end

@implementation WPCoverCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.userInteractionEnabled = NO;
        _itemViews = [NSMutableArray arrayWithCapacity:2];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self _layoutViews];

}
-(void)setCovers:(NSArray*)covers{
    _covers = covers;
}

-(void)_layoutViews{
    for (WPCoverItemView *itemView in self.itemViews) {
        itemView.hidden = YES;
    }
    for (int i = 0; i < [self.covers count]; i++) {
        WPCoverModel *cover = [self.covers objectAtIndex:i];
        WPCoverItemView *itemView = nil;
        if (i < [self.itemViews count]) {
            itemView = [self.itemViews objectAtIndex:i];
        }
        if (!itemView) {
            itemView = [[WPCoverItemView alloc] initWithFrame:CGRectMake(i*self.frame.size.width/2.f, 0, self.frame.size.width/2.f, self.frame.size.height)];
            itemView.delegate = self;
            [self addSubview:itemView];
            [self.itemViews addObject:itemView];
        }
//        itemView.title = cover.title;
        itemView.image = nil;
        if (cover.coverImage) {
            itemView.image = cover.coverImage;
        }else{
            [[WPCoreAgent sharedInstance] getImageWithUrl:cover.coverUrl cover:cover completion:^(UIImage *image,NSError *error){
                    if (image && !error) {
                        itemView.image = image;
                        NSLog(@"%f,%f",image.size.width,image.size.height);
                    }
            }
            progress:nil];
        }
        itemView.index = i;
        itemView.hidden = NO;
    }
}
-(void)didSelectedItem:(WPCoverItemView *)itemView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedCell:cover:)]) {
        [self.delegate didSelectedCell:self cover:[self.covers objectAtIndex:itemView.index]];
    }
}
@end

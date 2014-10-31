//
//  WPCoverItemView.h
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/30.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPCoverItemView;
@protocol WPCoverItemViewDelegate <NSObject>
-(void)didSelectedItem:(WPCoverItemView*)itemView;
@end

@interface WPCoverItemView : UIView
@property(nonatomic,weak)id<WPCoverItemViewDelegate> delegate;
@property(nonatomic,strong)UIImage *image;
//@property(nonatomic,strong)NSString *title;
@property(nonatomic,assign)int index;
@end

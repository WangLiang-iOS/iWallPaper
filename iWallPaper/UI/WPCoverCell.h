//
//  WPCoverCell.h
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/29.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPCoverModel.h"

@class WPCoverCell;
@protocol WPCoverCellDelegate <NSObject>
-(void)didSelectedCell:(WPCoverCell*)cell cover:(WPCoverModel*)cover;
@end

@interface WPCoverCell : UITableViewCell
@property(nonatomic,strong)NSArray* covers;
@property(nonatomic,weak)id<WPCoverCellDelegate> delegate;
@end

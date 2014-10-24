//
//  WPCoverModel.h
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPPaperItem.h"

@interface WPCoverModel : NSObject
@property(nonatomic)id coverId;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *coverUrl;
@property(nonatomic,strong)UIImage *coverImage;
@property(nonatomic,strong)NSString *contentUrl; //used for getting all pictures url of this cover
@property(nonatomic,strong)NSArray *paperItems; //WPPaperItem objects
@end

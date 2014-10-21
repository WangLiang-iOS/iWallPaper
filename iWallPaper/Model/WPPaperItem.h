//
//  WPPaperItem.h
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPPaperItem : NSObject
@property(nonatomic)id itemId;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *thumbUrl;
@property(nonatomic,strong)UIImage *thumbImage;
@property(nonatomic,strong)NSString *originalUrl;
@property(nonatomic,strong)UIImage *originalImage;
@end

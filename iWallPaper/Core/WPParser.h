//
//  WPParser.h
//  iWallPaper
//
//  Created by 孙世文 on 14-10-23.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WPParser : NSObject
//得到一页壁纸的信息,一页有15张专辑
+ (NSArray *)getAllCovers:(NSData *)htmlData;
//得到指定壁纸的所有图片
+ (NSArray *)getAllPictures:(NSData *)htmlData;
@end

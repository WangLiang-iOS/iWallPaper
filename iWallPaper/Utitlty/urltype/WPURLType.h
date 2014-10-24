//
//  WPURLType.h
//  iWallPaper
//
//  Created by 孙世文 on 14-10-23.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    URLTypeUnknown = 0,
    URLTypeNewest,
    URLTypeHotest,
    URLTypeRandom
}URLType;
@interface WPURLType : NSObject

@end

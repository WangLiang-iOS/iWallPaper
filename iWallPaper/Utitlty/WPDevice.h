//
//  WPDevice.h
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    Device_Unkown = 0,
    IPhone4,
    IPhone5,
    IPhone6,
    IPhone6p
}Device_type;

@interface UIDevice(Ext)
+(Device_type) deviceType;
@end

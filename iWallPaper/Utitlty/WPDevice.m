//
//  WPDevice.m
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import "WPDevice.h"
#include <sys/utsname.h>
#include <sys/param.h>
#include <sys/mount.h>

@implementation UIDevice (Ext)
+(Device_type) deviceType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    Device_type type = Device_Unkown;
    if ([deviceString isEqualToString:@"iPhone4,1"] ||
        [deviceString isEqualToString:@"iPhone3,1"])
        type = IPhone4;
    else if ([deviceString isEqualToString:@"iPhone5,2"] ||
             [deviceString isEqualToString:@"iPod5,1"])
        type = IPhone5;
    else if ([deviceString isEqualToString:@"iPhone6,1"])
        type = IPhone6;
    else if ([deviceString isEqualToString:@"iPhone7,1"])
        type = IPhone6p;

    return type;
}
@end

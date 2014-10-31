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

static Device_type sDeviceType = Device_Unkown;
+(Device_type) deviceType
{
    @synchronized(self) {
        if(sDeviceType == Device_Unkown) {
            Device_type type = Device_Unkown;
            struct utsname systemInfo;
            uname(&systemInfo);
            NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
            if ([deviceString isEqualToString:@"iPhone3,1"] ||
                [deviceString isEqualToString:@"iPhone4,1"]){
                type = IPhone4;
            }else if ([deviceString isEqualToString:@"iPod5,1"] ||
                       [deviceString isEqualToString:@"iPhone5,2"] ||
                       [deviceString isEqualToString:@"iPhone5,4"] ||
                       [deviceString isEqualToString:@"iPhone6,2"]) {
                type = IPhone5;
            } else if ([deviceString isEqualToString:@"iPhone7,1"]) {
                type = IPhone6p;
            } else if ([deviceString isEqualToString:@"iPhone7,2"]) {
                type = IPhone6;
            }
            sDeviceType = type;
        }
    }
    return sDeviceType;
}
@end

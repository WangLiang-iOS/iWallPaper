//
//  WPGlobalDefine.h
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#ifndef iWallPaper_WPGlobalDefine_h
#define iWallPaper_WPGlobalDefine_h

#define kDownloadUrlByiP4 @"http://sj.zol.com.cn/bizhi/640x960/"
#define kDownloadUrlByiP5 @"http://sj.zol.com.cn/bizhi/640x1136/"
#define kDownloadUrlByiP6 @"http://sj.zol.com.cn/bizhi/750x1334/"
#define kDownloadUrlByiP6s @"http://sj.zol.com.cn/bizhi/1080x1980/"
#define kDownloadHostUrl @"http://sj.zol.com.cn"

#define kDownloadMaxPages 30

#define WPColor(r,g,b) WPColorA(r,g,b,1.f)
#define WPColorA(r,g,b,a) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

#endif

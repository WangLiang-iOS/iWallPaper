//
//  WPParser.m
//  iWallPaper
//
//  Created by 孙世文 on 14-10-23.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import "WPParser.h"
#import "TFHpple.h"
#import "WPCoverModel.h"
#import "WPDevice.h"
@implementation WPParser
+ (NSMutableArray *)getAllCovers:(NSString *)htmlString{
    if (htmlString == nil){
        return nil;
    } else{
        //gbk编码解析
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //        NSData *htmlData = [response dataUsingEncoding:NSUTF8StringEncoding];
        
        NSData *htmlData = [htmlString dataUsingEncoding:gbkEncoding];
        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
        NSArray *elements  = [xpathParser searchWithXPathQuery:@"/html/body/div[5]/div[1]/ul[1]//li/a"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for(int i=0;i<[elements count];i++){
            TFHppleElement *element = [elements objectAtIndex:i];
            NSString *href = [element objectForKey:@"href"];
            NSString *title = [element objectForKey:@"title"];
            //            NSLog(@"%@---%@", href,title);
            WPCoverModel *cover = [[WPCoverModel alloc] init];
            cover.title = title;
            cover.contentUrl = [NSString stringWithFormat:@"%@%@",kDownloadHostUrl,href];
            TFHppleElement *img = [element firstChild];
            if ([[img tagName] isEqualToString:@"img"]) {//第一个标签是img
                cover.coverUrl = [img objectForKey:@"src"];
                //                NSLog(@"cover:%@",album.cover);
            }
            [array addObject:cover];
        }
        return array;
    }
}
+ (NSMutableArray *)getAllPictures:(NSString *)htmlString{
    if (htmlString == nil){
        return nil;
    } else{
        //gbk编码解析
        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        //        NSData *htmlData = [response dataUsingEncoding:NSUTF8StringEncoding];
        
        NSData *htmlData = [htmlString dataUsingEncoding:gbkEncoding];
        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
        NSArray *elements  = [xpathParser searchWithXPathQuery:@"//*[@id=\"showImg\"]//li/a/img"];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSLog(@"count = %d",[elements count]);
        Device_type d_type = [UIDevice deviceType];
        NSString *currentSize = nil;
        switch (d_type) {
            case IPhone4:
                currentSize = @"640x960";
                break;
            case IPhone5:
                currentSize = @"640x1136";
                break;
            case IPhone6:
                currentSize = @"750x1134";
                break;
            case IPhone6p:
                currentSize = @"1080x1980";
                break;
            default:
                currentSize = @"640x960";
                break;
        }
        for(int i=0;i<[elements count];i++){
            TFHppleElement *element = [elements objectAtIndex:i];
            NSString *src = [element objectForKey:@"srcs"];
            if (src == nil) {
                src = [element objectForKey:@"src"];
            }
            //根据给定url获得的图片url路径中包含120x90，
            //例如“http://b.zol-img.com.cn/sjbizhi/images/7/120x90/14138767668.jpg”
            //替换成当前设备的尺寸，有可能没有对应尺寸的图片
            src = [src stringByReplacingOccurrencesOfString:@"120x90" withString:currentSize];
            [array addObject:src];
        }
        
        return array;
    }
}
@end

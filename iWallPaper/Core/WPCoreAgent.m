//
//  WPCoreAgent.m
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/21.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import "WPCoreAgent.h"
#import "WPDevice.h"
#import "WPHttpTransfer.h"
#import "WPParser.h"
@interface WPCoreAgent()
@property(nonatomic,strong)WPHttpTransfer *httpTransfer;
-(NSString*)_coverUrlWithType:(WPCoverType)coverType index:(int)index;
@end

@implementation WPCoreAgent
+(WPCoreAgent*)sharedInstance{
    static WPCoreAgent *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(id)init{
    if (self = [super init]) {
        _httpTransfer = [[WPHttpTransfer alloc] init];
    }
    return self;
}


-(void)getCoversWithType:(WPCoverType)coverType index:(int)index completion:(WPGetCoversCompletionBlock)completionBlock{
    NSString *coverUrl = [self _coverUrlWithType:coverType index:index];
    NSLog(@"%@",coverUrl);
    [self.httpTransfer downloadRequest:coverUrl onSuccessed:^(NSString *url,NSData *responeData){
        if ([responeData length] > 0) {
            NSArray *covers = [WPParser getAllCovers:responeData];
            if ([covers count] > 0) {
                dispatch_async(dispatch_get_global_queue(0, 0), ^(){
                    for (WPCoverModel *cover in covers) {
                        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:cover.contentUrl]];
                        if ([data length] > 0) {
                            cover.paperItems = [WPParser getAllPictures:data];
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        if (completionBlock) {
                            completionBlock(covers,nil,coverType);
                        }
                    });
                });
            }

        }
    }onFailed:^(NSString *url,NSError *error){
        if (completionBlock) {
            completionBlock(nil,error,coverType);
        }
    }progress:nil];
}

-(void)getImageWithUrl:(NSString*)url cover:(WPCoverModel*)cover completion:(WPGetImageCompletionBlock)completionBlock progress:(WPGetImageProgressBlock)progressBlock{
    if ([url length]) {
        [self.httpTransfer downloadRequest:url onSuccessed:^(NSString *url,NSData *responeData){
            if ([responeData length] > 0) {
                UIImage *image = [UIImage imageWithData:responeData];
                if (image) {
                    if (cover) {
                        cover.coverImage = image;
                    }
                    if (completionBlock) {
                        completionBlock(image,nil);
                    }
                }
            }
        }onFailed:^(NSString *url,NSError *error){
            if (completionBlock) {
                completionBlock(nil,error);
            }
        }progress:progressBlock];
    }
}

#pragma mark - private methods
-(NSString*)_coverUrlWithType:(WPCoverType)coverType index:(int)index{
    Device_type d_type = [UIDevice deviceType];
    NSString *preDownloadUrl = nil;
    NSString *subDownloadUrl = nil;
    NSString *downloadUrl = nil;
    
    switch (d_type) {
        case IPhone4:
            preDownloadUrl = kDownloadUrlByiP4;
            break;
        case IPhone5:
            preDownloadUrl = kDownloadUrlByiP5;
            break;
        case IPhone6:
            preDownloadUrl = kDownloadUrlByiP6;
            break;
        case IPhone6p:
            preDownloadUrl = kDownloadUrlByiP6s;
            break;
        default:
            preDownloadUrl = kDownloadUrlByiP4;
            break;
    }
    switch (coverType) {
        case CoverType_Newest:
            subDownloadUrl = [NSString stringWithFormat:@"%d.html",index];
            break;
        case CoverType_Hotest:
            subDownloadUrl = [NSString stringWithFormat:@"hot_%d.html",index];
            break;
        case CoverType_Random:
            subDownloadUrl = [NSString stringWithFormat:@"good_%d.html",index];
            break;
        default:
            break;
    }
    
    if ([preDownloadUrl length] && [subDownloadUrl length]) {
        downloadUrl = [NSString stringWithFormat:@"%@%@",preDownloadUrl,subDownloadUrl];
    }
    
    return downloadUrl;
}

@end

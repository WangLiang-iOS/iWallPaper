//
//  WPPhotosViewController.m
//  iWallPaper
//
//  Created by wangliang-ms on 14/10/30.
//  Copyright (c) 2014年 Noname. All rights reserved.
//

#import "WPPhotosViewController.h"
#import "WPCoreAgent.h"
#import "MBProgressHUD.h"

@interface UIScrollView (WPPhotosScrollView)
@end

@implementation UIScrollView (WPPhotosScrollView)
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!self.dragging)
    {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
}
@end

@interface WPPhotosViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *photosScrollView;
@end

@implementation WPPhotosViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.navigationController setNavigationBarHidden:NO];
    self.title = self.coverTitle;
    self.photosScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.photosScrollView.delegate = self;
    self.photosScrollView.pagingEnabled = YES;
    self.photosScrollView.bounces = NO;
    self.photosScrollView.showsHorizontalScrollIndicator = NO;
    self.photosScrollView.showsVerticalScrollIndicator = NO;
    self.photosScrollView.contentSize = CGSizeMake(self.view.frame.size.width*[self.photos count], self.view.frame.size.height);
    self.photosScrollView.userInteractionEnabled = YES;
    [self.view addSubview:self.photosScrollView];
    
    for (int i = 0; i < [self.photos count]; i++) {
        id photo = [self.photos objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
        imageView.backgroundColor = [UIColor clearColor];
        if ([photo isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage*)photo;
            imageView.image = image;
        }else if([photo isKindOfClass:[NSString class]]){
            MBRoundProgressView *hud = [[MBRoundProgressView alloc] init];
            hud.progress = 0.0;
            hud.center = imageView.center;
            [imageView addSubview:hud];
            [[WPCoreAgent sharedInstance] getImageWithUrl:(NSString*)photo cover:nil completion:^(UIImage *image,NSError *error){
                if (image && !error) {
                    imageView.image = image;
                }
                [hud removeFromSuperview];
            }progress:^(double progress){
                hud.progress = progress;
                NSLog(@"%@ %f",photo,progress);
            }];
        }
        [self.photosScrollView addSubview:imageView];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.navigationController setNavigationBarHidden:![self.navigationController isNavigationBarHidden] animated:YES];
}
@end

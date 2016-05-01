//
//  LXGallery.m
//  Foundation
//
//  Created by Dotton on 16/5/1.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//



#import "LXGallery.h"
#import "UIImageView+AFNetworking.h"
#import "AJPhotoBrowserViewController.h"
#import "Global.h"
#import "ImageBrowserViewController.h"

@implementation LXGallery

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
//- (void)drawRect:(CGRect)rect {
//    [super drawRect:rect];
//    // Drawing code
////    self.backgroundColor = [UIColor whiteColor];
//    [self reloadImagesList];
//}

//刷新图集
- (void)reloadImagesList {
    CGRect frame = CGRectMake(0, 0, IMAGE_WIDTH, IMAGE_WIDTH);
//    self.urlArray = [self.urlStr componentsSeparatedByString:@","];
    for (int i = 0 ; i < self.urlArray.count; i++) {
        frame.origin.x = i % 4 * IMAGE_WIDTH + 5;
        frame.origin.y = i / 4 * IMAGE_WIDTH + 5;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        imageView.clipsToBounds = YES;
        NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,self.urlArray[i]];
        [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"app_loading_img_big.png"]];
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBig:)]];
        [self addSubview:imageView];
    }
    CGRect rect = self.frame;
    rect.size.height = (self.urlArray.count / 4 + 1) * IMAGE_WIDTH_WITH_PADDING;
    self.frame = rect;
//    [self.tableView reloadData];
}

//查看大图
- (void)showBig:(UITapGestureRecognizer *)sender {
//    NSInteger index = sender.view.tag;
//    AJPhotoBrowserViewController *photoBrowserViewController = [[AJPhotoBrowserViewController alloc] initWithPhotos:self.photos index:index];
//    photoBrowserViewController.delegate = self;
//    [self.vc presentViewController:photoBrowserViewController animated:YES completion:nil];
    
    ImageBrowserViewController *vc = [[ImageBrowserViewController alloc] init];
    vc.imageArray = self.urlArray;
    vc.selectedIndex = 0;
    self.vc.hidesBottomBarWhenPushed = YES;
    [self.vc.navigationController pushViewController:vc animated:YES];
    self.vc.hidesBottomBarWhenPushed = NO;
}
@end

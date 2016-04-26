//
//  LXPageController.m
//  Foundation
//
//  Created by Dotton on 16/4/26.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "LXPageController.h"

@interface LXPageController ()

@end

@implementation LXPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    //后退按钮标题与按钮图片
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    UIImage *backBarItemImage = [[UIImage imageNamed:@"arrow_left"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [backItem setBackButtonBackgroundImage:backBarItemImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
}

@end

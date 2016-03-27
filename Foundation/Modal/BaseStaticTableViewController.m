//
//  BaseTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseStaticTableViewController.h"

@interface BaseStaticTableViewController ()

@end

@implementation BaseStaticTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(-36.0, 0, 0, 0);
    self.service = [HttpService getInstance];
    //后退按钮标题与按钮图片
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    UIImage *backBarItemImage = [[UIImage imageNamed:@"arrow_left"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [backItem setBackButtonBackgroundImage:backBarItemImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)viewWillAppear:(BOOL)animated {
//    self.tabBarController.tabBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

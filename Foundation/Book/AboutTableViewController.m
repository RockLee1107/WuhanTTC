//
//  AboutTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "AboutTableViewController.h"
#import "SubTabBarController.h"

@interface AboutTableViewController ()

@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ((SubTabBarController *)self.tabBarController).specialName;

    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

//回到主页
- (IBAction)goBack:(id)sender {
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}


@end

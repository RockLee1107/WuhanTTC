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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleBordered) target:self action:@selector(edit:)];
}

- (void)edit:(UIBarButtonItem *)item {
    UITableViewController *vc = (UITableViewController *)self.currentViewController;
    vc.editing = !vc.editing;
}
@end

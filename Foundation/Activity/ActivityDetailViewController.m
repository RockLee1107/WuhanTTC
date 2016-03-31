//
//  ActivityDetailViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/31.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityDetailTableViewController.h"
#import "DTKDropdownMenuView.h"

@interface ActivityDetailViewController ()

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightItem];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ActivityDetailTableViewController *vc = segue.destinationViewController;
    vc.activityId = self.activityId;
}

- (IBAction)joinButtonPress:(id)sender {
    [SVProgressHUD showErrorWithStatus:@"请先登录"];
}

///导航栏下拉菜单
- (void)addRightItem
{
    //    __weak typeof(self) weakSelf = self;
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"关注" iconName:@"menu_collect.png" callBack:^(NSUInteger index, id info) {
    }];
    
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 60.f, 44.f) dropdownItems:@[item0] icon:@"ic_menu"];
    menuView.cellColor = MAIN_COLOR;
    menuView.cellHeight = 50.0;
    menuView.dropWidth = 150.f;
    menuView.titleFont = [UIFont systemFontOfSize:18.f];
    menuView.textColor = [UIColor whiteColor];
    menuView.cellSeparatorColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    menuView.textFont = [UIFont systemFontOfSize:16.f];
    menuView.animationDuration = 0.4f;
    menuView.backgroundAlpha = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuView];
}

@end

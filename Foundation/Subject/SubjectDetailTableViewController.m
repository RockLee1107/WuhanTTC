//
//  SubjectDetailTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "SubjectDetailTableViewController.h"
#import "DTKDropdownMenuView.h"

@interface SubjectDetailTableViewController ()

@end

@implementation SubjectDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightItem];
    // Do any additional setup after loading the view.
}

///导航栏下拉菜单
- (void)addRightItem
{
    //    __weak typeof(self) weakSelf = self;
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"举报" iconName:@"menu_report" callBack:^(NSUInteger index, id info) {
        [SVProgressHUD showSuccessWithStatus:@"^_^"];
    }];
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"只看楼主" iconName:@"menu_auther" callBack:^(NSUInteger index, id info) {
        [SVProgressHUD showSuccessWithStatus:@"^_^"];
    }];
    DTKDropdownItem *item2 = [DTKDropdownItem itemWithTitle:@"回复" iconName:@"menu_reply" callBack:^(NSUInteger index, id info) {
        [SVProgressHUD showSuccessWithStatus:@"^_^"];
    }];
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 60.f, 44.f) dropdownItems:@[item0,item1,item2] icon:@"ic_menu"];
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

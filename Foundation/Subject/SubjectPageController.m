//
//  MyProjectViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

/***创成长->社区***/

#import "SubjectPageController.h"
#import "SubjectListViewController.h"
#import "DTKDropdownMenuView.h"
#import "SubTabBarController.h"
#import "PostSubjectTableViewController.h"
#import "MySubjectPageController.h"

@interface SubjectPageController ()

@end

@implementation SubjectPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = ((SubTabBarController *)self.tabBarController).specialName;
    [self addRightItem];
    // Do any additional setup after loading the view.
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSArray *viewControllerClasses = @[
                                           [SubjectListViewController class],
                                           [SubjectListViewController class],
                                           [SubjectListViewController class]
                                           ];
        NSArray *titles = @[
                            @"新帖",
                            @"热门",
                            @"精华"
                            ];
        self.viewControllerClasses = viewControllerClasses;
        self.titles = titles;
        self.menuItemWidth = SCREEN_WIDTH / titles.count;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleSizeSelected = 15.0;
        self.titleColorSelected = MAIN_COLOR;
        //为不同页面设置相对应的标签，每一个key对应一个values
                self.keys = @[
                              @"condition",
                              @"condition",
                              @"condition"
                              ];
                self.values = @[
                                @"createdDate,createdTime",
                                @"replyCount",
                                @"createdDate,createdTime|1"
                                ];
    }
    return self;
}

//回到主页
- (IBAction)goBack:(id)sender {
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

///导航栏下拉菜单
- (void)addRightItem
{
    //    __weak typeof(self) weakSelf = self;
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"我的帖子" iconName:@"menu_my_post" callBack:^(NSUInteger index, id info) {
        if ([[User getInstance] isLogin]) {
            UIViewController *vc = [[MySubjectPageController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
            [alertView show];
        }
      

    }];
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"发帖" iconName:@"menu_add" callBack:^(NSUInteger index, id info) {
        if ([[User getInstance] isLogin]) {
            PostSubjectTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"post"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
            [alertView show];
        }

       
    }];
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 60.f, 44.f) dropdownItems:@[item0,item1] icon:@"ic_menu"];
    menuView.cellColor = MENU_COLOR;
    menuView.cellHeight = 50.0;
    menuView.dropWidth = 150.f;
    menuView.titleFont = [UIFont systemFontOfSize:18.f];
    menuView.textColor = [UIColor blackColor];
    menuView.cellSeparatorColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    menuView.textFont = [UIFont systemFontOfSize:16.f];
    menuView.animationDuration = 0.4f;
    menuView.backgroundAlpha = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuView];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        //进入团团创登陆页面
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
}

@end

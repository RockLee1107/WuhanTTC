//
//  MyProjectViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "SubjectPageController.h"
#import "SubjectListViewController.h"
#import "DTKDropdownMenuView.h"
@interface SubjectPageController ()

@end

@implementation SubjectPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的";
#warning subtab
//    subTab
    [self addRightItem];
    // Do any additional setup after loading the view.
}

- (instancetype)init{
    self = [super init];
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
        //        self.keys = @[
        //                      @"key",
        //                      @"key",
        //                      @"key"
        //                      ];
        //        self.values = @[
        //                        @"1",
        //                        @"1",
        //                        @"1"
        //                        ];
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
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"我的帖子" iconName:@"menu_create.png" callBack:^(NSUInteger index, id info) {
        [SVProgressHUD showSuccessWithStatus:@"^_^"];
    }];
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"发帖" iconName:@"menu_my_post.png" callBack:^(NSUInteger index, id info) {
        [SVProgressHUD showSuccessWithStatus:@"^_^"];
    }];
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 60.f, 44.f) dropdownItems:@[item0,item1] icon:@"ic_menu"];
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

//
//  MyProjectViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "MyProjectPageController.h"
#import "MyProjectTableViewController.h"

@interface MyProjectPageController ()

@end

@implementation MyProjectPageController

- (void)viewWillAppear:(BOOL)animated {
    //从项目详情返回到我创建的项目后，将单例置空
    [User getInstance].isCloseItem = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //去掉编辑
    self.navigationItem.rightBarButtonItem = nil;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的项目";
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSArray *viewControllerClasses = @[
                                           [MyProjectTableViewController class],
                                           [MyProjectTableViewController class],
                                           [MyProjectTableViewController class]
                                           ];
        NSArray *titles = @[
                            @"我创建的",
                            @"我参与的",
                            @"我关注的"
                            ];
        self.viewControllerClasses = viewControllerClasses;
        self.titles = titles;
        self.menuItemWidth = SCREEN_WIDTH / titles.count;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleSizeSelected = 15.0;
        self.menuHeight = 50;
        self.titleColorSelected = MAIN_COLOR;
        //为不同页面设置相对应的标签，每一个key对应一个values
        self.keys = @[
                      @"SEQ_queryType",
                      @"SEQ_queryType",
                      @"SEQ_queryType"
                      ];
        self.values = @[
                        @"CREATE",
                        @"JOIN",
                        @"ATTENTION"
                        ];
    }
    return self;
}

@end

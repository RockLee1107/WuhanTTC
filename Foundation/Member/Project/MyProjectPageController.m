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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的项目";
    // Do any additional setup after loading the view.
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSArray *viewControllerClasses = @[
                                           [MyProjectTableViewController class],
                                           [MyProjectTableViewController class],
                                           [MyProjectTableViewController class],
                                           [MyProjectTableViewController class]
                                           ];
        NSArray *titles = @[
                            @"我创建的",
                            @"我参与的",
                            @"我关注的",
                            @"我收到的"
                            ];
        self.viewControllerClasses = viewControllerClasses;
        self.titles = titles;
        self.menuItemWidth = SCREEN_WIDTH / titles.count;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleSizeSelected = 15.0;
        self.titleColorSelected = MAIN_COLOR;
        //为不同页面设置相对应的标签，每一个key对应一个values
        self.keys = @[
                      @"SEQ_queryType",
                      @"SEQ_queryType",
                      @"SEQ_queryType",
                      @"SEQ_queryType"
                      ];
        self.values = @[
                        @"CREATE",
                        @"JOIN",
                        @"ATTENTION",
                        @"RECEIVED"
                        ];
    }
    return self;
}

@end

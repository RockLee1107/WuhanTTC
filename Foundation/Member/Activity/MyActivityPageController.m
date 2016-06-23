//
//  MyProjectViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "MyActivityPageController.h"
#import "MyActivityTableViewController.h"

@interface MyActivityPageController ()

@end

@implementation MyActivityPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的活动";
    // Do any additional setup after loading the view.
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSArray *viewControllerClasses = @[
                                           [MyActivityTableViewController class],
                                           [MyActivityTableViewController class],
                                           [MyActivityTableViewController class]
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
        self.titleColorSelected = MAIN_COLOR;
        self.menuHeight = 50;//标题栏高度
        //为不同页面设置相对应的标签，每一个key对应一个values
        self.keys = @[
                      @"uri",
                      @"uri",
                      @"uri"
                      ];
        self.values = @[
                        @"queryActivityList",
                        @"getApplyActivity",
                        @"getAttentionActivity"
                        ];
    }
    return self;
}

@end

//
//  MySubjectViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "MySubjectPageController.h"
#import "MySubjectTableViewController.h"
#import "MyReplyTableViewController.h"

@interface MySubjectPageController ()

@end

@implementation MySubjectPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的帖子";
    // Do any additional setup after loading the view.
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSArray *viewControllerClasses = @[
                                           [MySubjectTableViewController class],
                                           [MyReplyTableViewController class]
                                           ];
        NSArray *titles = @[
                            @"我发布的",
                            @"我回复的"
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
//                      @"key"
//                      ];
//        self.values = @[
//                        @"1",
//                        @"1"
//                        ];
    }
    return self;
}

@end

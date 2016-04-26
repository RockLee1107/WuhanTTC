//
//  MyNoteViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "MyNotePageController.h"
#import "MyNoteTableViewController.h"
#import "MyNoteByBookTableViewController.h"

@interface MyNotePageController ()

@end

@implementation MyNotePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的笔记";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleBordered) target:self action:@selector(edit:)];
}


- (void)edit:(UIBarButtonItem *)item {
    NSDictionary *info = @{
                           @"target":@"note"
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"editNotifi" object:nil userInfo:info];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSArray *viewControllerClasses = @[
                                           [MyNoteTableViewController class],
                                           [MyNoteByBookTableViewController class]
                                           ];
        NSArray *titles = @[
                            @"按时间",
                            @"按文章"
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

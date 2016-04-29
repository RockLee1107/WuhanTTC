//
//  MessagePageController.m
//  Foundation
//
//  Created by Dotton on 16/4/29.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "MessagePageController.h"
#import "MessageTableViewController.h"

@interface MessagePageController ()

@end

@implementation MessagePageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"消息";
    // Do any additional setup after loading the view.
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSArray *viewControllerClasses = @[
                                           [MessageTableViewController class],
                                           [MessageTableViewController class],
                                           [MessageTableViewController class]
                                           ];
        NSArray *titles = @[
                            @"系统消息",
                            @"收信",
                            @"发信"
                            ];
        self.viewControllerClasses = viewControllerClasses;
        self.titles = titles;
        self.menuItemWidth = SCREEN_WIDTH / titles.count;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleSizeSelected = 15.0;
        self.titleColorSelected = MAIN_COLOR;
        //为不同页面设置相对应的标签，每一个key对应一个values
        self.keys = @[
                      @"SEQ_type",
                      @"SEQ_type",
                      @"SEQ_type"
                      ];
        self.values = @[
                        @"0",
//                        由于收信是toUserId，所以人为地将它的SEQ_type定为-1，在子页中硬编码判断
                        @"-1",
                        @"1"
                        ];
    }
    return self;
}

@end

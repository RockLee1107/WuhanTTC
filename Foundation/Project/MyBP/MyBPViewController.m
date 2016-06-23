//
//  MyBPViewController.m
//  Foundation
//
//  Created by 李志强 on 16/6/3.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "MyBPViewController.h"
#import "MyBPTableViewController.h"
#import "MyBPCollectTableViewController.h"

@interface MyBPViewController ()

@end

@implementation MyBPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的BP";
    self.navigationItem.rightBarButtonItem = nil;
}


- (instancetype)init{
    self = [super init];
    if (self) {
        NSArray *viewControllerClasses = @[
                                           [MyBPTableViewController class],
                                           [MyBPCollectTableViewController class],
                                           ];
        NSArray *titles = @[
                            @"我创建的",
                            @"我收藏的"
                            ];
        self.viewControllerClasses = viewControllerClasses;
        self.titles = titles;
        self.menuItemWidth = SCREEN_WIDTH / titles.count;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuHeight = 50;
        self.titleSizeSelected = 15.0;
        self.titleColorSelected = MAIN_COLOR;
        //为不同页面设置相对应的标签，每一个key对应一个values
        self.keys = @[
                      @"SEQ_queryType",
                      @"SEQ_queryType",
                      ];
        self.values = @[
                        @"CREATE",
                        @"COLLECT"
                        ];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  SpecialTTCViewController.m
//  Foundation
//
//  Created by 李志强 on 16/6/8.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "SpecialTTCViewController.h"
#import "TTCSpecialViewController.h"
#import "OriginalViewController.h"

@interface SpecialTTCViewController ()

@end

@implementation SpecialTTCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"团团创专栏";
    self.navigationItem.rightBarButtonItem = nil;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        NSArray *viewControllerClasses = @[
                                           [TTCSpecialViewController class],
                                           [OriginalViewController class]
                                           ];
        NSArray *titles = @[
                            @"动态",
                            @"原创"
                            ];
        self.viewControllerClasses = viewControllerClasses;
        self.titles = titles;
        self.menuItemWidth = SCREEN_WIDTH / titles.count;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.menuHeight = 50;
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

//
//  BaseViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageIndex = 1;
    self.page = [[Page alloc] init];
    self.service = [HttpService getInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

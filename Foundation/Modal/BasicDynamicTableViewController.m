//
//  BasicDynamicTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/18.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BasicDynamicTableViewController.h"

@interface BasicDynamicTableViewController ()

@end

@implementation BasicDynamicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.page = [[Page alloc] init];
    self.service = [HttpService getInstance];
    self.dataMutableArray = [NSMutableArray array];
}

@end

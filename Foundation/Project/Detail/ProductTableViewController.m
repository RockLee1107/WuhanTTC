//
//  ProductTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/5/5.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ProductTableViewController.h"

@interface ProductTableViewController ()
@property (strong,nonatomic) NSString *pid;
@end

@implementation ProductTableViewController

- (instancetype)init {
    self = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"product"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDynamicLayout];
}

@end

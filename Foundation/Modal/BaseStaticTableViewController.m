//
//  BaseTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseStaticTableViewController.h"

@interface BaseStaticTableViewController ()

@end

@implementation BaseStaticTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-36.0, 0, 0, 0);
    self.page = [[Page alloc] init];
    self.page.pageNo = 1;
    self.service = [HttpService getInstance];
    self.dataMutableArray = [NSMutableArray array];
    
    //后退按钮标题与按钮图片
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    UIImage *backBarItemImage = [[UIImage imageNamed:@"arrow_left"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [backItem setBackButtonBackgroundImage:backBarItemImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
}

//- (void)viewWillAppear:(BOOL)animated {
//    self.tabBarController.tabBar.hidden = YES;
//}

- (void)setDynamicLayout {
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.currentTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.currentTextField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.currentTextField resignFirstResponder];
    return YES;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

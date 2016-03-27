//
//  SubjecListViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "SubjectListViewController.h"
#import "SubjectDetailTableViewController.h"

@interface SubjectListViewController ()

@end

@implementation SubjectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performSelector:@selector(jumpDetailTest) withObject:nil afterDelay:.5];
    // Do any additional setup after loading the view.
}

- (void)jumpDetailTest {
    SubjectDetailTableViewController *vc = [[UIStoryboard storyboardWithName:@"Book" bundle:nil] instantiateViewControllerWithIdentifier:@"subjectDetail"];
    [self.navigationController pushViewController:vc animated:YES];
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

//
//  TeamMemberTableViewController.m
//  Foundation
//
//  Created by 李志强 on 16/6/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "TeamMemberTableViewController.h"
#import "TeamMemberDelegate.h"

@interface TeamMemberTableViewController ()

@end

@implementation TeamMemberTableViewController

- (void)viewWillDisappear:(BOOL)animated {
    if (self.block != nil) {
        self.block(@"ok");
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initDelegate];
    [self createUI];
}

//初始化代理
- (void)initDelegate {
    self.tableViewDelegate = [[TeamMemberDelegate alloc] init];
    self.tableViewDelegate.vc = self;
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDelegate;
}

- (void)createUI {

    self.title = @"团队成员信息";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)loadData {
    NSDictionary *dict = @{
                           @"sEQ_projectId":self.projectId,
                           @"sEQ_visible":@"private"
                           };
    NSString *jsonStr = [StringUtil dictToJson:dict];
    NSDictionary *param = @{@"QueryParams":jsonStr};
    
    [self.service POST:@"team/getTeamList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        [self.tableViewDelegate.dataArray removeAllObjects];
        [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
        
        [self.tableView reloadData];
        
    } noResult:^{
        NSLog(@"22222222222");
    }];
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

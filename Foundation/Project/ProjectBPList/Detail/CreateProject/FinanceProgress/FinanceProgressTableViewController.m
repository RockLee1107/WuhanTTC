//
//  FinanceProgressTableViewController.m
//  Foundation
//
//  Created by 李志强 on 16/6/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "FinanceProgressTableViewController.h"
#import "FinanceProgressDelegate.h"

@interface FinanceProgressTableViewController ()

@property (nonatomic, strong) NSDictionary *dic;

@end

@implementation FinanceProgressTableViewController

- (void)viewWillDisappear:(BOOL)animated {
    if (self.block != nil) {
        if (self.dic) {
            self.block(@"ok");
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UIColor whiteColor];
    [self fetchData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self initDelegate];
    
}

//初始化代理
- (void)initDelegate {
    self.tableViewDelegate = [[FinanceProgressDelegate alloc] init];
    self.tableViewDelegate.vc = self;
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDelegate;
}

- (void)createUI {
    self.title = @"融资信息";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//访问网络
- (void)fetchData {
    NSDictionary *dict = @{
                           @"sEQ_projectId":self.projectId,
                           @"sEQ_visible":@"private"
                           };
    NSString *jsonStr = [StringUtil dictToJson:dict];
    NSDictionary *param = @{@"QueryParams":jsonStr};
    [self.service POST:@"finance/getFinanceList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {

        self.dic = responseObject;
        [self.tableViewDelegate.dataArray removeAllObjects];
        [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
        [self.tableView reloadData];
        
    } noResult:nil];
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

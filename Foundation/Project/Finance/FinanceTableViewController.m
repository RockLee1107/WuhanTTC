//
//  FinanceTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/19.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "FinanceTableViewController.h"
#import "FinanceTableViewCell.h"
#import "FinanceCreateTableViewController.h"
#import "StatusDict.h"
#import "Masonry.h"

@interface FinanceTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@end

@implementation FinanceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //管理页面
    NSDictionary *param = @{
                            @"projectId":self.pid
                            };
    [self.service GET:@"/project/getProjectDto" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataDict = responseObject;
        if ([self.dataDict[@"createdById"] isEqualToString:[User getInstance].uid]) {
//            创建者
            //        tb下移
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top).offset(40);
            }];
            //        添加按钮
            UIButton *addButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
            [addButton setImage:[UIImage imageNamed:@"app_add"] forState:(UIControlStateNormal)];
            [self.view addSubview:addButton];
            [addButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.view.mas_right).offset(-20);
                make.top.equalTo(self.view.mas_top).offset(20);
                make.width.mas_equalTo(40);
                make.height.mas_equalTo(40);
            }];
            [addButton addTarget:self action:@selector(addButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
            
        }
    } noResult:nil];
    [self fetchData];
}

//返回即刷新数据，将本VC的dataArray传给添加页面
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

//按钮点击
- (void)addButtonPress:(UIButton *)sender {
    FinanceCreateTableViewController *vc = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"finance"];
//    传数组过去，待传回，然后提交服务器
//    vc.mArray = self.dataArray;
    //pid传递
    vc.pid = self.pid;
    //vc传递
    vc.parentVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//访问网络
- (void)fetchData {
    NSDictionary *param = @{@"QueryParams":[StringUtil dictToJson:@{
                                                                    @"SEQ_projectId":self.pid
                                                                    }],
                            @"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service POST:@"finance/queryFinanceList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        self.dataArray = responseObject;
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:responseObject];
        [self.tableView reloadData];
    } noResult:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FinanceTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FinanceTableViewCell" owner:nil options:nil] firstObject];
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.dateLabel.text = [DateUtil toYYYYMMCN:dict[@"financeTime"]];
    [cell.timelineDotImageView setHighlighted:![dict[@"financeProc"] boolValue]];
//    timeline线条颜色
    if ([dict[@"financeProc"] boolValue]) {
//        蓝
        cell.timelineView.backgroundColor = HGColor(0,145,240);
    } else {
        cell.timelineView.backgroundColor = HGColor(255,153,0);
    }
    cell.financeProcCodeLabel.text = [StatusDict financeProcByCode:dict[@"financeProcCode"]];
    NSString *moneyType = [dict[@"moneyType"] boolValue] ? @"万美元" : @"万人民币";
    cell.financeAmountLabel.text = [NSString stringWithFormat:@"%@%@",dict[@"financeAmount"],moneyType];
    cell.sellSharesLabel.text = [NSString stringWithFormat:@"%@%%",dict[@"sellShares"]];
    cell.investCompLabel.text = [StringUtil toString:dict[@"investComp"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116.0;
}

@end

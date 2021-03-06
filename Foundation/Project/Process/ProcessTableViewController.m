//
//  ProcessTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/19.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ProcessTableViewController.h"
#import "ProcessTableViewCell.h"
#import "StatusDict.h"
#import "Masonry.h"
#import "ProcessCreateTableViewController.h"
#import "SingletonObject.h"

@interface ProcessTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation ProcessTableViewController

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
    
//    [self.service GET:@"/process/getProcessList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        self.dataDict = responseObject;
//        if ([self.dataDict[@"createdById"] isEqualToString:[User getInstance].uid] && ![SingletonObject getInstance].isBrowse) {
//            //            创建者
//            //        tb下移
//            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.view.mas_top).offset(40);
//            }];
//            //        添加按钮
//            UIButton *addButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
//            [addButton setImage:[UIImage imageNamed:@"app_add"] forState:(UIControlStateNormal)];
//            [self.view addSubview:addButton];
//            [addButton mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(self.view.mas_right).offset(-20);
//                make.top.equalTo(self.view.mas_top).offset(20);
//                make.width.mas_equalTo(40);
//                make.height.mas_equalTo(40);
//            }];
//            [addButton addTarget:self action:@selector(addButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
//            
//        }
//   } noResult:nil];
    [self fetchData];
}

//返回即刷新数据，将本VC的dataArray传给添加页面
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

//按钮点击
- (void)addButtonPress:(UIButton *)sender {
    ProcessCreateTableViewController *vc = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"process"];
    //pid传递
    vc.pid = self.pid;
    //vc传递
    vc.parentVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//访问网络
- (void)fetchData {
    NSDictionary *dict = @{
                           @"sEQ_projectId":[User getInstance].srcId,
                           @"sEQ_visible":[User getInstance].sEQ_visible
                           };
    NSString *jsonStr = [StringUtil dictToJson:dict];
    NSDictionary *param = @{@"QueryParams":jsonStr};
    [self.service POST:@"process/getProcessList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    ProcessTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ProcessTableViewCell" owner:nil options:nil] firstObject];
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.dateLabel.text = [DateUtil toYYYYMMCN:dict[@"processDate"]];
    cell.descLabel.text = [StringUtil toString:dict[@"processDesc"]];
    cell.descLabel.tag = 888 + indexPath.row;
    
    if ([User getInstance].isClick == NO) {
        cell.userInteractionEnabled = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([SingletonObject getInstance].isBrowse) {
        return;
    }
    ProcessCreateTableViewController *vc = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"process"];
    vc.dataDict = self.dataArray[indexPath.row];
    vc.parentVC = self;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *lab = (UILabel *)[self.view viewWithTag:888 + indexPath.row];
    
    lab.numberOfLines = 0;
    [lab sizeToFit];
    
    return lab.frame.size.height + 50;
}

@end

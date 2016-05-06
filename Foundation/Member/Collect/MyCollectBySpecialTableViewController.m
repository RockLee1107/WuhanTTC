//
//  MyCollectBySpecialTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/24.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "MyCollectBySpecialTableViewController.h"
#import "SpecialTypeForCollectTableViewCell.h"
#import "MyCollectTableViewController.h"

@interface MyCollectBySpecialTableViewController ()

@end

@implementation MyCollectBySpecialTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRefreshControl];
    [self setDynamicLayout];
}

//上拉下拉控件
- (void)initRefreshControl {
    /**上拉刷新、下拉加载*/
    __weak typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.page.pageNo = 1;
        [weakSelf fetchData];
        [weakSelf.tableView.header endRefreshing];
    }];
    [self.tableView.legendHeader beginRefreshing];
}

///请求网络
- (void)fetchData {
    NSDictionary *param =  @{
                                @"collectUserId":[User getInstance].uid
                            };
    [self.service GET:@"personal/collect/collectBookSp" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataArray = responseObject;
        [self.tableView reloadData];
    } noResult:^{
        [self.tableView.footer noticeNoMoreData];
    }];
}

#pragma mark - tb delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecialTypeForCollectTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SpecialTypeForCollectTableViewCell" owner:nil options:nil] firstObject];
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.thumbImageView.image = [UIImage imageNamed:[StringUtil toString:dict[@"specialCode"]]];
    cell.specialNameLabel.text = [StringUtil toString:dict[@"specialName"]];
    cell.colNumLabel.text = [StringUtil toString:dict[@"colNum"]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.row];
    MyCollectTableViewController *vc = [[MyCollectTableViewController alloc] init];
    vc.specialCode = dict[@"specialCode"];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

//单元格删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *param = @{
                                @"specialCode":dict[@"specialCode"],
                                @"delType":@"specialCode"
                                };
        [[HttpService getInstance] POST:@"personal/collect/cancelCollect" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            tableView.editing = NO;
            self.page.pageNo = 1;
            [self fetchData];
        } noResult:nil];
    }
}
@end

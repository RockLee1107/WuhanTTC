//
//  ApplyListTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/5/3.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ApplyListTableViewController.h"
#import "ApplyUserTableViewCell.h"
#import "UserDetailViewController.h"

@interface ApplyListTableViewController ()

@end

@implementation ApplyListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDynamicLayout];
    [self initRefreshControl];
    [self fetchData];
    self.navigationItem.title = @"报名信息";
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
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.page.pageNo++;
        [weakSelf fetchData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [weakSelf.tableView.footer endRefreshing];
    }];
}

///请求网络
- (void)fetchData {    
    NSDictionary *param =  @{@"activityId":self.activityId,
                             @"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service GET:@"apply/queryApplyList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if (self.page.pageNo == 1) {
            //由于下拉刷新时页面而归零
            [self.dataMutableArray removeAllObjects];
            [self.tableView.footer resetNoMoreData];
        }
        //当小于每页条数，就判定加载完毕
        if ([responseObject count] < self.page.pageSize) {
            [self.tableView.footer noticeNoMoreData];
        }
        [self.dataMutableArray addObjectsFromArray:responseObject];
        [self.tableView reloadData];
    } noResult:^{
        if (self.page.pageNo == 1) {
            [self.dataMutableArray removeAllObjects];
            [self.tableView reloadData];
        }
        [self.tableView.footer noticeNoMoreData];
    }];
}

#pragma mark - tb delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataMutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataMutableArray[indexPath.row];
    ApplyUserTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ApplyUserTableViewCell" owner:nil options:nil] firstObject];
    cell.realnameLabel.text = [StringUtil toString:dict[@"realName"]];
    cell.companyLabel.text = [StringUtil toString:dict[@"company"]];
    cell.emailLabel.text = [StringUtil toString:dict[@"email"]];
    cell.telePhoneLabel.text = [StringUtil toString:dict[@"telePhone"]];
    cell.dutyLabel.text = [StringUtil toString:dict[@"duty"]];
    NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:dict[@"pictUrl"]]];
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:url]];
    cell.avatarImageView.layer.cornerRadius = CGRectGetWidth(cell.avatarImageView.frame) / 2.0;
    cell.avatarImageView.clipsToBounds = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataMutableArray[indexPath.row];
    UserDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Friends" bundle:nil] instantiateViewControllerWithIdentifier:@"userDetail"];
    vc.userId = dict[@"userId"];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end

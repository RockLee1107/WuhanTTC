//
//  MyReplyTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/24.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "MyReplyTableViewController.h"
#import "ReplyForMemberCenterTableViewCell.h"
#import "SubjectDetailTableViewController.h"

@interface MyReplyTableViewController ()

@end

@implementation MyReplyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDynamicLayout];
    [self initRefreshControl];
    [self fetchData];
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
    NSDictionary *param =  @{@"QueryParams":[StringUtil dictToJson:@{
                                                                     @"SEQ_userId":[User getInstance].uid                                                                     }],
                             @"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service GET:@"book/postSubject/queryPostSubject" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    return self.dataMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReplyForMemberCenterTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ReplyForMemberCenterTableViewCell" owner:nil options:nil] firstObject];
    NSDictionary *object = self.dataMutableArray[indexPath.row];
    /**标题*/
    cell.myTextLabel.text = [StringUtil toString:object[@"title"]];
    /**发布时间*/
    cell.pbDateTimeLabel.text = [DateUtil toString:object[@"pbDate"] time:object[@"pbTime"]];
    /**回复数*/
    cell.contentLabel.text = [StringUtil toString:object[@"content"]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SubjectDetailTableViewController *vc = [[UIStoryboard storyboardWithName:@"Book" bundle:nil] instantiateViewControllerWithIdentifier:@"subjectDetail"];
    NSDictionary *object = self.dataMutableArray[indexPath.row];
    vc.dict = object;
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/**暂时不需要删帖功能
//单元格删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataMutableArray[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *param = @{
                                @"subjectId":dict[@"subjectId"],
                                @"delType":@"reply"
                                };
        [[HttpService getInstance] POST:@"post/delPostSubject" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            tableView.editing = NO;
            self.page.pageNo = 1;
            [self fetchData];
        } noResult:nil];
    }
}
*/
@end

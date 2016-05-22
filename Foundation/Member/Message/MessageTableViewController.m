//
//  MessageTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/29.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "MessageTableViewController.h"
#import "MessageTableViewCell.h"
#import "MessageDetailViewController.h"

@interface MessageTableViewController ()

@end

@implementation MessageTableViewController

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
    //参数:1.SEQ_toUserId--用户id  2.SIN_type--页面
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"SEQ_toUserId":[User getInstance].uid,
                                                                                @"SIN_type":self.SEQ_type
                                                                                }];
    
    NSDictionary *param =  @{@"QueryParams":[StringUtil dictToJson:dict],
                             @"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service GET:@"personal/msg/getUserMsg" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
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
        //如果SIN_type 是系统通知页面  self.dataMutableArray获得的也就是这个页面的数据
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
    MessageTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageTableViewCell" owner:nil options:nil] firstObject];
    //时间
    cell.createdDatetimeLabel.text = [DateUtil toShortDateCN:dict[@"createdDate"] time:dict[@"createdTime"]];
    //时间旁的描述文字
    cell.titleLabel.text = [StringUtil toString:dict[@"title"]];
    //
    cell.unreadImageView.hidden = [dict[@"status"] boolValue];
    //文字
    cell.contentLabel.text = [StringUtil toString:dict[@"content"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataMutableArray[indexPath.row];
    MessageDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Message" bundle:nil] instantiateInitialViewController];
    vc.dataDict = dict;
    NSLog(@"%@", dict);
   
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end

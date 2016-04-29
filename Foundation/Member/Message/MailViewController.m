//
//  MailViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/29.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "MailViewController.h"
#import "MailTableViewCell.h"

@interface MailViewController ()

@end

@implementation MailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDynamicLayout];
    [self initRefreshControl];
    [self fetchData];
    self.navigationItem.title = @"私信";
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
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                self.userType:[User getInstance].uid,
                                                                                @"SEQ_type":@"1"
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
    MailTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MailTableViewCell" owner:nil options:nil] firstObject];
    NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:dict[@"pictUrl"]]];
    cell.avatarImageView.clipsToBounds = YES;
    cell.avatarImageView.layer.cornerRadius = CGRectGetWidth(cell.avatarImageView.frame) / 2.0;
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:url]];
    [cell.realNameButton setTitle:dict[@"realName"] forState:(UIControlStateNormal)];
    cell.createdDatetimeLabel.text = [DateUtil toShortDateCN:dict[@"createdDate"] time:dict[@"createdTime"]];
//    是否显示收件状态
    if ([self.userType isEqualToString:@"SEQ_userId"]) {
        //显示状态
        cell.statusLabel.hidden = NO;
//        status: (0," 发送成功"), (1,"对方已阅读"), (2,"对方已回复");
        switch ([dict[@"status"] integerValue]) {
            case 0:
                cell.statusLabel.textColor = [UIColor redColor];
                cell.statusLabel.text = @"发送成功";
                break;
            case 1:
                cell.statusLabel.textColor = [UIColor blueColor];
                cell.statusLabel.text = @"对方已阅读";
                break;
            case 2:
                cell.statusLabel.textColor = [UIColor greenColor];
                cell.statusLabel.text = @"对方已回复";
                break;
            default:
                break;
        }
        cell.leadingOfCreatedDateTimeLabel.constant = 100;
    } else {
        cell.statusLabel.hidden = YES;
    }
    cell.contentLabel.text = [StringUtil toString:dict[@"content"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataMutableArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end

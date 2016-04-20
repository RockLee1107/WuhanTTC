//
//  EvaluateTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/20.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "EvaluateTableViewController.h"
#import "EvaluateTableViewCell.h"

@interface EvaluateTableViewController ()

@end

@implementation EvaluateTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self fetchData];
}

- (void)fetchData {
    NSDictionary *param = @{@"QueryParams":[StringUtil dictToJson:@{
                                                                    @"SEQ_projectId":self.pid
                                                                    }],
                            @"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service POST:@"evaluate/queryEvaluateDtoList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataArray = responseObject;
        [self.tableView reloadData];
    } noResult:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EvaluateTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EvaluateTableViewCell" owner:nil options:nil] firstObject];
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.avatarImageView.clipsToBounds = YES;
    cell.avatarImageView.layer.cornerRadius = CGRectGetWidth(cell.avatarImageView.frame) / 2.0;
    NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:dict[@"pictUrl"]]];
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:url]];
    cell.realnameLabel.text = dict[@"realName"];
    cell.userDescLabel.text = [StringUtil toString:dict[@"userDesc"]];
    cell.pbtimeLabel.text = [DateUtil toShortDateCN:dict[@"pbDate"] time:dict[@"pbTime"]];
    cell.contentLabel.text = [StringUtil toString:dict[@"content"]];
    return cell;
}

@end

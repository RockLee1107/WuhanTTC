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
    [self fetchData];
    [self setDynamicLayout];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}
@end

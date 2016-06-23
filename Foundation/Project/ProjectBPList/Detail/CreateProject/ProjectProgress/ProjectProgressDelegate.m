//
//  ProjectProgressDelegate.m
//  Foundation
//
//  Created by 李志强 on 16/6/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ProjectProgressDelegate.h"
#import "ProcessTableViewCell.h"
#import "DateUtil.h"
#import "ProcessTableViewController.h"
#import "ProcessCreateTableViewController.h"

@implementation ProjectProgressDelegate

#pragma mark - tb代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProcessTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ProcessTableViewCell" owner:nil options:nil] firstObject];
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    cell.dateLabel.text = [DateUtil toYYYYMMCN:dict[@"processDate"]];
    cell.descLabel.text = [StringUtil toString:dict[@"processDesc"]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 60, 20, 20)];
    iconImage.image = [UIImage imageNamed:@"menu_create@2x"];
    [headView addSubview:iconImage];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(SCREEN_WIDTH-50, 54, 45, 30);
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:addBtn];
    
    return headView;
}

- (void)addBtnClick {
    ProcessCreateTableViewController *vc = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"process"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.isFromAdd = YES;
    vc.title = @"添加进度信息";
    [self.vc.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    ProcessTableViewCell *cell = (ProcessTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    ProcessCreateTableViewController *vc = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"process"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.isFromAdd = YES;
    vc.idStr = dict[@"id"];
    vc.title = @"编辑进度信息";
    vc.dateText = cell.dateLabel.text;
    vc.descText = cell.descLabel.text;
    
    [self.vc.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 84;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

@end

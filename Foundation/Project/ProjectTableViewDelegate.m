//
//  ProjectTableViewDelegate.m
//  Foundation
//
//  Created by Dotton on 16/3/21.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ProjectTableViewDelegate.h"
#import "ProjectTableViewCell.h"
#import "ProjectDetailViewController.h"
#import "SingletonObject.h"
#import "HttpService.h"
#import "MyProjectTableViewController.h"
#import "User.h"

@implementation ProjectTableViewDelegate
#pragma mark - tb代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectTableViewCell" owner:nil options:nil] firstObject];
    NSDictionary *object = self.dataArray[indexPath.row];
    /**图片*/
    [cell.pictUrlImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:object[@"headPictUrl"]]]]];
    cell.pictUrlImageView.clipsToBounds = YES;
    /**标题*/
    cell.titleLabel.text = [StringUtil toString:object[@"projectName"]];
    /**简历*/
    cell.resumeLabel.text = [StringUtil toString:object[@"projectResume"]];
    /**城市*/
    cell.cityLabel.text = [StringUtil toString:object[@"area"]];
//    阶段
    [cell.financeProcNameLabel setTitle:[StringUtil toString:object[@"financeProcName"]] forState:(UIControlStateNormal)];
    
    //状态
    if ([[object[@"bizStatus"] stringValue] isEqualToString:@"1"]) {
        cell.statusLabel.text = @"待审核";
        cell.statusLabel.backgroundColor = [UIColor orangeColor];
    }else if ([[object[@"bizStatus"] stringValue] isEqualToString:@"2"]) {
        cell.statusLabel.text = @"已发布";
        cell.statusLabel.backgroundColor = [UIColor greenColor];
    }else if ([[object[@"bizStatus"] stringValue] isEqualToString:@"3"] ) {
        cell.statusLabel.text = @"未通过";
        cell.statusLabel.backgroundColor = [UIColor redColor];
    }
    else {
        cell.statusLabel.text = @"待发布";
        cell.statusLabel.backgroundColor = [UIColor lightGrayColor];
    }
    cell.separatorLine.backgroundColor = SEPARATORLINE;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *object = self.dataArray[indexPath.row];
    [SingletonObject getInstance].pid = [StringUtil toString:object[@"projectId"]];
    //从我的项目进入项目详情 传private和projectId
    [User getInstance].sEQ_visible = @"private";
    [User getInstance].projectId = [StringUtil toString:object[@"projectId"]];
    
    ProjectDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"detail"];
    vc.dataDict = object;
    //待审核不能更新项目
    if ([[object[@"bizStatus"] stringValue] isEqualToString:@"1"]) {
        vc.whetherUpdate = NO;
    }
    //驳回 未提交 已发布 均可更新项目
    else {
        vc.whetherUpdate = YES;
    }
    
    [vc setHidesBottomBarWhenPushed:YES];
    [self.vc.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//可编辑-包括左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delType) {
        return YES;
    }
    return NO;
}

//单元格删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *param = @{
                                @"projectId":dict[@"projectId"],
                                @"delType":self.delType
                                };
        [[HttpService getInstance] POST:@"project/delProject" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            tableView.editing = NO;
            MyProjectTableViewController *vc = (MyProjectTableViewController *)self.vc;
            vc.page.pageNo = 1;
            [vc fetchData];
        } noResult:nil];
    }
}
@end

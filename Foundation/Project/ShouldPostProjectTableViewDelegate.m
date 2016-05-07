//
//  ProjectTableViewDelegate.m
//  Foundation
//
//  Created by Dotton on 16/3/21.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ShouldPostProjectTableViewDelegate.h"
#import "ProjectTableViewCell.h"
#import "ProjectDetailViewController.h"
#import "SingletonObject.h"
#import "HttpService.h"
#import "MyProjectTableViewController.h"
#import "EYInputPopupView.h"

@implementation ShouldPostProjectTableViewDelegate
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
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *object = self.dataArray[indexPath.row];
//    判断有没有BP
    if (object[@"bppictUrl"] == [NSNull null]) {
        [SVProgressHUD showErrorWithStatus:@"项目必须是上传BP才可投递"];
    } else {
        [EYInputPopupView popViewWithTitle:@"投递项目" contentText:@"请填写投递理由(3-200字)"
                                      type:EYInputPopupView_Type_multi_line
                               cancelBlock:^{
                                   
                               } confirmBlock:^(UIView *view, NSString *text) {
                                   if (![VerifyUtil isValidStringLengthRange:text between:3 and:200]) {
                                       [SVProgressHUD showErrorWithStatus:@"请举报评析内容(3-200字)"];
                                       return ;
                                   }
                                   NSDictionary *param = @{
                                                           @"Post":[StringUtil dictToJson:@{
                                                                                                @"projectId":[SingletonObject getInstance].pid,
                                                                                                @"desc":text,
                                                                                                @"userId":[User getInstance].uid,
                                                                                                @"financeId":self.financeId
                                                                                                }]
                                                           };
                                   [[HttpService getInstance] POST:@"post/save" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                                   } noResult:nil];
                               } dismissBlock:^{
                                   
                               }
         ];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

//
//  ActivityTableViewDelegate.m
//  Foundation
//
//  Created by Dotton on 16/3/21.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ActivityTableViewDelegate.h"
#import "ActivityTableViewCell.h"
#import "ActivityDetailViewController.h"
#import "MyActivityTableViewController.h"
#import "DateUtil.h"

@implementation ActivityTableViewDelegate
#pragma mark - tb代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityTableViewCell" owner:nil options:nil] firstObject];
    NSDictionary *object = self.dataArray[indexPath.row];
    /**图片*/
    NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:object[@"pictUrl"]]];
    [cell.pictUrlImageView setImageWithURL:[NSURL URLWithString:url]];
    cell.pictUrlImageView.clipsToBounds = YES;
    /**标题*/
    cell.activityTitleLabel.text = [StringUtil toString:object[@"activityTitle"]];
    
    cell.typeLabel.text = [StringUtil toString:object[@"type"]];
  
    //状态判断
    //如果报名人数未满，且报名时间未截止，显示报名中
    if([object[@"applyNum"] integerValue] < [object[@"planJoinNum"] integerValue]
        && [DateUtil isDestDateInFuture:[[StringUtil toString:object[@"endDate"]] stringByAppendingString:[StringUtil toString:object[@"endTime"]]]]){
        /**状态*/
        cell.statusLabel.text = @"报名中";
        cell.statusLabel.backgroundColor = ACTIVITY_STATUS_ON_COLOR;
    }
    //如果报名人数已满，且报名时间未截止，显示已满
    else if([object[@"applyNum"] integerValue] == [object[@"planJoinNum"] integerValue]
            && [DateUtil isDestDateInFuture:[[StringUtil toString:object[@"endDate"]] stringByAppendingString:[StringUtil toString:object[@"endTime"]]]]){
        /**状态*/
        cell.statusLabel.text = @"已满";
        cell.statusLabel.backgroundColor = ACTIVITY_STATUS_FULL_COLOR;
    }
    else{
        cell.statusLabel.text = @"已结束";
        cell.statusLabel.backgroundColor = ACTIVITY_STATUS_OVER_COLOR;
    }
    

    /**开始时间*/
    cell.planDateLabel.text = [DateUtil toShortDate:object[@"planDate"]];
    /**城市*/
    cell.cityLabel.text = [StringUtil toString:object[@"city"]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *object = self.dataArray[indexPath.row];
    ActivityDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Activity" bundle:nil] instantiateViewControllerWithIdentifier:@"detail"];
    vc.activityId = object[@"activityId"];
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
                                @"activityId":dict[@"activityId"],
                                @"delType":self.delType
                                };
        [[HttpService getInstance] POST:@"activity/delActivity" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            tableView.editing = NO;
            MyActivityTableViewController *vc = (MyActivityTableViewController *)self.vc;
            vc.page.pageNo = 1;
            [vc fetchData];
        } noResult:nil];
    }
}
@end

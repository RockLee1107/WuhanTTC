//
//  ActivityTableViewDelegate.m
//  Foundation
//
//  Created by Dotton on 16/3/21.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ActivityTableViewDelegate.h"
#import "ActivityTableViewCell.h"

@implementation ActivityTableViewDelegate
#pragma mark - tb代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ActivityTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityTableViewCell" owner:nil options:nil] firstObject];
    NSDictionary *object = self.dataArray[indexPath.row];
    /**图片*/
    [cell.pictUrlImageView setImageWithURL:[NSURL URLWithString:[StringUtil toString:object[@"pictUrl"]]]];
    cell.pictUrlImageView.clipsToBounds = YES;
    /**标题*/
    cell.activityTitleLabel.text = [StringUtil toString:object[@"activityTitle"]];
    /**状态*/
    cell.statusLabel.text = ACTIVITY_STATUS_ARRAY[[object[@"status"] integerValue]];
    /**开始时间*/
    cell.planDateLabel.text = [DateUtil toShortDate:object[@"planDate"]];
    /**城市*/
    cell.cityLabel.text = [StringUtil toString:object[@"city"]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.0;
}

@end

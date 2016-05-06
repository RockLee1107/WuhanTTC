//
//  SubjectTableViewDelegate.m
//  Foundation
//
//  Created by Dotton on 16/3/28.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "SubjectTableViewDelegate.h"
#import "SubjectTableViewCell.h"
#import "SubjectDetailTableViewController.h"

@implementation SubjectTableViewDelegate
#pragma mark - tb代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SubjectTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SubjectTableViewCell" owner:nil options:nil] firstObject];
    NSDictionary *object = self.dataArray[indexPath.row];
    /**图片*/
    [cell.pictUrlImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:object[@"pictUrl"]]]]];
    cell.pictUrlImageView.clipsToBounds = YES;
    cell.pictUrlImageView.layer.cornerRadius = 10.0;
    /**标题*/
    cell.myTextLabel.text = [StringUtil toString:object[@"title"]];
    /**作者*/
    cell.realnameLabel.text = object[@"realName"] == [NSNull null] ? @"匿名用户" : object[@"realName"];
    /**发布时间*/
    cell.pbDateTimeLabel.text = [DateUtil toString:object[@"pbDate"] time:object[@"pbTime"]];
    /**回复数*/
    cell.replyCountLabel.text = [object[@"replyCount"] stringValue];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SubjectDetailTableViewController *vc = [[UIStoryboard storyboardWithName:@"Book" bundle:nil] instantiateViewControllerWithIdentifier:@"subjectDetail"];
    NSDictionary *object = self.dataArray[indexPath.row];
    vc.dict = object;
    [self.vc.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

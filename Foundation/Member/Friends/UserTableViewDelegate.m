//
//  UserTableViewDelegate.m
//  Foundation
//
//  Created by Dotton on 16/4/28.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "UserTableViewDelegate.h"
#import "UserTableViewCell.h"
#import "UserDetailViewController.h"
#import "MyActivityTableViewController.h"

@implementation UserTableViewDelegate

#pragma mark - tb代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"UserTableViewCell" owner:nil options:nil] firstObject];
    NSDictionary *dict = self.dataArray[indexPath.row];
    /**图片*/
    NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:dict[@"pictUrl"]]];
    cell.avatarImageView.clipsToBounds = YES;
//    cell.avatarImageView.layer.cornerRadius = CGRectGetWidth(cell.avatarImageView.frame) / 2.0;
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:url]];
    cell.avatarImageView.clipsToBounds = YES;
    cell.realnameLabel.text = [StringUtil toString:dict[@"realName"]];
    cell.companyLabel.text = [StringUtil toString:dict[@"company"]];
    cell.dutyLabel.text = [StringUtil toString:dict[@"duty"]];
    cell.areaLabel.text = [StringUtil toString:dict[@"area"]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *object = self.dataArray[indexPath.row];
    UserDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Friends" bundle:nil] instantiateViewControllerWithIdentifier:@"userDetail"];
    vc.userId = object[@"userId"];
    [self.vc.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

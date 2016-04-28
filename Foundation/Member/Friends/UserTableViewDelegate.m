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
    NSDictionary *object = self.dataArray[indexPath.row];
    /**图片*/
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:[StringUtil toString:object[@"pictUrl"]]]];
    cell.avatarImageView.clipsToBounds = YES;

    cell.areaLabel.text = [StringUtil toString:object[@"area"]];
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
}
@end

//
//  ProjectTableViewDelegate.m
//  Foundation
//
//  Created by Dotton on 16/3/21.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ProjectTableViewDelegate.h"
#import "ProjectTableViewCell.h"
#import "ProjectSummaryViewController.h"

@implementation ProjectTableViewDelegate
#pragma mark - tb代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectTableViewCell" owner:nil options:nil] firstObject];
    NSDictionary *object = self.dataArray[indexPath.row];
    /**图片*/
    [cell.pictUrlImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",HOST_URL,[StringUtil toString:object[@"bppictUrl"]]]]];
    cell.pictUrlImageView.clipsToBounds = YES;
    /**标题*/
    cell.titleLabel.text = [StringUtil toString:object[@"projectName"]];
    /**简历*/
    cell.resumeLabel.text = [StringUtil toString:object[@"projectResume"]];
    /**城市*/
    cell.cityLabel.text = [StringUtil toString:object[@"area"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectSummaryViewController *vc = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"detail"];
    //vc的Id值
#warning vc.id
    [self.vc.navigationController pushViewController:vc animated:YES];
}
@end
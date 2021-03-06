//
//  InvestorTableViewDelegate.m
//  Foundation
//
//  Created by Dotton on 16/4/2.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "InvestorTableViewDelegate.h"
#import "InvestorTableViewCell.h"
#import "InvestorDetailTableViewController.h"

@implementation InvestorTableViewDelegate
#pragma mark - tb代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InvestorTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"InvestorTableViewCell" owner:nil options:nil] firstObject];
    NSDictionary *object = self.dataArray[indexPath.row];
    /**图片*/
    [cell.pictUrlImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:object[@"pictUrl"]]]]];
    cell.pictUrlImageView.clipsToBounds = YES;
    cell.pictUrlImageView.layer.cornerRadius = 25;
    cell.pictUrlImageView.layer.masksToBounds = YES;
    cell.realNameLabel.text = [StringUtil toString:object[@"realName"]];
    cell.companyLabel.text = [StringUtil toString:object[@"company"]];
    cell.investProcessLabel.text = [StringUtil toString:object[@"investProcess"]];
    cell.investAreaLabel.text = [StringUtil toString:object[@"investArea"]];
    cell.areaLabel.text = [StringUtil toString:object[@"area"]];
    cell.dutyLabel.text = [StringUtil toString:object[@"duty"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    InvestorDetailTableViewController *vc = [[UIStoryboard storyboardWithName:@"Investor" bundle:nil] instantiateViewControllerWithIdentifier:@"investorDetail"];
    vc.dataDict = self.dataArray[indexPath.row];
    vc.hidesBottomBarWhenPushed = YES;
    [self.vc.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

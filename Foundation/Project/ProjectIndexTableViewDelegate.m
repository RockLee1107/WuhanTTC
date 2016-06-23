//
//  ProjectIndexTableViewDelegate.m
//  Foundation
//
//  Created by 李志强 on 16/6/3.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ProjectIndexTableViewDelegate.h"
#import "ProjectBPCell.h"
#import "SingletonObject.h"
#import "HttpService.h"
#import "ProjectBPDetailViewController.h"

@implementation ProjectIndexTableViewDelegate

#pragma mark - tb代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProjectBPCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ProjectBPCell" owner:nil options:nil] firstObject];
    NSDictionary *object = self.dataArray[indexPath.row];
    
    cell.titleLabel.text = [StringUtil toString:object[@"bpName"]];
    
    cell.separatorLine.backgroundColor = SEPARATORLINE;
    cell.viewCountLabel.text = [StringUtil toString:[NSString stringWithFormat:@"%@", object[@"readNum"]]];
    cell.supportCountLabel.text = [StringUtil toString:[NSString stringWithFormat:@"%@", object[@"likeNum"]]];
    cell.collectLabel.text = [StringUtil toString:[NSString stringWithFormat:@"%@", object[@"collectNum"]]];
    [cell.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", UPLOAD_URL, object[@"bpLogo"]]] placeholderImage:[UIImage imageNamed:@"app_failure_img@2x"]];
    cell.bpId = [StringUtil toString:object[@"bpId"]];
    
    //切圆角
    cell.iconImageView.layer.cornerRadius  = 39.5;
    cell.iconImageView.layer.masksToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *object = self.dataArray[indexPath.row];
    ProjectBPDetailViewController *detailVC = [[ProjectBPDetailViewController alloc] init];
    //创投融首页cell 正向传值
    detailVC.bpId = [StringUtil toString:object[@"bpId"]];
    detailVC.isAppear = YES;//因为是公共区域，传YES
    detailVC.isUpdateBP = NO;//公共区域进入不能更新BP
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.vc.navigationController pushViewController:detailVC animated:YES];
}

@end

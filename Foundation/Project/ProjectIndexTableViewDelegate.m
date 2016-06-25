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
#import "VerifyTableViewController.h"

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
    
    //判断可见权限
    if ([object[@"bpVisible"] intValue] == 1) {
        [cell.lockImageView setImage:[UIImage imageNamed:@"app_lock"]];
    }
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
    
    //判断可见权限
    //仅投资人可见
    if ([object[@"bpVisible"] intValue] == 1) {
        //登录状态下
        if ([User getInstance].isLogin) {
            //是投资人
            if ([[User getInstance].isInvestor isEqual:@1]) {
                [self.vc.navigationController pushViewController:detailVC animated:YES];
            }
            //申请认证投资人
            else {
                if ([[User getInstance].bizStatus isEqualToString:@"0"]) {
                    //待审核
                    [SVProgressHUD showErrorWithStatus:@"您已提交申请,请耐心等待审核哦"];
                }else {
                    //审核不通过
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"此BP仅限投资人查看,是否立即申请认证投资人?" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"我要认证", nil];
                    [alertView show];
                }
            }

        }
        //游客状态
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
            [alertView show];
        }
    }
    //所有人可见
    else {
        [self.vc.navigationController pushViewController:detailVC animated:YES];
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //我要认证
    if (buttonIndex == 1) {
        //登录状态点击我要认证
        if ([User getInstance].isLogin) {
            VerifyTableViewController *vc = [[UIStoryboard storyboardWithName:@"Investor" bundle:nil] instantiateViewControllerWithIdentifier:@"verify"];
            [self.vc.navigationController pushViewController:vc animated:YES];
        }
        //游客状态
        else {
            //进入团团创登陆页面
            LoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
            [self.vc.navigationController presentViewController:loginVC animated:YES completion:nil];
        }
    }
}

@end

//
//  MemberTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/18.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

/******我页面******/


#import "MemberTableViewController.h"
#import "MyCollectPageController.h"
#import "MyNotePageController.h"
#import "MyProjectPageController.h"
#import "MyActivityPageController.h"
#import "MySubjectPageController.h"
#import "UserInfoTableViewController.h"
#import "FriendsListViewController.h"
#import "MessagePageController.h"

@interface MemberTableViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UIButton *userIdentityButton;
@property (weak, nonatomic) IBOutlet UIImageView *unreadImageView;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;

@end

@implementation MemberTableViewController

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    [self fetchData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.frame) / 2.0;
//    self.usernameLabel.text = [User getInstance].username;
    // Do any additional setup after loading the view.
}

- (void)fetchData {
    //登录状态
    if ([[User getInstance] isLogin]) {
        self.loginLabel.hidden = YES;
        NSDictionary *param = @{
                                @"userId":[User getInstance].uid
                                };
        [self.service POST:@"personal/info/getUserInfo" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.realnameLabel.text = responseObject[@"userinfo"][@"realName"];
            NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:responseObject[@"userinfo"][@"pictUrl"]]];
            //        NSLog(@"%@",url);
            [self.avatarImageView setImageWithURL:[NSURL URLWithString:url]];
            NSString *userIdentity = nil;
            if (responseObject[@"investorInfo"] != [NSNull null] && [responseObject[@"investorInfo"][@"bizStatus"] integerValue] == 1) {
                userIdentity = @"投资者";
            } else {
                userIdentity = @"创业者";
            }
            self.unreadImageView.hidden = ![responseObject[@"hasUnRead"] boolValue];
            [self.userIdentityButton setTitle:userIdentity forState:(UIControlStateNormal)];
        } noResult:nil];

    }//游客状态
    else {
        self.loginLabel.hidden = NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = nil;
    //登录状态
    if ([[User getInstance] isLogin]) {
        if (indexPath.section == 0) {
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"userinfo"];
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                //消息
                vc = [[MessagePageController alloc] init];
            } else if (indexPath.row == 1) {
                //创友录
                vc = [[UIStoryboard storyboardWithName:@"Friends" bundle:nil] instantiateInitialViewController];
            }
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                //我的收藏
                vc = [[MyCollectPageController alloc] init];
            } else if (indexPath.row == 1) {
                //我的笔记
                vc = [[MyNotePageController alloc] init];
            } else if (indexPath.row == 2) {
                //我的项目
                vc = [[MyProjectPageController alloc] init];
            } else if (indexPath.row == 3) {
                //我的活动
                vc = [[MyActivityPageController alloc] init];
            } else if (indexPath.row == 4) {
                //我的帖子
                vc = [[MySubjectPageController alloc] init];
            }
        } else if (indexPath.section == 3) {
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }//游客状态
    else {
        if (indexPath.section == 0) {
            LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }
        else if (indexPath.section == 3) {
            vc = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
            [alertView show];
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //确认退出系统
    if (buttonIndex == 1) {
        //进入团团创登陆页面
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
}


//#warning appstore
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 1 && indexPath.row == 0) {
//        return 0.01;
//    }
//    if (indexPath.section == 2 && indexPath.row == 1) {
//        return 0.01;
//    }
//    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
//}

//#warning appstore
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 1 && indexPath.row == 0) {
//        return [UITableViewCell new];
//    }
//    if (indexPath.section == 2 && indexPath.row == 1) {
//        return [UITableViewCell new];
//    }
//    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
//}
@end

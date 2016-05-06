//
//  MemberTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/18.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "MemberTableViewController.h"
#import "MyCollectPageController.h"
#import "MyNotePageController.h"
#import "MyProjectPageController.h"
#import "MyActivityPageController.h"
#import "MySubjectPageController.h"
#import "UserInfoTableViewController.h"
#import "FriendsListViewController.h"
#import "MessagePageController.h"

@interface MemberTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UIButton *userIdentityButton;
@property (weak, nonatomic) IBOutlet UIImageView *unreadImageView;

@end

@implementation MemberTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.frame) / 2.0;
//    self.usernameLabel.text = [User getInstance].username;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
    [self fetchData];
}

- (void)fetchData {
    if ([[User getInstance] isLogin]) {
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

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = nil;
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
    } else {
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

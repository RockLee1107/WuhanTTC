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

@interface MemberTableViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UIButton *userIdentityButton;

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
    NSDictionary *param = @{
                            @"userId":[User getInstance].uid
                            };
    [self.service POST:@"personal/info/getUserInfo" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.realnameLabel.text = responseObject[@"userinfo"][@"realName"];
        NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:responseObject[@"userinfo"][@"pictUrl"]]];
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:url]];
//        [self.userIdentityButton setTitle:USER_IDENTITY_DICT[responseObject[@"userinfo"][@"pictUrl"]] forState:(UIControlStateNormal)];
    } noResult:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UserInfoTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"userinfo"];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 2) {
        UIViewController *vc = nil;
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
        [self.navigationController pushViewController:vc animated:YES];
    } else if (indexPath.section == 3) {
        [self performSegueWithIdentifier:@"settings" sender:nil];
    }
}
@end

//
//  FriendsTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/13.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "FriendsListViewController.h"
#import "FriendTableViewCell.h"
#import "UserDetailViewController.h"

@interface FriendsListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;
@property (nonatomic, strong) NSMutableArray *letterArray;

@end

@implementation FriendsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsTableView.delegate = self;
    self.friendsTableView.dataSource = self;
    self.letterArray = [NSMutableArray array];
    [self fetchData];
    if (self.userId != nil) {
        self.navigationItem.title = @"共同好友";
    }
}

///访问网络数据
- (void)fetchData {
    self.page.pageSize = 99999;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"SEQ_userId":[User getInstance].uid
                                                                                }
                                 ];
    if (self.userId != nil) {
        [dict setObject:self.userId forKey:@"SEQ_hisUserId"];
    }
    NSDictionary *param = @{
                            @"QueryParams":[StringUtil dictToJson:dict],
                            @"Page":[StringUtil dictToJson:[self.page dictionary]]
                            };
    [self.service POST:@"personal/friends/getFriendsForIOS" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataArray = responseObject;
        for (NSDictionary *dict in responseObject) {
            for (NSString *letter in dict) {
                [self.letterArray addObject: letter];
            }
        }
        [self.friendsTableView reloadData];
    } noResult:^{
        [SVProgressHUD showSuccessWithStatus:@"暂无好友"];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    for (NSString *letter in self.dataArray[section]) {
        return [self.dataArray[section][self.letterArray[section]] count];
//    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    for (NSString *letter in self.dataArray[section]) {
//        return letter;
//    }
    return self.letterArray[section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.letterArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSArray *array;
//    for (NSString *letter in self.dataArray[indexPath.section]) {
//        array = self.dataArray[indexPath.section][letter];
//    }
    NSArray *array = self.dataArray[indexPath.section][self.letterArray[indexPath.section]];
    
    NSDictionary *dict = array[indexPath.row];
    FriendTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendTableViewCell" owner:nil options:nil] firstObject];
    cell.avatarImageView.clipsToBounds = YES;
    cell.avatarImageView.layer.cornerRadius = CGRectGetWidth(cell.avatarImageView.frame) / 2.0;
    NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:dict[@"pictUrl"]]];
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:url]];
    cell.realnameLabel.text = [StringUtil toString:dict[@"realName"]];
    cell.companyLabel.text = [StringUtil toString:dict[@"company"]];
    cell.dutyLabel.text = [StringUtil toString:dict[@"duty"]];
    cell.mobileLabel.text = [StringUtil toString:dict[@"mobile"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
}

///默认查看个人详情，还有添加团队、分享创友
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.section][self.letterArray[indexPath.section]][indexPath.row];
    if (self.selectDelegate != nil) {
        UIViewController *vc = [self.selectDelegate friendDidSelect:dict[@"friendId"] realname:dict[@"realName"] company:dict[@"company"] duty:dict[@"duty"] pictUrl:dict[@"pictUrl"]];
        [vc.navigationController popViewControllerAnimated:YES];
        return;
    }
    //默认行为
    UserDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Friends" bundle:nil] instantiateViewControllerWithIdentifier:@"userDetail"];
    vc.userId = dict[@"friendId"];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

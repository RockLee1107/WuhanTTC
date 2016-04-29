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

@end

@implementation FriendsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsTableView.delegate = self;
    self.friendsTableView.dataSource = self;
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
        [self.friendsTableView reloadData];
    } noResult:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    for (NSString *letter in self.dataArray[section]) {
        return [self.dataArray[section][letter] count];
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    for (NSString *letter in self.dataArray[section]) {
        return letter;
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *dict = self.dataArray[indexPath.section];
    NSArray *array;
    for (NSString *letter in self.dataArray[indexPath.section]) {
        array = self.dataArray[indexPath.section][letter];
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UserDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Friends" bundle:nil] instantiateViewControllerWithIdentifier:@"userDetail"];
    NSString *key;
    for (NSString *letter in self.dataArray[indexPath.section]) {
        key = letter;
    }
    vc.userId = self.dataArray[indexPath.section][key][indexPath.row][@"friendId"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end

//
//  UserDetailViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/28.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "UserDetailViewController.h"
#import "EYInputPopupView.h"
#import "LXButton.h"
#import "FriendsListViewController.h"
#import "MyCollectTableViewController.h"
#import "MyProjectTableViewController.h"
#import "MySubjectTableViewController.h"

@interface UserDetailViewController ()
/*个人信息属性*/
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dutyLabel;
/*投资人*/
@property (weak, nonatomic) IBOutlet UILabel *investIdeaLabel;
@property (weak, nonatomic) IBOutlet UILabel *investAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *investProcessLabel;
@property (weak, nonatomic) IBOutlet UILabel *investProjectLabel;
/*4大按钮*/
@property (weak, nonatomic) IBOutlet LXButton *makeFriendsButton;
@property (weak, nonatomic) IBOutlet LXButton *delFriendButton;
@property (weak, nonatomic) IBOutlet LXButton *postProjectButton;
@property (weak, nonatomic) IBOutlet LXButton *sendMsgButton;
/*4大标签*/
@property (weak, nonatomic) IBOutlet UILabel *sameFdsNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *hisColNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *hisAtProjNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *hisPostNumLabel;
@end

@implementation UserDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchData];
    self.avatarImageView.clipsToBounds = YES;
    // Do any additional setup after loading the view.
}

- (void)fetchData {
    NSDictionary *param = @{
                            @"hisUserId":self.userId,
                            @"curUserId":[User getInstance].uid,
                            };
    [self.service GET:@"/personal/info/getUserDetails" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataDict = responseObject;
        /**图片*/
        NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:responseObject[@"userinfo"][@"pictUrl"]]];
        
        //    cell.avatarImageView.layer.cornerRadius = CGRectGetWidth(cell.avatarImageView.frame) / 2.0;
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:url]];
        self.avatarImageView.clipsToBounds = YES;
        self.realnameLabel.text = [StringUtil toString:responseObject[@"userinfo"][@"realName"]];
        self.companyLabel.text = [StringUtil toString:responseObject[@"userinfo"][@"company"]];
        self.dutyLabel.text = [StringUtil toString:responseObject[@"userinfo"][@"duty"]];
        self.areaLabel.text = [StringUtil toString:responseObject[@"userinfo"][@"area"]];
        if (responseObject[@"investorInfo"] != [NSNull null]) {
            self.investAreaLabel.text = [StringUtil toPlaceHolderString:responseObject[@"investorInfo"][@"investArea"]];
            self.investProcessLabel.text = [StringUtil toPlaceHolderString:responseObject[@"investorInfo"][@"investProcess"]];
            self.investProjectLabel.text = [StringUtil toPlaceHolderString:responseObject[@"investorInfo"][@"investProject"]];
            self.investIdeaLabel.text = [StringUtil toPlaceHolderString:responseObject[@"investorInfo"][@"investIdea"]];
        }
        if ([responseObject[@"isFriend"] boolValue]) {
            self.navigationItem.title = @"好友信息";
        } else {
            self.navigationItem.title = @"用户信息";
        }
        /*4大按钮的显示隐藏*/
        //是投资者
        if ([self.dataDict[@"isInvestor"] boolValue]) {
            self.postProjectButton.hidden = NO;
        } else {
            self.postProjectButton.hidden = YES;
        }
        /*4大标签*/
        self.sameFdsNumLabel.text = self.dataDict[@"userStaticDto"][@"sameFdsNum"];
        self.hisColNumLabel.text = self.dataDict[@"userStaticDto"][@"hisColNum"];
        self.hisAtProjNumLabel.text = self.dataDict[@"userStaticDto"][@"hisAtProjNum"];
        self.hisPostNumLabel.text = self.dataDict[@"userStaticDto"][@"hisPostNum"];
        //是好友
        if ([self.dataDict[@"isFriend"] boolValue]) {
            self.sendMsgButton.hidden = NO;
            self.delFriendButton.hidden = NO;
            self.makeFriendsButton.hidden = YES;
        } else {
            self.sendMsgButton.hidden = YES;
            self.delFriendButton.hidden = YES;
            self.makeFriendsButton.hidden = NO;
        }
        //是自己
        if ([self.userId isEqualToString:[User getInstance].uid]) {
            self.postProjectButton.hidden = YES;
            self.sendMsgButton.hidden = YES;
            self.delFriendButton.hidden = YES;
            self.makeFriendsButton.hidden = YES;
        }
        [self.tableView reloadData];
    } noResult:nil];
}

- (IBAction)sendMsgButtonPress:(id)sender {
//    跳转发消息页面

}

- (IBAction)delFriendButtonPress:(id)sender {
//    刷新原来的单元格/fetchData
    NSDictionary *param = @{
                            @"friendId":self.userId,
                            @"userId":[User getInstance].uid
                            };
    
    [[PXAlertView showAlertWithTitle:@"您确定删除好友吗？" message:nil cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if (!cancelled) {
            [self.service POST:@"personal/friends/delFriend" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                [self fetchData];
            } noResult:nil];
        }
    }] useDefaultIOS7Style];
}

//添加好友
- (IBAction)makeFriendsButtonPress:(id)sender {
    [EYInputPopupView popViewWithTitle:@"好友申请" contentText:@""
                                  type:EYInputPopupView_Type_multi_line
                           cancelBlock:^{
                               
                           } confirmBlock:^(UIView *view, NSString *text) {
                               NSDictionary *param = @{@"UserMessage":[StringUtil dictToJson:@{
                                                                                           @"toUserId":self.userId,
                                                                                           @"userId":[User getInstance].uid,
                                                                                           @"type":@"0",
                                                                                           @"contentType":@"4",
                                                                                           @"title":@"好友申请",
                                                                                           @"content":[NSString stringWithFormat:@"%@请求添加你为好友：%@",self.dataDict[@"userinfo"][@"realName"],text]
                                                                                           }
                                                                   ]};
                               [self.service POST:@"personal/msg/sendMsg" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                               } noResult:nil];
                           } dismissBlock:^{
                               
                           }
     ];
}

- (IBAction)postProjectButton:(id)sender {
//    跳转可投资项目页
}

#pragma mark - tb delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![self.dataDict[@"isInvestor"] boolValue]) {
        if (section == 1) {
            //        针对非投资人的情况，要隐藏那几个单元格
            return 0;
        }
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            //共同好友
            if ([self.dataDict[@"userStaticDto"][@"sameFdsNum"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"暂无共同好友哦"];
                return;
            }
            FriendsListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"friendsList"];
            vc.userId = self.userId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else if (indexPath.section == 3) {
        if (indexPath.row == 0) {
//            收藏文章
            if ([self.dataDict[@"userStaticDto"][@"hisColNum"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"用户暂未收藏文章哦"];
                return;
            }
            MyCollectTableViewController *vc = [[MyCollectTableViewController alloc] init];
            vc.userId = self.userId;
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 1) {
//            关注项目
            if ([self.dataDict[@"userStaticDto"][@"hisAtProjNum"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"用户暂未关注项目哦"];
                return;
            }
            MyProjectTableViewController *vc = [[MyProjectTableViewController alloc] init];
            vc.userId = self.userId;
            vc.SEQ_queryType = @"ATTENTION";
            [self.navigationController pushViewController:vc animated:YES];
        } else if (indexPath.row == 2) {
//            发表帖子
            if ([self.dataDict[@"userStaticDto"][@"hisPostNum"] integerValue] == 0) {
                [SVProgressHUD showSuccessWithStatus:@"用户暂未发表帖子哦"];
                return;
            }
            MySubjectTableViewController *vc = [[MySubjectTableViewController alloc] init];
            vc.userId = self.userId;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
@end

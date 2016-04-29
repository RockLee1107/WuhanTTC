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

@interface UserDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *dutyLabel;
@property (weak, nonatomic) IBOutlet UILabel *investIdeaLabel;
@property (weak, nonatomic) IBOutlet UILabel *investAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *investProcessLabel;
@property (weak, nonatomic) IBOutlet UILabel *investProjectLabel;
@property (weak, nonatomic) IBOutlet LXButton *makeFriendsButton;
@property (weak, nonatomic) IBOutlet LXButton *delFriendButton;
@property (weak, nonatomic) IBOutlet LXButton *postProjectButton;
@property (weak, nonatomic) IBOutlet LXButton *sendMsgButton;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        if (![self.dataDict[@"isInvestor"] boolValue]) {
            if (section == 1) {
//        针对非投资人的情况，要隐藏那几个单元格
            return 0;
        }
    }
    return [super tableView:tableView numberOfRowsInSection:section];
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
//                               NSDictionary *param = @{@"Friends":[StringUtil dictToJson:@{
//                                                                                           @"friendId":self.userId,
//                                                                                           @"userId":[User getInstance].uid
//                                                                                           }
//                                                                   ]};
//                               [self.service POST:@"personal/friends/makeFriends" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                                   [SVProgressHUD showSuccessWithStatus:@"添加成功"];
//                               } noResult:nil];
                               
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
@end

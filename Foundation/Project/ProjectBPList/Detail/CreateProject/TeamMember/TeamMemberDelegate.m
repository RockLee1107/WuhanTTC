//
//  TeamMemberDelegate.m
//  Foundation
//
//  Created by 李志强 on 16/6/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "TeamMemberDelegate.h"
#import "TeamMemberCell.h"
#import "FriendsListViewController.h"
#import "TeamEditTableViewController.h"

@implementation TeamMemberDelegate

#pragma mark - tb代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamMemberCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TeamMemberCell" owner:nil options:nil] firstObject];
    NSDictionary *object = self.dataArray[indexPath.row];
    cell.realName.text = object[@"realName"];
    cell.duty.text = object[@"duty"];
    cell.introduction.text = object[@"introduction"];
    cell.introduction.tag = 666 + indexPath.row;
    
    [cell.picUrl setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", UPLOAD_URL, object[@"pictUrl"]]] placeholderImage:[UIImage imageNamed:@"app_failure_img@2x"]];
    cell.picUrl.layer.cornerRadius = 30;
    cell.picUrl.layer.masksToBounds = YES;
    cell.picUrl.clipsToBounds = YES;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-95, 60, 20, 20)];
    iconImage.image = [UIImage imageNamed:@"menu_create@2x"];
    [headView addSubview:iconImage];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(SCREEN_WIDTH-75, 54, 45, 30);
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [addBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:addBtn];

    return headView;
}

- (void)addBtnClick {
    
    FriendsListViewController *vc = [[UIStoryboard storyboardWithName:@"Friends" bundle:nil] instantiateViewControllerWithIdentifier:@"friendsList"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.memberArray = self.dataArray;
    vc.isFromAdd = YES;
    [self.vc.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    NSDictionary *object = self.dataArray[indexPath.row];
    self.friendId = object[@"parterId"];
    self.idStr = object[@"id"];
    
    TeamMemberCell *cell = (TeamMemberCell *)[tableView cellForRowAtIndexPath:indexPath];
    TeamEditTableViewController *vc = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"team"];
    vc.friendId = self.friendId;
    vc.hidesBottomBarWhenPushed = YES;
    vc.isFromAdd = YES;//入口为此处
    vc.idStr = self.idStr;//修改要传id
    vc.title = @"编辑团队成员";
    vc.projectId = object[@"projectId"];//将点击的成员的projectId传过去 做修改
    
    vc.addDuty = cell.duty.text;
    vc.addName = cell.realName.text;
    vc.intro = cell.introduction.text;
    
    [self.vc.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 84;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UILabel *lab = (UILabel *)[tableView viewWithTag:666 + indexPath.row];
    //自适应获得文本的高度
    lab.numberOfLines = 0 ;
    [lab sizeToFit];
    return lab.frame.size.height + 55;
}

@end

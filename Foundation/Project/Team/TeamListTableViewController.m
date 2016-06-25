//
//  TeamListTableViewController.m
//  Foundation
//
//  Created by HuangXiuJie on 16/4/18.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "TeamListTableViewController.h"
#import "TeamTableViewCell.h"
#import "StatusDict.h"
#import "Masonry.h"
#import "FriendsListViewController.h"
#import "KGModal.h"
#import "LXButton.h"
#import "TeamEditTableViewController.h"
#import "UserDetailViewController.h"
#import "SingletonObject.h"

@interface TeamListTableViewController ()<UITableViewDelegate,UITableViewDataSource,FriendsListViewControllerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (strong,nonatomic) NSString *userId;
@property (strong,nonatomic) NSString *realname;
@property (strong,nonatomic) NSString *pictUrl;
@property (strong,nonatomic) UITextField *dutyTextField;

@end

@implementation TeamListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self fetchData];
}

- (void)fetchData {
    NSDictionary *dict = @{
                           @"sEQ_projectId":[User getInstance].srcId,
                           @"sEQ_visible":[User getInstance].sEQ_visible
                           };
    
    NSString *jsonStr = [StringUtil dictToJson:dict];
    NSDictionary *param = @{@"QueryParams":jsonStr};
    [self.service POST:@"team/getTeamList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:responseObject];
        [self.tableView reloadData];
    } noResult:nil];
}


//返回即刷新数据，将本VC的dataArray传给添加页面
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

//按钮点击
- (void)addButtonPress:(UIButton *)sender {
    FriendsListViewController *vc = [[UIStoryboard storyboardWithName:@"Friends" bundle:nil] instantiateInitialViewController];
    vc.selectDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//点击创友录回调
- (UIViewController *)friendDidSelect:(NSString *)userId realname:(NSString *)realname company:(NSString *)company duty:(NSString *)duty pictUrl:(NSString *)pictUrl {
//    将userId等存到成员变量
    self.userId = userId;
    self.realname = realname;
    self.pictUrl = pictUrl;
    //        弹窗完善资料
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.8, 3 * 50 + 100)];
    view.layer.cornerRadius = 4.0;
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
/*    标签与文本框 */
//    姓名
    UILabel *realnameCaption = [[UILabel alloc] init];
    realnameCaption.text = @"姓名";
    [view addSubview:realnameCaption];
    [realnameCaption mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(40);
        make.top.equalTo(view.mas_top).offset(30 + 0 * 50);
        make.width.mas_equalTo(40);
    }];
    UILabel *realnamelabel = [[UILabel alloc] init];
    realnamelabel.text = realname;
    [view addSubview:realnamelabel];
    [realnamelabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(realnameCaption.mas_right).offset(20);
        make.right.equalTo(view.mas_right).offset(-40);
        make.centerY.equalTo(realnameCaption.mas_centerY);
    }];
//    公司
    UILabel *companyCaption = [[UILabel alloc] init];
    companyCaption.text = @"公司";
    [view addSubview:companyCaption];
    [companyCaption mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(40);
        make.top.equalTo(view.mas_top).offset(30 + 1 * 50);
        make.width.mas_equalTo(40);
    }];
    UILabel *companyLabel = [[UILabel alloc] init];
    companyLabel.text = company;
    [view addSubview:companyLabel];
    [companyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(companyCaption.mas_right).offset(20);
        make.right.equalTo(view.mas_right).offset(-40);
        make.centerY.equalTo(companyCaption.mas_centerY);
    }];
//    职务
    UILabel *dutyCaption = [[UILabel alloc] init];
    dutyCaption.text = @"职务";
    [view addSubview:dutyCaption];
    [dutyCaption mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(40);
        make.top.equalTo(view.mas_top).offset(30 + 2 * 50);
        make.width.mas_equalTo(40);
    }];
    UITextField *dutyTextField = [[UITextField alloc] init];
    dutyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    dutyTextField.text = duty;
    dutyTextField.delegate = self;
    [view addSubview:dutyTextField];
    [dutyTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dutyCaption.mas_right).offset(20);
        make.right.equalTo(view.mas_right).offset(-20);
        make.centerY.equalTo(dutyCaption.mas_centerY);
    }];
//    成员变量指向dutyTextField
    self.dutyTextField = dutyTextField;
//    确认取消按钮
    LXButton *confirmButton = [LXButton buttonWithType:(UIButtonTypeSystem)];
    [confirmButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [view addSubview:confirmButton];
    [confirmButton addTarget:self action:@selector(confirmButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
    [confirmButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom).offset(-30);
        make.left.equalTo(view.mas_left).offset(30);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.3);
        make.height.mas_equalTo(40);
    }];
    LXButton *cancelButton = [LXButton buttonWithType:(UIButtonTypeSystem)];
    [cancelButton setBackgroundColor:[UIColor lightGrayColor]];
    [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    [view addSubview:cancelButton];
    [cancelButton addTarget:self action:@selector(cancelButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
    [cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view.mas_bottom).offset(-30);
        make.right.equalTo(view.mas_right).offset(-30);
        make.width.mas_equalTo(SCREEN_WIDTH * 0.3);
        make.height.mas_equalTo(40);
    }];
    [[KGModal sharedInstance] showWithContentView:view];
    return self;
}

//弹窗提交按钮
- (void)confirmButtonPress:(UIButton *)sender {
    if ([self.dutyTextField.text isEqualToString:@""] ) {
        [SVProgressHUD showErrorWithStatus:@"请输入职务"];
    } else if ([self isExsitUser:self.userId]){
        [SVProgressHUD showErrorWithStatus:@"请不要重复添加团队成员哦"];
        [[KGModal sharedInstance] hide];
    } else {
        [[KGModal sharedInstance] hide];
        NSDictionary *teamDict = @{
                          @"duty": self.dutyTextField.text,
                          @"realName": self.realname,
                          @"parterId": self.userId,
                          @"projectId": self.pid,
                          @"pictUrl": self.pictUrl
                          };
        [self.dataArray addObject:teamDict];
        [self.tableView reloadData];
    }
}

///判断是否存在团队成员
- (BOOL)isExsitUser:(NSString *)uid {
    for (NSDictionary *user in self.dataArray) {
        if ([user[@"parterId"] isEqualToString:uid]) {
            return YES;
        }
    }
    return NO;
}

//弹窗取消按钮
- (void)cancelButtonPress:(UIButton *)sender {
    [[KGModal sharedInstance] hide];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TeamTableViewCell" owner:nil options:nil] firstObject];
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.realnameLabel.text = [StringUtil toString:dict[@"realName"]];
    cell.dutyLabel.text = [StringUtil toString:dict[@"duty"]];
    NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:dict[@"pictUrl"]]];
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:url]];
    cell.avatarImageView.clipsToBounds = YES;
    cell.avatarImageView.layer.cornerRadius = 30;
    cell.avatarImageView.layer.masksToBounds = YES;
    cell.introLabel.text = [StringUtil toString:dict[@"introduction"]];
    cell.introLabel.tag = 777 + indexPath.row;
    if ([User getInstance].isClick == NO) {
        cell.userInteractionEnabled = NO;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UILabel *lab = (UILabel *)[self.view viewWithTag:777 + indexPath.row];
    lab.numberOfLines = 0;
    [lab sizeToFit];
    return lab.frame.size.height + 65;
}

//单行，非本人则跳转编辑页面，返回用户详情页
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *parterId = self.dataArray[indexPath.row][@"parterId"];
    if ([parterId isEqualToString:[User getInstance].uid]) {
//        用户详情
        UserDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Friends" bundle:nil] instantiateViewControllerWithIdentifier:@"userDetail"];
        vc.userId = parterId;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if ([SingletonObject getInstance].isBrowse) {
            //        用户详情
            UserDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Friends" bundle:nil] instantiateViewControllerWithIdentifier:@"userDetail"];
            vc.userId = parterId;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
    //        成员编辑
            TeamEditTableViewController *vc = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"team"];
            vc.parentVC = self;
            vc.dataDict = self.dataArray[indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
@end

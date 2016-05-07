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

@interface TeamListTableViewController ()<UITableViewDelegate,UITableViewDataSource,FriendsListViewControllerDelegate>
@property (nonatomic,strong) UITableView *tableView;

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
    //管理页面
    NSDictionary *param = @{
                            @"projectId":self.pid
                            };
    [self.service GET:@"/project/getProjectDto" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataDict = responseObject;
        if ([self.dataDict[@"createdById"] isEqualToString:[User getInstance].uid]) {
            //            创建者
            //        tb下移
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view.mas_top).offset(40);
            }];
            //        添加按钮
            UIButton *addButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
            [addButton setImage:[UIImage imageNamed:@"app_add"] forState:(UIControlStateNormal)];
            [self.view addSubview:addButton];
            [addButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.view.mas_right).offset(-20);
                make.top.equalTo(self.view.mas_top).offset(20);
                make.width.mas_equalTo(40);
                make.height.mas_equalTo(40);
            }];
            [addButton addTarget:self action:@selector(addButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
            
        }
    } noResult:nil];
    [self fetchData];
}

//按钮点击
- (void)addButtonPress:(UIButton *)sender {
    FriendsListViewController *vc = [[UIStoryboard storyboardWithName:@"Friends" bundle:nil] instantiateInitialViewController];
    vc.selectDelegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//点击创友录回调
- (UIViewController *)friendDidSelect:(NSString *)userId realname:(NSString *)realname company:(NSString *)company duty:(NSString *)duty {
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
    
}

//弹窗取消按钮
- (void)cancelButtonPress:(UIButton *)sender {
    [[KGModal sharedInstance] hide];
}

- (void)fetchData {
    NSDictionary *param = @{@"QueryParams":[StringUtil dictToJson:@{
                                                                    @"SEQ_projectId":self.pid
                                                                    }],
                            @"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service POST:@"team/queryTeamList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataArray = responseObject;
        [self.tableView reloadData];
    } noResult:nil];
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
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

@end

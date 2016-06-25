//
//  ProjectInfoTableViewController.m
//  Foundation
//
//  Created by 李志强 on 16/6/5.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ProjectInfoTableViewController.h"
#import "ProjectBasicInfoViewController.h"
#import "ProductTableViewController.h"
#import "ProcessCreateTableViewController.h"
#import "FriendsListViewController.h"
#import "TeamMemberTableViewController.h"
#import "ProjectProgressTableViewController.h"
#import "FinanceProgressTableViewController.h"

@interface ProjectInfoTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *projectStatus;
@property (weak, nonatomic) IBOutlet UIImageView *productStatus;
@property (weak, nonatomic) IBOutlet UIImageView *memberStatus;
@property (weak, nonatomic) IBOutlet UIImageView *progressStatus;
@property (weak, nonatomic) IBOutlet UIImageView *financeStatus;
@property (weak, nonatomic) IBOutlet UIView *cellContentView;
@property (nonatomic, strong) UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet UILabel *separatorLine;
@property (weak, nonatomic) IBOutlet UILabel *separatorLine2;
@property (weak, nonatomic) IBOutlet UILabel *separatorLine3;
@property (weak, nonatomic) IBOutlet UILabel *separatorLine4;

@property (nonatomic, copy) NSString *select1;//做刷新产品信息勾选状态
@property (nonatomic, copy) NSString *select2;
@property (nonatomic, copy) NSString *select3;
@property (nonatomic, copy) NSString *select4;
@property (nonatomic, copy) NSString *select5;
@property (nonatomic, copy) NSString *projectId;
@property (nonatomic, copy) NSString *srcId;
@property (nonatomic, strong) NSDictionary *requestData;//从服务器请求回来的数据

@property (nonatomic, copy) NSString *bizStatus;//审核状态 0未提交 2:已提交,为2时需要创建副本flag为Yes  1:待审核,进不来  3:驳回

@property (nonatomic, assign) BOOL hasProject;//项目信息勾选状态
@property (nonatomic, assign) BOOL hasProduct;//产品信息
@property (nonatomic, assign) BOOL hasTeam;   //团队成员
@property (nonatomic, assign) BOOL hasProcess;//项目进展
@property (nonatomic, assign) BOOL hasFinance;//融资进展

@end

@implementation ProjectInfoTableViewController

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    
    //YES:入口为更新项目  NO:入口为创建项目
    if (self.isFlag) {
        //做勾选状态判断
        [self loadData];
    }
    
    //刷新勾选状态
    if ([self.select1 isEqualToString:@"ok"]) {
        [self.projectStatus setImage:[UIImage imageNamed:@"app_text_done"]];
    }
    if ([self.select2 isEqualToString:@"ok"]) {
        [self.productStatus setImage:[UIImage imageNamed:@"app_text_done"]];
    }
    if ([self.select3 isEqualToString:@"ok"]) {
        [self.memberStatus setImage:[UIImage imageNamed:@"app_text_done"]];
    }
    if ([self.select4 isEqualToString:@"ok"]) {
        [self.progressStatus setImage:[UIImage imageNamed:@"app_text_done"]];
    }
    if ([self.select5 isEqualToString:@"ok"]) {
        [self.financeStatus setImage:[UIImage imageNamed:@"app_text_done"]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [self.projectStatus setImage:[UIImage imageNamed:@"app_text_undone"]];
    [self.memberStatus setImage:[UIImage imageNamed:@"app_text_undone"]];
    [self.financeStatus setImage:[UIImage imageNamed:@"app_text_undone"]];
    [self.progressStatus setImage:[UIImage imageNamed:@"app_text_undone"]];
    [self.productStatus setImage:[UIImage imageNamed:@"app_text_undone"]];
}

- (void)loadData {
    
    NSDictionary *dict = @{@"projectId":[User getInstance].projectId,@"srcId":[User getInstance].srcId};
    
    [self.service POST:@"project/getBpProject" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.requestData = responseObject;
        
        self.bizStatus = [responseObject[@"bizStatus"] stringValue];
        
        if (![responseObject[@"projectName"] isEqualToString:@""]) {
            [self.projectStatus setImage:[UIImage imageNamed:@"app_text_done"]];
        }
        if ([responseObject[@"hasTeam"] intValue] >= 1) {
            [self.memberStatus setImage:[UIImage imageNamed:@"app_text_done"]];
        }
        if ([responseObject[@"hasFinance"] intValue] >= 1) {
            [self.financeStatus setImage:[UIImage imageNamed:@"app_text_done"]];
        }
        if ([responseObject[@"hasProcess"] intValue] >= 1) {
            [self.progressStatus setImage:[UIImage imageNamed:@"app_text_done"]];
        }
        if ([responseObject[@"hasProduct"] intValue] >= 1) {
            [self.productStatus setImage:[UIImage imageNamed:@"app_text_done"]];
        }
        [self.tableView reloadData];
        
    } noResult:^{
        NSLog(@"22222222222");
    }];
}

- (void)createUI {
    
    self.separatorLine.backgroundColor = SEPARATORLINE;
    self.separatorLine2.backgroundColor = SEPARATORLINE;
    self.separatorLine3.backgroundColor = SEPARATORLINE;
    self.separatorLine4.backgroundColor = SEPARATORLINE;
    self.view.backgroundColor = BACKGROUND_COLOR;
    self.cellContentView.backgroundColor = BACKGROUND_COLOR;
    
    self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commitBtn.frame = CGRectMake(12, SCREEN_HEIGHT-90, SCREEN_WIDTH-24, 44);
    [self.commitBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.commitBtn.backgroundColor = MAIN_COLOR;
    [self.commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commitBtn];
}

//点击提交审核
- (void)commitBtnClick {
    
    //从更新项目入口进入
    if (self.isFlag) {
        if ([self.requestData[@"hasTeam"] intValue] == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写团队成员哦"];
            return;
        }
        if ([self.requestData[@"hasProcess"] intValue] == 0) {
            [SVProgressHUD showErrorWithStatus:@"请填写项目进展哦"];
            return;
        }
    //从创建项目入口进入
    }else {
        if (![self.select1 isEqualToString:@"ok"]) {
            [SVProgressHUD showErrorWithStatus:@"请填写项目信息哦"];
            return;
        }
        if (![self.select3 isEqualToString:@"ok"]) {
            [SVProgressHUD showErrorWithStatus:@"请填写团队成员哦"];
            return;
        }
        if (![self.select4 isEqualToString:@"ok"]) {
            [SVProgressHUD showErrorWithStatus:@"请填写项目进展哦"];
            return;
        }
    }
    
    [SVProgressHUD showWithStatus:@"正在提交审核..."];
    self.commitBtn.userInteractionEnabled = NO;
    
    NSString *pid;
    //这里判断是提交第一次创建时保存在单例的createProjectId 还是更新项目信息返回的副本Id 或 第一次提审的老Id
    if ([User getInstance].projectId != nil && ![[User getInstance].projectId isKindOfClass:[NSNull class]]) {
        pid = [User getInstance].projectId;
    }
    //第一次创建项目时的projectId
    if ([User getInstance].createProjectId != nil && ![[User getInstance].createProjectId isKindOfClass:[NSNull class]] && ![[User getInstance].createProjectId isEqualToString:@""]) {
        pid = [User getInstance].createProjectId;
    }
    NSDictionary *dict = @{@"projectId":pid};
    
    [self.service POST:@"project/pubProject" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [SVProgressHUD dismiss];
        [User getInstance].isCloseItem = YES;//更新项目提交审核后返回到容器，需要关闭更新项目,  创建项目返回的是BP详情
        
        [self.navigationController popViewControllerAnimated:YES];
    } noResult:^{
        
    }];
}

#pragma mark - tb
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    [self.view addSubview:headView];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ima"]];
    iconImageView.frame = CGRectMake(12, 14.5, 16, 16);
    [headView addSubview:iconImageView];
    
    UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, SCREEN_WIDTH-40, 25)];
    remindLabel.text = @"填写项目基本信息后才能继续完善其他项目信息哦";
    remindLabel.font = [UIFont systemFontOfSize:12];
    remindLabel.textColor = [UIColor lightGrayColor];
    [headView addSubview:remindLabel];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //项目信息
    if (indexPath.row == 0) {
        ProjectBasicInfoViewController *vc = [[UIStoryboard storyboardWithName:@"ProjectInfoTableViewController" bundle:nil] instantiateViewControllerWithIdentifier:@"basicInfo"];
        vc.hidesBottomBarWhenPushed = YES;

        NSLog(@"=====11111\n%@", [User getInstance].projectId);
        
        //有projectId就传过去做更新项目 没有则是第一次创建
        if ([User getInstance].projectId != nil && ![[User getInstance].projectId isKindOfClass:[NSNull class]]) {
            vc.projectId = [User getInstance].projectId;
        }
        //返回刷新网络将之前创建存到单例的projectId取出来 传到下个页面进行修改
        if ([User getInstance].createProjectId != nil && ![[User getInstance].createProjectId isEqualToString:@""]) {
            vc.projectId = [User getInstance].createProjectId;
        }
        
        //创建成功后block回调 刷新勾选
        vc.block = ^(NSString *ok){
            self.select1 = ok;
        };
        if ([self.select1 isEqualToString:@"ok"]) {
            self.hasProject = YES;
        }
        //hasProject默认为NO,创建后返回刷新勾选并置为YES,正向传值
        vc.hasProject = self.hasProject;
        
        vc.bizStatus = self.bizStatus;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //产品信息
    if (indexPath.row == 2) {
       
        ProductTableViewController *vc = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"product"];
        vc.hidesBottomBarWhenPushed = YES;
        
        //有老projectId就传过去做更新 没有则是第一次创建
        if (![[User getInstance].srcId isKindOfClass:[NSNull class]] && [User getInstance].srcId != nil) {
            vc.projectId = [User getInstance].srcId;
        }
        
        //创建完项目信息后返回一个(create)projectId存入单例再进去可以修改
        if ([User getInstance].createProjectId != nil && ![[User getInstance].createProjectId isEqualToString:@""]) {
            vc.projectId = [User getInstance].createProjectId;
        }
        
        //创建后block回调刷新勾选
        vc.block = ^(NSString *ok){
            self.select2 = ok;
        };
        if ([self.select2 isEqualToString:@"ok"]) {
            self.hasProduct = YES;
        }
        
        //hasProduct默认为NO,创建后返回刷新勾选并置为YES,正向传值
        vc.hasProduct = self.hasProduct;
        
        [self.navigationController pushViewController:vc animated:YES];

    }
    
    //团队成员
    if (indexPath.row == 3) {
        
        TeamMemberTableViewController *vc = [[TeamMemberTableViewController alloc] init];
        //有projectId就传过去做更新 没有则是第一次创建
        if (![[User getInstance].srcId isKindOfClass:[NSNull class]] && [User getInstance].srcId != nil) {
            vc.projectId = [User getInstance].srcId;
        }
        //创建完项目信息后返回一个(create)projectId存入单例再进去可以修改
        if ([User getInstance].createProjectId != nil && ![[User getInstance].createProjectId isEqualToString:@""]) {
            vc.projectId = [User getInstance].createProjectId;
        }
        //block回调刷新勾选
        vc.block = ^(NSString *ok){
            self.select3 = ok;
        };
        if ([self.select3 isEqualToString:@"ok"]) {
            self.hasTeam = YES;
        }
        //hasTeam默认为NO,创建后返回刷新勾选并置为YES,正向传值
        vc.hasTeam = self.hasTeam;

        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    //项目进展
    if (indexPath.row == 4) {
        
        ProjectProgressTableViewController *vc = [[ProjectProgressTableViewController alloc] init];

        //有老projectId就传过去做更新 没有则是第一次创建
        if (![[User getInstance].srcId isKindOfClass:[NSNull class]] && [User getInstance].srcId != nil) {
            vc.projectId = [User getInstance].srcId;
        }
        //创建完项目信息后返回一个(create)projectId存入单例再进去可以修改
        if ([User getInstance].createProjectId != nil && ![[User getInstance].createProjectId isEqualToString:@""]) {
            vc.projectId = [User getInstance].createProjectId;
        }
        //block回调刷新勾选
        vc.block = ^(NSString *ok){
            self.select4 = ok;
        };
        if ([self.select4 isEqualToString:@"ok"]) {
            self.hasProcess = YES;
        }
        //hasProcess默认为NO,创建后返回刷新勾选并置为YES,正向传值
        vc.hasProcess = self.hasProcess;
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
}
    
    //融资进展
    if (indexPath.row == 5) {
        
        FinanceProgressTableViewController *vc = [[FinanceProgressTableViewController alloc] init];

        //有老projectId就传过去做更新 没有则是第一次创建
        if (![[User getInstance].srcId isKindOfClass:[NSNull class]] && [User getInstance].srcId != nil) {
            vc.projectId = [User getInstance].srcId;
            
        }
        //创建完项目信息后返回一个(create)projectId存入单例再进去可以修改
        if ([User getInstance].createProjectId != nil && ![[User getInstance].createProjectId isEqualToString:@""]) {
            vc.projectId = [User getInstance].createProjectId;
        }
        //block回调刷新勾选
        vc.block = ^(NSString *ok){
            self.select5 = ok;
        };
        if ([self.select5 isEqualToString:@"ok"]) {
            self.hasFinance = YES;
        }
        //hasProcess默认为NO,创建后返回刷新勾选并置为YES,正向传值
        vc.hasFinance = self.hasFinance;
        
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

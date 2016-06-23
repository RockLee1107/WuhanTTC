//
//  SpecialTypeViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.


//              ***********创成长首页***********

#import "SpecialTypeViewController.h"
#import "SubTabBarController.h"
#import "SpecialTypeTableViewCell.h"
#import "DTKDropdownMenuView.h"
#import "ContributeTableViewController.h"
#import "SpecialTTCViewController.h"
//test
//#import "MyActivityPageController.h"

@interface SpecialTypeViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SpecialTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self initItem];
    
    [self initRefreshControl];
    //test
//    MyActivityPageController *pager = [[MyActivityPageController alloc] init];
//    [self.navigationController pushViewController:pager animated:YES];
}

//从子Tab回来时要显示导航栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
//    [self fetchData];
}

//上拉下拉控件
- (void)initRefreshControl {
    /**上拉刷新、下拉加载*/
    __weak typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.page.pageNo = 1;
        [weakSelf fetchData];
        [weakSelf.tableView.header endRefreshing];
    }];
    [self.tableView.legendHeader beginRefreshing];
}

//请求数据
-(void)fetchData {
    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([[User getInstance] isLogin]) {
        
        [dict setObject:[User getInstance].uid forKey:@"SEQ_userId"];
    }
    
    NSDictionary *param = @{@"QueryParams":[StringUtil dictToJson:dict]};
    [self.service GET:@"book/special/querySpecialType" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        self.dataImmutableArray = responseObject;
        
        [self.tableView reloadData];
    } noResult:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataImmutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SpecialTypeTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SpecialTypeTableViewCell" owner:nil options:nil] firstObject];
    cell.thumbImageView.image = [UIImage imageNamed:self.dataImmutableArray[indexPath.row][@"specialCode"]];
    cell.specialNameLabel.text = self.dataImmutableArray[indexPath.row][@"specialName"];
    cell.latestBookNameLabel.text = [StringUtil toString:self.dataImmutableArray[indexPath.row][@"latestBookName"]];
    cell.latestUpdateTimeLabel.text = [DateUtil toShortDate:self.dataImmutableArray[indexPath.row][@"latestUpdateTime"]];
    cell.latestUpdateTimeLabel.text = [@"共" stringByAppendingString:[[StringUtil toString:self.dataImmutableArray[indexPath.row][@"bookSum"]] stringByAppendingString:@"篇"]];
    
    cell.latestUpdateTimeLabel.textColor = MAIN_COLOR;
    
    if ([[User getInstance] isLogin]) {
        //此处返回NSNull
        if ([DateUtil compare:self.dataImmutableArray[indexPath.row][@"latestUpdateTime"] lastRequestTime:self.dataImmutableArray[indexPath.row][@"lastRequestTime"]]) {
            cell.unreadImageView.hidden = YES;
        }
    } else {
        cell.unreadImageView.hidden = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SubTabBarController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"sub"];
    vc.specialCode = self.dataImmutableArray[indexPath.row][@"specialCode"];
    vc.specialName = self.dataImmutableArray[indexPath.row][@"specialName"];
    [self.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

///导航栏下拉菜单
- (void)initItem
{
//    __weak typeof(self) weakSelf = self;
//    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"" iconName:@"app_teamchuang" callBack:^(NSUInteger index, id info) {
//        //如果用户已经登录
//        if ([[User getInstance] isLogin]) {
//             ContributeTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"contribute"];
//             [self.navigationController pushViewController:vc animated:YES];
//        }//提示用户先登录
//        else{
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
//            [alertView show];
//        }
//        
//    }];
    
    
//    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 60.f, 44.f) dropdownItems:nil icon:@"ic_menu" extraIcon:@"app_search" extraButtunCallBack:^{
//        //跳转搜索页
//        [self performSegueWithIdentifier:@"search" sender:nil];
//    }];
//    menuView.cellColor = MENU_COLOR;
//    menuView.cellHeight = 50.0;
//    menuView.dropWidth = 150.f;
//    menuView.titleFont = [UIFont systemFontOfSize:18.f];
//    menuView.textColor = [UIColor blackColor];
//    menuView.cellSeparatorColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
//    menuView.textFont = [UIFont systemFontOfSize:16.f];
//    menuView.animationDuration = 0.4f;
//    menuView.backgroundAlpha = 0;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuView];
    
    
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(0, 4.5, 35, 35);
    [searchBtn setImage:[UIImage imageNamed:@"app_search"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
//
    UIButton *themeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    themeBtn.frame = CGRectMake(15, 12, 20, 20);
    [themeBtn setImage:[UIImage imageNamed:@"app_teamchuang"] forState:UIControlStateNormal];
    [themeBtn addTarget:self action:@selector(themeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:themeBtn];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:themeBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
}

//点击搜索
- (void)searchBtnClick {
    [self performSegueWithIdentifier:@"search" sender:nil];
}

//点击团团创
- (void)themeBtnClick{
    NSLog(@"点击团团创");
    SpecialTTCViewController *vc = [[SpecialTTCViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        //进入团团创登陆页面
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
}

@end

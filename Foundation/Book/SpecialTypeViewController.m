//
//  SpecialTypeViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "SpecialTypeViewController.h"
#import "SubTabBarController.h"
#import "SpecialTypeTableViewCell.h"
#import "DTKDropdownMenuView.h"
//temp import
#import "MyCollectPageController.h"
@interface SpecialTypeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SpecialTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addRightItem];
    [self fetchData];
}

//从子Tab回来时要显示导航栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

-(void)fetchData {
    NSDictionary *param = @{@"QueryParams":[StringUtil dictToJson:@{@"SEQ_userId":[User getInstance].uid}]};
    [self.service GET:@"book/special/querySpecialType" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
}

///导航栏下拉菜单
- (void)addRightItem
{
//    __weak typeof(self) weakSelf = self;
    DTKDropdownItem *item = [DTKDropdownItem itemWithTitle:@"我的收藏" iconName:@"menu_contribute" callBack:^(NSUInteger index, id info) {
        MyCollectPageController *vc = [[MyCollectPageController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
//    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"原创投稿" iconName:@"menu_contribute" callBack:^(NSUInteger index, id info) {
//        [SVProgressHUD showSuccessWithStatus:@"^_^"];
//    }];
//    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"推荐好文" iconName:@"menu_essential" callBack:^(NSUInteger index, id info) {
//        [SVProgressHUD showSuccessWithStatus:@"^_^"];
//    }];
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 60.f, 44.f) dropdownItems:@[item] icon:@"ic_menu" extraIcon:@"app_search" extraButtunCallBack:^{
        //跳转搜索页
        [self performSegueWithIdentifier:@"search" sender:nil];
    }];
    menuView.cellColor = MAIN_COLOR;
    menuView.cellHeight = 50.0;
    menuView.dropWidth = 150.f;
    menuView.titleFont = [UIFont systemFontOfSize:18.f];
    menuView.textColor = [UIColor whiteColor];
    menuView.cellSeparatorColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    menuView.textFont = [UIFont systemFontOfSize:16.f];
    menuView.animationDuration = 0.4f;
    menuView.backgroundAlpha = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuView];
}

@end

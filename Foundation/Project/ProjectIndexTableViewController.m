//
//  ProjectIndexTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//


/***创投融***/

#import "ProjectIndexTableViewController.h"
#import "ProjectTableViewDelegate.h"
#import "InvestorListViewController.h"
#import "ImageBrowserViewController.h"
#import "ProjectBPViewController.h"
#import "ProjectListViewController.h"

@interface ProjectIndexTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *wrappedTableView;//热门项目下的TableView
@property (weak, nonatomic) IBOutlet UILabel *projectCountLabel;//项目数
@property (weak, nonatomic) IBOutlet UILabel *investorCountLabel;//投资人数
@end

@implementation ProjectIndexTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDelegate];
    [self initRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = NO;
}

//上拉下拉控件
- (void)initRefreshControl {
    /**上拉刷新、下拉加载*/
    __weak typeof(self) weakSelf = self;
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    [self.wrappedTableView addLegendHeaderWithRefreshingBlock:^{
        weakSelf.page.pageNo = 1;
        [weakSelf fetchData];
        [weakSelf.wrappedTableView.header endRefreshing];
    }];
    [self.wrappedTableView.legendHeader beginRefreshing];
    [self.wrappedTableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.page.pageNo++;
        [weakSelf fetchData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [weakSelf.wrappedTableView.footer endRefreshing];
    }];
    
}

//初始化代理
- (void)initDelegate {
    self.tableViewDelegate = [[ProjectTableViewDelegate alloc] init];
    self.tableViewDelegate.vc = self;
    self.wrappedTableView.delegate = self.tableViewDelegate;
    self.wrappedTableView.dataSource = self.tableViewDelegate;
}

/**创连接项目*/
- (void)fetchData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                   //                                  @"SEQ_typeCode":@"",
                                   //                                  @"IIN_status":@"2",
                                   //                                  @"SEQ_city":@0,
                                   //                                   @"SEQ_orderBy":@"pbDate"//（pbDate发布时间，planDate活动开始时间，applyNum参与数
                                   }];
    NSString *jsonStr = [StringUtil dictToJson:dict];
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [self.service GET:@"project/getHomePage" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if (self.page.pageNo == 1) {
            //由于下拉刷新时页面而归零
            [self.tableViewDelegate.dataArray removeAllObjects];
            [self.wrappedTableView.footer resetNoMoreData];
        }
        [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject[@"hotProject"]];
        self.projectCountLabel.text = responseObject[@"projectCount"];
        self.investorCountLabel.text = responseObject[@"investorCount"];
        [self.wrappedTableView reloadData];
        //为了刷新表格总高度
        [self.tableView reloadData];
    } noResult:^{
        [self.wrappedTableView.footer noticeNoMoreData];
    }];
}
#pragma mark - tb delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 1) {
        return self.tableViewDelegate.dataArray.count * 80.0;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    ProjectListViewController *vc = segue.destinationViewController;
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //先去掉
//    //点击项目BP
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        ProjectBPViewController *bpVC = [[ProjectBPViewController alloc] init];
//        [self.navigationController pushViewController:bpVC animated:YES];
//    }
    
//    //点击项目   sb牵线自动跳转的
//    if (indexPath.section == 0 && indexPath.row == 0) {

//        
//    }
    
    //点击投资人
    if (indexPath.section == 0 && indexPath.row == 1) {
        InvestorListViewController *vc = [[UIStoryboard storyboardWithName:@"Investor" bundle:nil] instantiateInitialViewController];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

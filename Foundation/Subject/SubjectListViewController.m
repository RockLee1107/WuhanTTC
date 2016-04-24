//
//  SubjecListViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "SubjectListViewController.h"
#import "SubjectDetailTableViewController.h"
#import "SubjectTableViewDelegate.h"
#import "SubTabBarController.h"

@interface SubjectListViewController ()
//@property (strong, nonatomic) BaseTableView *tableView;
@end

@implementation SubjectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self initDelegate];
    [self initRefreshControl];
}

//代码生成表格
- (void)initTableView {
//    self.tableView = [[BaseTableView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:self.tableView];
    [self setDynamicLayout];
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
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.page.pageNo++;
        [weakSelf fetchData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [weakSelf.tableView.footer endRefreshing];
    }];
    
}

//初始化代理
- (void)initDelegate {
    self.tableViewDelegate = [[SubjectTableViewDelegate alloc] init];
    self.tableViewDelegate.vc = self;
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDelegate;
}

/**访问网络*/
- (void)fetchData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                   @"SEQ_specialCode":((SubTabBarController *)self.tabBarController).specialCode
                                   }];
    NSArray *array = [self.condition componentsSeparatedByString:@"|"];
    //硬编码@"1"
    if([[array lastObject] isEqualToString:@"1"]) {
        [dict setObject:[array firstObject] forKey:@"SEQ_orderBy"];
        [dict setObject:[array lastObject] forKey:@"IEQ_isEssence"];
    } else {
        [dict setObject:self.condition forKey:@"SEQ_orderBy"];
    }
    NSString *jsonStr = [StringUtil dictToJson:dict];
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service GET:@"/book/postSubject/queryPostSubject" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.page.pageNo == 1) {
            //由于下拉刷新时页面而归零
            [self.tableViewDelegate.dataArray removeAllObjects];
            [self.tableView.footer resetNoMoreData];
        }
        //当小于每页条数，就判定加载完毕
        if ([responseObject count] < self.page.pageSize) {
            [self.tableView.footer noticeNoMoreData];
        }
        [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
        [self.tableView reloadData];
    } noResult:^{
        [self.tableView.footer noticeNoMoreData];
    }];
}

//- (void)jumpDetailTest {
//    SubjectDetailTableViewController *vc = [[UIStoryboard storyboardWithName:@"Book" bundle:nil] instantiateViewControllerWithIdentifier:@"subjectDetail"];
//    [self.navigationController pushViewController:vc animated:YES];
//}

@end

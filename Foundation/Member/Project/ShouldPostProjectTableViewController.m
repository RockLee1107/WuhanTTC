//
//  MyProjectTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ShouldPostProjectTableViewController.h"
#import "ShouldPostProjectTableViewDelegate.h"

@interface ShouldPostProjectTableViewController ()

@end

@implementation ShouldPostProjectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDelegate];
    [self initRefreshControl];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.navigationItem.title = @"选择项目";
    // Do any additional setup after loading the view.
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
    self.tableViewDelegate = [[ShouldPostProjectTableViewDelegate alloc] init];
    self.tableViewDelegate.vc = self;
    ((ShouldPostProjectTableViewDelegate *)self.tableViewDelegate).financeId = self.financeId;
    //    硬编码判断类型，先行强转
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDelegate;
}

/**创连接项目*/
- (void)fetchData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                   //                                  @"SEQ_typeCode":@"",
//                                                                     @"IEQ_status":@"2",
                                   //                                  @"SEQ_city":@0,
                                   //                                   @"SEQ_orderBy":@"pbDate"//（pbDate发布时间，planDate活动开始时间，applyNum参与数
                                   @"SEQ_userId":[User getInstance].uid,
                                   @"SEQ_queryType":@"CREATE"
                                   }];
    NSString *jsonStr = [StringUtil dictToJson:dict];
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service GET:@"/project/queryProjectList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.page.pageNo == 1) {
            //由于下拉刷新时页面而归零
            [self.tableViewDelegate.dataArray removeAllObjects];
            [self.tableView.footer resetNoMoreData];
        }
        [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
        [self.tableView reloadData];
    } noResult:^{
        [self.tableView.footer noticeNoMoreData];
    }];
}

@end

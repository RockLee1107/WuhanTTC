//
//  MyCollectTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "MyCollectTableViewController.h"
#import "BookListDelegate.h"

@interface MyCollectTableViewController ()

@end

@implementation MyCollectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDynamicLayout];
    [self initDelegate];
    [self initRefreshControl];
    [self fetchData];
    self.navigationItem.title = @"收藏文章";
}

//初始化代理
- (void)initDelegate {
    self.tableViewDelegate = [[BookListDelegate alloc] init];
    self.tableViewDelegate.vc = self;
    //    先行强转
    BookListDelegate *tableViewDelegate = (BookListDelegate *)self.tableViewDelegate;
    if (self.userId) {
        //self.userId代表从创友录等用户资料点击而进来的
        tableViewDelegate.shouldEditing = NO;
    } else {
        tableViewDelegate.shouldEditing = YES;
    }
    self.tableViewDelegate = tableViewDelegate;
    
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDelegate;
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

///请求网络
- (void)fetchData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"SEQ_collectUserId":self.userId != nil ? self.userId : [User getInstance].uid                                                                     }];
    
    if (self.specialCode != nil) {
        [dict setObject:self.specialCode forKey:@"SEQ_specialCode"];
    }
    NSDictionary *param =  @{@"QueryParams":[StringUtil dictToJson:dict],
                             @"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service GET:@"book/searchSpBookList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if (self.page.pageNo == 1) {
            //由于下拉刷新时页面而归零
            [self.tableViewDelegate.dataArray removeAllObjects];
            [self.tableView.footer resetNoMoreData];
        }
        //返回总条数
        if (!self.userId && self.specialCode == nil) {
            //self.userId代表从创友录等用户资料点击而进来的
            ((BookListDelegate *)self.tableViewDelegate).num = responseObject[@"totalCount"];
        }
        //当小于每页条数，就判定加载完毕
        if ([responseObject[@"result"] count] < self.page.pageSize) {
            [self.tableView.footer noticeNoMoreData];
        }
        [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject[@"result"]];
        [self.tableView reloadData];
    } noResult:^{
        if (self.page.pageNo == 1) {
            [self.tableViewDelegate.dataArray removeAllObjects];
            [self.tableView reloadData];
        }
        [self.tableView.footer noticeNoMoreData];
    }];
}
@end

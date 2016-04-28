//
//  UserSearchViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/28.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "UserSearchViewController.h"
#import "UserTableViewDelegate.h"

@interface UserSearchViewController ()<UISearchBarDelegate ,UISearchDisplayDelegate>
@property (strong,nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString *keyWords;
@end

@implementation UserSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self initRefreshControl];
    [self initDelegate];
    self.searchBar.delegate = self;
    if (self.keyWords == nil) {
        self.tableView.hidden = YES;
    }
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
    //    [self.tableView.legendHeader beginRefreshing];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.page.pageNo++;
        [weakSelf fetchData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [weakSelf.tableView.footer endRefreshing];
    }];
}

//初始化代理
- (void)initDelegate {
    self.tableViewDelegate = [[UserTableViewDelegate alloc] init];
    self.tableViewDelegate.vc = self;
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDelegate;
}

#pragma mark - search delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    self.keyWords = searchBar.text;
    [searchBar resignFirstResponder];
    self.tableView.hidden = NO;
    [self fetchData];
}

///请求网络
- (void)fetchData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if ([VerifyUtil isMobile:self.keyWords]) {
        [dict setObject:self.keyWords forKey:@"SEQ_mobile"];
    } else {
        [dict setObject:self.keyWords forKey:@"SLIKE_realName"];
    }
    
    NSDictionary *param =  @{@"QueryParams":[StringUtil dictToJson:dict],
                             @"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service GET:@"personal/info/getUserDetailsList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        if (self.page.pageNo == 1) {
            [self.tableViewDelegate.dataArray removeAllObjects];
            [self.tableView reloadData];
        }
        [self.tableView.footer noticeNoMoreData];
    }];
}

@end
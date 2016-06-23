//
//  TTCSpecialViewController.m
//  Foundation
//
//  Created by 李志强 on 16/6/8.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "TTCSpecialViewController.h"
#import "TTCSpecialDelegate.h"

@interface TTCSpecialViewController ()

@end

@implementation TTCSpecialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setDynamicLayout];
    [self initDelegate];
    [self initRefreshControl];
    [self fetchData];
    self.navigationItem.title = @"动态";
}

//初始化代理
- (void)initDelegate {
    self.tableViewDelegate = [[TTCSpecialDelegate alloc] init];
    self.tableViewDelegate.vc = self;
    //    先行强转
    TTCSpecialDelegate *tableViewDelegate = (TTCSpecialDelegate *)self.tableViewDelegate;

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
                                                                                @"sEQ_categoryCode":@"zl99c1",
                                                                                @"sEQ_specialCode":@"zl99"
                                                                                }];
    

    NSDictionary *param =  @{@"QueryParams":[StringUtil dictToJson:dict],
                             @"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service GET:@"book/searchSpBookList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if (self.page.pageNo == 1) {
            //由于下拉刷新时页面而归零
            [self.tableViewDelegate.dataArray removeAllObjects];
            [self.tableView.footer resetNoMoreData];
        }
//        //返回总条数
//        if (!self.userId && self.specialCode == nil) {
//            //self.userId代表从创友录等用户资料点击而进来的
//            ((BookListDelegate *)self.tableViewDelegate).num = responseObject[@"totalCount"];
//        }
//        //当小于每页条数，就判定加载完毕
//        if ([responseObject[@"result"] count] < self.page.pageSize) {
//            [self.tableView.footer noticeNoMoreData];
//        }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

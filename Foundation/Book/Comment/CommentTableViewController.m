//
//  CommentTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/22.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "CommentTableViewController.h"
//#import "CommentTableViewDelegate.h"
#import "DTKDropdownMenuView.h"
#import "EYInputPopupView.h"
#import "CommentTableViewCell.h"

@interface CommentTableViewController ()
//@property (nonatomic, strong) CommentTableViewDelegate *commentTableViewDelegate;
@end

@implementation CommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评论";
    [self addRightItem];
    [self initRefreshControl];
    [self fetchData];
    // Do any additional setup after loading the view.
}

//上拉下拉控件
- (void)initRefreshControl {
    /**上拉刷新、下拉加载*/
    __weak typeof(self) weakSelf = self;
    [self.tableView.legendHeader beginRefreshing];
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        weakSelf.page.pageNo++;
        [weakSelf fetchData];
        // 拿到当前的上拉刷新控件，结束刷新状态
        [weakSelf.tableView.footer endRefreshing];
    }];
    
}

/**访问网络*/
- (void)fetchData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                @"SEQ_bookId":self.bookId,
                                                                                @"SEQ_orderBy":@"createdDate"
                                                                                }];
    NSDictionary *param =  @{@"QueryParams":[StringUtil dictToJson:dict],
                             @"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service GET:@"book/comment/getComments" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (self.page.pageNo == 1) {
            //由于下拉刷新时页面而归零
            [self.tableViewDelegate.dataArray removeAllObjects];
            [self.tableView.footer resetNoMoreData];
        }
//        [self.tableViewDelegate.dataArray addObjectsFromArray:responseObject];
        NSLog(@"%@!",responseObject);
        [self.tableView reloadData];
    } noResult:^{
        [self.tableView.footer noticeNoMoreData];
    }];
}

///导航栏下拉菜单
- (void)addRightItem
{
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"我的评论" iconName:@"menu_mine" callBack:^(NSUInteger index, id info) {
        
    }];
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"写评论" iconName:@"app_create" callBack:^(NSUInteger index, id info) {
        [EYInputPopupView popViewWithTitle:@"评论帖子" contentText:@"请填写评论内容(1-500字)"
                                      type:EYInputPopupView_Type_multi_line
                               cancelBlock:^{
                                   
                               } confirmBlock:^(UIView *view, NSString *text) {
                                   if (![VerifyUtil isValidStringLengthRange:text between:1 and:200]) {
                                       [SVProgressHUD showErrorWithStatus:@"请评论回复内容(1-500字)"];
                                       return ;
                                   }
                                   NSDictionary *param = @{
                                                           @"BookComment":[StringUtil dictToJson:@{
                                                                                                   @"bookId":self.bookId,
                                                                                                   @"userId":[User getInstance].uid,
                                                                                                   @"comment":text,
                                                                                                   }]
                                                           };
                                   [self.service POST:@"book/comment/addComment" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                                   } noResult:nil];
                               } dismissBlock:^{
                                   
                               }
         ];
    }];
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 60.f, 44.f) dropdownItems:@[item0,item1] icon:@"ic_menu"];
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

#pragma mark - tb delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:nil options:nil] firstObject];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning plus
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //muti line
    return 44.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //热门评论、我的评论分别占一组
    return 2;
}
@end

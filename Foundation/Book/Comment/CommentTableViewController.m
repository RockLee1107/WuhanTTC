//
//  CommentTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/22.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "CommentTableViewController.h"
#import "DTKDropdownMenuView.h"
#import "EYInputPopupView.h"
#import "CommentTableViewCell.h"
#import "BookSearchTableViewCell.h"
#import "CaptionButton.h"
#define MY_COMMENT @"我的评论"
#define ALL_COMMENT @"全部评论"
@interface CommentTableViewController ()
@property (nonatomic,assign) BOOL flag;
@property (nonatomic,strong) DTKDropdownMenuView *menuView;
@property (nonatomic,strong) NSMutableArray *allCommentsArray;
@end

@implementation CommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightItem];
    [self initRefreshControl];
    [self fetchData];
#warning del
    self.page.pageSize = 10;
    self.allCommentsArray = [NSMutableArray array];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

//上拉下拉控件
- (void)initRefreshControl {
    /**上拉刷新、下拉加载*/
    __weak typeof(self) weakSelf = self;
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
    if (self.flag) {
        [dict setObject:[User getInstance].uid forKey:@"SEQ_userId"];
    } else {
        [dict removeObjectForKey:@"SEQ_userId"];
    }
    NSDictionary *param =  @{@"QueryParams":[StringUtil dictToJson:dict],
                             @"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service GET:@"book/comment/getComments" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //当小于每页条数，就判定加载完毕
        if ([responseObject[@"allComments"] count] < self.page.pageSize) {
            [self.tableView.footer noticeNoMoreData];
        }
//        这里不需要判断下拉刷新情况
//        给dataDict赋值，热门评论用
        self.dataDict = responseObject;
        [self.allCommentsArray addObjectsFromArray:responseObject[@"allComments"]];
        [self.tableView reloadData];
    } noResult:^{
        if (self.page.pageNo == 1) {
            [self.allCommentsArray removeAllObjects];
            [self.tableView reloadData];
        }
        [self.tableView.footer noticeNoMoreData];
    }];
}

///切换我的评论或全部评论
- (void)switchMyOrAllComment {
    //self.flag作为我的评论与全部评论的标识
    DTKDropdownItem *commentItem = [self.menuView.items firstObject];
    commentItem.title = self.flag ? MY_COMMENT : ALL_COMMENT;
    self.flag = !self.flag;
    //访问网络
    self.page.pageNo = 1;
    [self fetchData];
}

///导航栏下拉菜单
- (void)addRightItem
{
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:MY_COMMENT iconName:@"menu_mine" callBack:^(NSUInteger index, id info) {
        [self switchMyOrAllComment];
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
    self.menuView = menuView;
}

#pragma mark - tb delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //hot or all comments,because of section 0 or 1
    NSArray *array = indexPath.section == 0 ? self.dataDict[@"hotComments"] : self.allCommentsArray;
    NSDictionary *dict = array[indexPath.row];
    CommentTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:nil options:nil] firstObject];
    cell.avatarImageView.clipsToBounds = YES;
    cell.avatarImageView.layer.cornerRadius = CGRectGetWidth(cell.avatarImageView.frame) / 2.0;
    NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:dict[@"pictUrl"]]];
    [cell.avatarImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"logo.png"]];
    cell.realnameLabel.text = dict[@"realName"];
    cell.praiseCountLabel.text = [dict[@"praiseCount"] stringValue];
    cell.pbtimeLabel.text = [DateUtil toShortDateCN:dict[@"pbDate"] time:dict[@"pbTime"]];
    cell.contentLabel.text = [StringUtil toString:dict[@"comment"]];
    return cell;
}

//表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CaptionButton *caption = [CaptionButton buttonWithType:(UIButtonTypeSystem)];
    caption.frame = CGRectMake(14, 14, 121, 25);
    [caption setTitle:section == 0 ? @"热门评论" : @"全部评论" forState:(UIControlStateNormal)];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:caption];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? [self.dataDict[@"hotComments"] count] : [self.allCommentsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //muti line
    return 80.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //热门评论、我的评论分别占一组
    return 2;
}
@end

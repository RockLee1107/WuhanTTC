//
//  MyNoteTableViewController.m
//  Foundation
//  按时间笔记
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "MyNoteTableViewController.h"
#import "NoteTableViewCell.h"
#import "EYInputPopupView.h"
#import "Masonry.h"

@interface MyNoteTableViewController ()

@end

@implementation MyNoteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDynamicLayout];
    [self initRefreshControl];
    [self fetchData];
    self.navigationItem.title = @"我的笔记";
}

- (void)edit:(NSDictionary *)info{
    NSLog(@"info:%@",info);
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
                                                                                @"SEQ_userId":[User getInstance].uid                                                                     }];
    
    if (self.bookId != nil) {
        [dict setObject:self.bookId forKey:@"SEQ_bookId"];
    }
    NSDictionary *param =  @{@"QueryParams":[StringUtil dictToJson:dict],
                             @"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service GET:@"personal/notebook/getNoteList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        if (self.page.pageNo == 1) {
            //由于下拉刷新时页面而归零
            [self.dataMutableArray removeAllObjects];
            [self.tableView.footer resetNoMoreData];
        }
        //当小于每页条数，就判定加载完毕
        if ([responseObject[@"noteBooks"] count] < self.page.pageSize) {
            [self.tableView.footer noticeNoMoreData];
        }
        [self.dataMutableArray addObjectsFromArray:responseObject[@"noteBooks"]];
        [self.tableView reloadData];
    } noResult:^{
        if (self.page.pageNo == 1) {
            [self.dataMutableArray removeAllObjects];
            [self.tableView reloadData];
        }
        [self.tableView.footer noticeNoMoreData];
    }];
}

#pragma mark - tb delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataMutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataMutableArray[indexPath.row];
    NoteTableViewCell *cell;
    if ([dict[@"excerptType"] integerValue] == 0) {
        //0为图片，1为文字
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NoteTableViewCell" owner:nil options:nil] firstObject];
        //加载图片
        NSString *url = [StringUtil toString:dict[@"bookExcerpt"]];
        cell.avatarImageView.clipsToBounds = YES;
        [cell.avatarImageView setImageWithURL:[NSURL URLWithString:url]];
    } else if ([dict[@"excerptType"] integerValue] == 1) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NoteTableViewCell" owner:nil options:nil] lastObject];
        //加载摘录
        cell.bookExcerptLabel.text = [StringUtil toString:dict[@"bookExcerpt"]];
    }
    cell.bookExcerptLabel.text = [StringUtil toString:dict[@"bookExcerpt"]];
    cell.remarkLabel.text = dict[@"remark"];
    cell.bookNameLabel.text = [StringUtil toString:dict[@"bookName"]];
    cell.createdDatetimeLabel.text = [DateUtil toString:dict[@"createdDate"] time:self.dataArray[indexPath.row][@"createdTime"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataMutableArray[indexPath.row];
    //EY对话框
    [EYInputPopupView popViewWithTitle:@"修改笔记" contentText:dict[@"remark"]
                                  type:EYInputPopupView_Type_multi_line
                           cancelBlock:^{
                               
                           } confirmBlock:^(UIView *view, NSString *text) {
                               if (![VerifyUtil isValidStringLengthRange:text between:1 and:500]) {
                                   [SVProgressHUD showErrorWithStatus:@"摘录文字限500字以内哦"];
                                   return ;
                               }
                               //        访问网络
                               NSDictionary *param = @{
                                                       @"NoteBook":[StringUtil dictToJson:@{
                                                                                            @"id":dict[@"id"],
                                                                                            @"bookExcerpt":dict[@"bookExcerpt"],
                                                                                            @"bookId":dict[@"bookId"],
                                                                                            @"bookName":dict[@"bookName"],
                                                                                            @"excerptType":dict[@"excerptType"],
                                                                                            @"userId":[User getInstance].uid,
                                                                                            @"remark":text
                                                                                            }]
                                                       };
                               [[HttpService getInstance] POST:@"personal/notebook/saveNote" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                                   self.page.pageNo = 1;
                                   [self fetchData];
                               } noResult:nil];
                           } dismissBlock:^{
                               
                           }
     ];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

//单元格删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataMutableArray[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *param = @{
                                @"noteId":dict[@"id"],
                                @"delType":@"noteId"
                                };
        [self.service POST:@"personal/notebook/delNoteBook" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            tableView.editing = NO;
            self.page.pageNo = 1;
            [self fetchData];
        } noResult:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60.0)];
//    小图标
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_collect.png"]];
    [view addSubview:imageView];//需先加入view中，不然报找不到super view的错误
//    总计
    UILabel *totalLabel = [[UILabel alloc] init];
    totalLabel.text = @"总计";
    totalLabel.textColor = [UIColor darkGrayColor];
    totalLabel.font = [UIFont systemFontOfSize:14.0];
    [view addSubview:totalLabel];
//    数值
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.text = @"22";
    numLabel.textColor = [UIColor redColor];
    numLabel.font = [UIFont systemFontOfSize:20.0];
    [view addSubview:numLabel];
//    条
    UILabel *unitLabel = [[UILabel alloc] init];
    unitLabel.text = @"条";
    unitLabel.textColor = [UIColor darkGrayColor];
    unitLabel.font = [UIFont systemFontOfSize:14.0];
    [view addSubview:unitLabel];
//    app_comment@2x
//    图标布局
    [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(view.mas_leading.layoutAttribute + 10);
        make.centerY.mas_equalTo(view.mas_centerY);
        make.width.mas_equalTo(21.0);
        make.height.mas_equalTo(21.0);
    }];
//    总计布局
    [totalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageView.mas_right).with.offset(10);
        make.centerY.mas_equalTo(view.mas_centerY);
        make.width.mas_equalTo(30.0);
    }];
//    数值布局
    [numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(totalLabel.mas_right).with.offset(10);
//        make.width.mas_equalTo(40.0);
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
//    条布局
    [unitLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(numLabel.mas_right).with.offset(10);
        make.centerY.mas_equalTo(view.mas_centerY);
        make.width.mas_equalTo(20.0);
    }];
    return view;
}
@end

//
//  BookListDelegate.m
//  Foundation
//
//  Created by Dotton on 16/3/25.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BookListDelegate.h"
#import "BookTableViewCell.h"
#import "BookDetailViewController.h"
#import "HttpService.h"
#import "MyCollectTableViewController.h"
#import "NoteOrCollectTableHeaderView.h"

@implementation BookListDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BookTableViewCell" owner:nil options:nil] firstObject];
    cell.bookNameLabel.text = [StringUtil toString:self.dataArray[indexPath.row][@"bookName"]];
//    cell.bookTypeLabel.text = BOOK_TYPE_TEXT[self.dataArray[indexPath.row][@"bookType"]];
//    cell.bookTypeLabel.backgroundColor = BOOK_TYPE_COLOR[self.dataArray[indexPath.row][@"bookType"]];
    [cell.bookTypeButton setTitle:BOOK_TYPE_TEXT[self.dataArray[indexPath.row][@"bookType"]] forState:(UIControlStateNormal)];
    [cell.bookTypeButton setBackgroundColor:BOOK_TYPE_COLOR[self.dataArray[indexPath.row][@"bookType"]]];
    
    cell.publishDate.text = [DateUtil toString:self.dataArray[indexPath.row][@"publishDate"]];
    //    多标签转换字符串
//    cell.bookLabelLabel.text = [StringUtil labelArrayToStr:self.dataArray[indexPath.row][@"labels"]];
    cell.bookLabelLabel.text = [StringUtil toString:self.dataArray[indexPath.row][@"labelNames"]];

    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Book" bundle:nil] instantiateViewControllerWithIdentifier:@"detail"];
    vc.bookId = self.dataArray[indexPath.row][@"bookId"];
    [self.vc.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

//可编辑-包括左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.shouldEditing) {
        return YES;
    }
    return NO;
}

//单元格删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *param = @{
                                @"bookId":dict[@"bookId"],
                                @"delType":@"bookId"
                                };
        [[HttpService getInstance] POST:@"personal/collect/cancelCollect" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"删除成功"];
            tableView.editing = NO;
            MyCollectTableViewController *vc = (MyCollectTableViewController *)self.vc;
            vc.page.pageNo = 1;
            [vc fetchData];
        } noResult:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    //以此作为是否显示表头的依据
    if (self.num) {
        return 60.0;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.num) {
        NoteOrCollectTableHeaderView *view = [[NoteOrCollectTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60.0) icon:@"app_comment" num:self.num];
        return view;
    }
    return [UIView new];
}
@end

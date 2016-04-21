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
    BookDetailViewController *vc = [self.vc.storyboard instantiateViewControllerWithIdentifier:@"detail"];
    vc.bookId = self.dataArray[indexPath.row][@"bookId"];
    [self.vc.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
@end

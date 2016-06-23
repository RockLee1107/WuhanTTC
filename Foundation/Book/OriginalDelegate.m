//
//  OriginalDelegate.m
//  Foundation
//
//  Created by 李志强 on 16/6/9.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "OriginalDelegate.h"
#import "BookDetailViewController.h"
#import "BookTableViewCell.h"

@implementation OriginalDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BookTableViewCell" owner:nil options:nil] firstObject];
    cell.bookNameLabel.text = [StringUtil toString:self.dataArray[indexPath.row][@"bookName"]];
    cell.bookLabelLabel.text = [StringUtil toString:self.dataArray[indexPath.row][@"labelNames"]];
    cell.publishDate.text = [DateUtil toString:[self.dataArray[indexPath.row][@"publishDate"] substringToIndex:8]];

    if ([self.dataArray[indexPath.row][@"bookType"] isEqualToString:@"DOC"]) {
        [cell.bookTypeButton setTitle:BOOK_TYPE_TEXT[self.dataArray[indexPath.row][@"bookType"]] forState:(UIControlStateNormal)];
        cell.bookTypeButton.backgroundColor = DOC_COLOR;
    }else if ([self.dataArray[indexPath.row][@"bookType"] isEqualToString:@"VIDEO"]) {
        [cell.bookTypeButton setTitle:BOOK_TYPE_TEXT[self.dataArray[indexPath.row][@"bookType"]] forState:(UIControlStateNormal)];
        cell.bookTypeButton.backgroundColor = VIDEO_COLOR;
    }else if ([self.dataArray[indexPath.row][@"bookType"] isEqualToString:@"PPT"]) {
        [cell.bookTypeButton setTitle:BOOK_TYPE_TEXT[self.dataArray[indexPath.row][@"bookType"]] forState:(UIControlStateNormal)];
        cell.bookTypeButton.backgroundColor = PPT_COLOR;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Book" bundle:nil] instantiateViewControllerWithIdentifier:@"detail"];
    vc.bookId = self.dataArray[indexPath.row][@"bookId"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.vc.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end

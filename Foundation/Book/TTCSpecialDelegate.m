//
//  TTCSpecialDelegate.m
//  Foundation
//
//  Created by 李志强 on 16/6/8.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "TTCSpecialDelegate.h"
#import "TTCSpecialCell.h"
#import "BookDetailViewController.h"

@implementation TTCSpecialDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTCSpecialCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TTCSpecialCell" owner:nil options:nil] firstObject];
    cell.bookName.text = [StringUtil toString:self.dataArray[indexPath.row][@"bookName"]];
    
    cell.publishDate.text = [DateUtil toString:[self.dataArray[indexPath.row][@"publishDate"] substringToIndex:8]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BookDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Book" bundle:nil] instantiateViewControllerWithIdentifier:@"detail"];
    vc.bookId = self.dataArray[indexPath.row][@"bookId"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.vc.navigationController pushViewController:vc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end

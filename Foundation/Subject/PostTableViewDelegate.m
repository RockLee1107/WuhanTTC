//
//  PostTableViewDelegate.m
//  Foundation
//
//  Created by Dotton on 16/3/31.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "PostTableViewDelegate.h"
#import "PostTableViewCell.h"
#import "SubjectDetailTableViewController.h"

@interface PostTableViewDelegate()
@end

@implementation PostTableViewDelegate

#pragma mark - tb代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"post"];
    NSDictionary *object = self.dataArray[indexPath.row];
    /**图片*/
    [cell.thumbImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:object[@"pictUrl"]]]]];
    cell.thumbImageView.clipsToBounds = YES;
    cell.thumbImageView.layer.cornerRadius = 10.0;
    /**作者*/
    cell.realnameLabel.text = [StringUtil toString:object[@"realName"]];
    /**发布时间*/
    cell.pbDateTimeLabel.text = [DateUtil toShortDate:object[@"pbDate"] time:object[@"pbTime"]];
    /**回复数*/
    cell.praiseCountLabel.text = object[@"praiseCount"];
    cell.contentLabel.text = object[@"content"];
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *object = self.dataArray[indexPath.row];
    NSString *content = object[@"content"];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    CGRect frame = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attribute context:nil];
    return frame.size.height + 60.0;
}

@end

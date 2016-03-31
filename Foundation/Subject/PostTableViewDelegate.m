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
- (instancetype)init {
    if (self = [super init]) {
        self.heightArray = [NSMutableArray arrayWithCapacity:self.dataArray.count];
    }
    return self;
}

#pragma mark - tb代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

//单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PostTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PostTableViewCell" owner:nil options:nil] firstObject];
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
    /**正文*/
    cell.contentTextView.attributedText = [[NSAttributedString alloc] initWithString:object[@"content"] attributes:[StringUtil textViewAttribute]];
    [cell.contentTextView sizeToFit];
    self.heightArray[indexPath.row] = [NSNumber numberWithFloat:cell.contentTextView.frame.size.height];
    //汇总高度
    if (indexPath.row == self.dataArray.count - 1) {
        CGFloat sum;
        for (NSNumber *height in self.heightArray) {
            sum += [height floatValue];
        }
        ((SubjectDetailTableViewController *)self.vc).sumPostHeight = sum;
        [((SubjectDetailTableViewController *)self.vc).tableView reloadData];
    }
    
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    PostTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.heightArray.count > 0) {
        return [self.heightArray[indexPath.row] floatValue] + 78.0;
    }
    return 78.0;
}

@end

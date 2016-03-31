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
//- (instancetype)init {
//
//}
- (instancetype)initWithVC:(UIViewController *)vc {
    if (self = [super init]) {
        self.heightArray = [NSMutableArray arrayWithCapacity:self.dataArray.count];
        self.vc = vc;
    }
    return self;
}
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
    /**正文*/
//    cell.contentTextView.text = object[@"content"];
    
    cell.contentLabel.text = object[@"content"];
//    [cell.contentTextView sizeToFit];
//    self.heightArray[indexPath.row] = [NSNumber numberWithFloat:cell.contentTextView.frame.size.height];
    
    //汇总高度
//    if (indexPath.row == self.dataArray.count - 1) {
//        CGFloat sum;
//        for (NSNumber *height in self.heightArray) {
//            sum += [height floatValue];
//        }
//        ((SubjectDetailTableViewController *)self.vc).sumPostHeight = sum;
//        [((SubjectDetailTableViewController *)self.vc).tableView reloadData];
//    }
    
    return cell;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    PostTableViewCell *cell = (PostTableViewCell *)self.prototypeCell;
//    NSLog(@"%@",cell);
//    cell.translatesAutoresizingMaskIntoConstraints = NO;
////    cell.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    NSDictionary *object = self.dataArray[indexPath.row];
//    cell.contentLabel.text = object[@"content"];
//    CGSize size = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
////    CGSize textViewSize = [cell.contentTextView sizeThatFits:CGSizeMake(cell.contentTextView.frame.size.width, FLT_MAX)];
//    return size.height + 1;
////    if (self.heightArray.count > 0) {
////        return [self.heightArray[indexPath.row] floatValue] + 78.0;
////    }
    
    
        NSDictionary *object = self.dataArray[indexPath.row];

    // 該行要顯示的內容
    NSString *content = object[@"content"];
    // 計算出顯示完內容需要的最小尺寸
//    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(SCREEN_WIDTH, 1000.0f) lineBreakMode:UILineBreakModeWordWrap];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:17]};
    CGRect size = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 1000.0f) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attribute context:nil];
    
    return size.size.height + 70.0;
}

//估算高度
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0 && indexPath.row == 1) {
//        //        总高度汇总
//        return self.sumPostHeight;
//    }
//    return SCREEN_HEIGHT - 160.0;
//}

@end

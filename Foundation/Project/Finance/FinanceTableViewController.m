//
//  FinanceTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/19.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "FinanceTableViewController.h"
#import "FinanceTableViewCell.h"

#import "StatusDict.h"

@interface FinanceTableViewController ()

@end

@implementation FinanceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self fetchData];
}

- (void)fetchData {
    NSDictionary *param = @{@"QueryParams":[StringUtil dictToJson:@{
                                                                    @"SEQ_projectId":self.pid
                                                                    }],
                            @"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service POST:@"finance/queryFinanceList" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.dataArray = responseObject;
        [self.tableView reloadData];
    } noResult:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FinanceTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FinanceTableViewCell" owner:nil options:nil] firstObject];
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.dateLabel.text = [DateUtil toYYYYMMCN:dict[@"financeTime"]];
    [cell.timelineDotImageView setHighlighted:![dict[@"financeProc"] boolValue]];
//    timeline线条颜色
    if ([dict[@"financeProc"] boolValue]) {
//        蓝
        cell.timelineView.backgroundColor = HGColor(0,145,240);
    } else {
        cell.timelineView.backgroundColor = HGColor(255,153,0);
    }
    cell.financeProcCodeLabel.text = [StatusDict financeProcByCode:dict[@"financeProcCode"]];
    NSString *moneyType = [dict[@"moneyType"] boolValue] ? @"万美元" : @"万人民币";
    cell.financeAmountLabel.text = [NSString stringWithFormat:@"%@%@",[dict[@"financeAmount"] stringValue],moneyType];
    cell.sellSharesLabel.text = [NSString stringWithFormat:@"%@%%",[dict[@"sellShares"] stringValue]];
    cell.investCompLabel.text = [StringUtil toString:dict[@"investComp"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 116.0;
}

@end

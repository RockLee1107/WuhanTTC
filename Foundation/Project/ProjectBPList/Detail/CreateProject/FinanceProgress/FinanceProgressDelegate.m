//
//  FinanceProgressDelegate.m
//  Foundation
//
//  Created by 李志强 on 16/6/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "FinanceProgressDelegate.h"
#import "FinanceCreateTableViewController.h"
#import "FinanceTableViewCell.h"
#import "StatusDict.h"

@implementation FinanceProgressDelegate

#pragma mark - tb代理方法
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
    cell.financeAmountLabel.text = [NSString stringWithFormat:@"%@%@",dict[@"financeAmount"],moneyType];
    cell.sellSharesLabel.text = [NSString stringWithFormat:@"%@%%",dict[@"sellShares"]];
    cell.investCompLabel.text = [StringUtil toString:dict[@"investComp"]];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//添加头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
    
    UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 60, 20, 20)];
    iconImage.image = [UIImage imageNamed:@"menu_create@2x"];
    [headView addSubview:iconImage];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(SCREEN_WIDTH-50, 54, 45, 30);
    [addBtn setTitle:@"添加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:addBtn];
    
    return headView;
}

//点击添加
- (void)addBtnClick {
    FinanceCreateTableViewController *vc = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"finance"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = @"添加融资信息";
    vc.isFromAdd = YES;
    [self.vc.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = self.dataArray[indexPath.row];
    
    FinanceCreateTableViewController *vc = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"finance"];
    vc.hidesBottomBarWhenPushed = YES;
    vc.isFromAdd = YES;
    vc.idStr = dict[@"id"];
    vc.title = @"编辑融资信息";
    vc.dataDic = dict;
    
    [self.vc.navigationController pushViewController:vc animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 84;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}


@end

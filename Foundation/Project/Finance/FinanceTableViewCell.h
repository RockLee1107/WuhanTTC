//
//  FinanceTableViewCell.h
//  Foundation
//
//  Created by Dotton on 16/4/19.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinanceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *timelineDotImageView;
@property (weak, nonatomic) IBOutlet UIView *timelineView;
@property (weak, nonatomic) IBOutlet UILabel *financeProcCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *financeAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellSharesLabel;
@property (weak, nonatomic) IBOutlet UILabel *investCompLabel;
@end

//
//  SpecialTypeTableViewCell.h
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialTypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *specialNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestBookNameLabel;
#warning 日期转化
@property (weak, nonatomic) IBOutlet UILabel *latestUpdateTimeLabel;

@end

//
//  SpecialTypeTableViewCell.h
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialTypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *specialNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestBookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *latestUpdateTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *unreadImageView;

@end

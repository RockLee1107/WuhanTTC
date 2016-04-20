//
//  EvaluateTableViewCell.h
//  Foundation
//
//  Created by Dotton on 16/4/20.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EvaluateTableViewCell : UITableViewCell
//头像
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
//真名
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
//公司
@property (weak, nonatomic) IBOutlet UILabel *userDescLabel;
//日期
@property (weak, nonatomic) IBOutlet UILabel *pbtimeLabel;
//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

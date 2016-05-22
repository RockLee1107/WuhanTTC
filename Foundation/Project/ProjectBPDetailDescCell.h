//
//  ProjectBPDetailDescCell.h
//  Foundation
//
//  Created by hyfy002 on 16/5/22.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectBPDetailDescCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

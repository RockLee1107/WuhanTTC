//
//  ProjectBPCell.h
//  Foundation
//
//  Created by hyfy002 on 16/5/22.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectBPCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *viewCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *supportCountLabel;

@property (weak, nonatomic) IBOutlet UILabel *collectLabel;

@property (nonatomic, copy) NSString *bpId;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UILabel *separatorLine;

@property (strong, nonatomic) IBOutlet UIImageView *lockImageView;//锁

@end

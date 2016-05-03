//
//  ApplyUserTableViewCell.h
//  Foundation
//
//  Created by Dotton on 16/5/3.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyUserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *telePhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dutyLabel;
@end

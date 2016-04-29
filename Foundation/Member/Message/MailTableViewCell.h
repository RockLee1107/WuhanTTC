//
//  MailTableViewCell.h
//  Foundation
//
//  Created by Dotton on 16/4/29.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingOfCreatedDateTimeLabel;
@property (nonatomic,strong) IBOutlet UILabel *createdDatetimeLabel;
@property (nonatomic,strong) IBOutlet UILabel *contentLabel;
@property (nonatomic,strong) IBOutlet UIImageView *avatarImageView;
@property (nonatomic,strong) IBOutlet UIButton *realNameButton;
@property (nonatomic,strong) IBOutlet UILabel *statusLabel;

@end

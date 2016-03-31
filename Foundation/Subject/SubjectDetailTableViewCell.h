//
//  SubjectDetailTableViewCell.h
//  Foundation
//
//  Created by Dotton on 16/3/31.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubjectDetailTableViewCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *realnameLabel;
@property (nonatomic,strong) IBOutlet UILabel *pbDateTimeLabel;
@property (nonatomic,strong) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@end

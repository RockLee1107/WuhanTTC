//
//  SubjectTableViewCell.h
//  Foundation
//
//  Created by Dotton on 16/3/28.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubjectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictUrlImageView;
@property (weak, nonatomic) IBOutlet UILabel *myTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pbDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyCountLabel;
@end

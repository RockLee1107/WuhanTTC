//
//  PostTableViewCell.h
//  Foundation
//
//  Created by Dotton on 16/3/31.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTableViewCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel *realnameLabel;
@property (nonatomic,strong) IBOutlet UILabel *pbDateTimeLabel;
@property (nonatomic,strong) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (nonatomic,strong) IBOutlet UILabel *praiseCountLabel;
//点赞按钮
@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
@end

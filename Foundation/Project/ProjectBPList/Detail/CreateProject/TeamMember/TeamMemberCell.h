//
//  TeamMemberCell.h
//  Foundation
//
//  Created by 李志强 on 16/6/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamMemberCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picUrl;
@property (weak, nonatomic) IBOutlet UILabel *realName;
@property (weak, nonatomic) IBOutlet UILabel *duty;
@property (weak, nonatomic) IBOutlet UILabel *introduction;

@end

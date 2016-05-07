//
//  TableViewCell.h
//  Foundation
//
//  Created by Dotton on 16/3/18.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell
/**图片*/
@property (nonatomic,weak) IBOutlet UIImageView *pictUrlImageView;
/**标题*/
@property (nonatomic,weak) IBOutlet UILabel *activityTitleLabel;
/**状态*/
@property (nonatomic,weak) IBOutlet UILabel *statusLabel;
/**开始时间*/
@property (nonatomic,weak) IBOutlet UILabel *planDateLabel;
/**城市*/
@property (nonatomic,weak) IBOutlet UILabel *cityLabel;
/**活动类型*/
@property (nonatomic,weak) IBOutlet UILabel *typeLabel;
@end

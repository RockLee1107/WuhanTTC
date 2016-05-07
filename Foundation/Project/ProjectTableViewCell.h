//
//  ProjectTableViewCell.h
//  Foundation
//
//  Created by Dotton on 16/3/21.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXButton.h"

@interface ProjectTableViewCell : UITableViewCell
/**图片*/
@property (nonatomic,weak) IBOutlet UIImageView *pictUrlImageView;
/**标题*/
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
/**简历*/
@property (nonatomic,weak) IBOutlet UILabel *resumeLabel;
/**城市*/
@property (nonatomic,weak) IBOutlet UILabel *cityLabel;
/*阶段*/
@property (nonatomic,weak) IBOutlet LXButton *financeProcNameLabel;
@end

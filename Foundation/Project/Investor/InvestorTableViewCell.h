//
//  InvestorTableViewCell.h
//  Foundation
//
//  Created by Dotton on 16/4/2.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestorTableViewCell : UITableViewCell
/**图片*/
@property (nonatomic,weak) IBOutlet UIImageView *pictUrlImageView;
/**姓名*/
@property (nonatomic,weak) IBOutlet UILabel *realNameLabel;
/**公司*/
@property (nonatomic,weak) IBOutlet UILabel *companyLabel;
/**职责*/
@property (strong, nonatomic) IBOutlet UILabel *dutyLabel;
/**城市*/
@property (nonatomic,weak) IBOutlet UILabel *areaLabel;
/**投资阶段*/
@property (nonatomic,weak) IBOutlet UILabel *investProcessLabel;
/**投资领域*/
@property (nonatomic,weak) IBOutlet UILabel *investAreaLabel;

@end

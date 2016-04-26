//
//  NoteTableViewCell.h
//  Foundation
//
//  Created by Dotton on 16/4/25.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *createdDatetimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookExcerptLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@end

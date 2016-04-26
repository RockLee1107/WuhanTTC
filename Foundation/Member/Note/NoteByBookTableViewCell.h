//
//  NoteByBookTableViewCell.h
//  Foundation
//
//  Created by Dotton on 16/4/26.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteByBookTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noteDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@end

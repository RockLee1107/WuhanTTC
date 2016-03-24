//
//  BookTableViewCell.h
//  
//
//  Created by HuangXiuJie on 16/3/9.
//
//

#import <UIKit/UIKit.h>

@interface BookTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bookTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookLabelLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishDate;
@end

//
//  PostTableViewDelegate.h
//  Foundation
//
//  Created by Dotton on 16/3/31.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseTableViewDelegate.h"

@interface PostTableViewDelegate : BaseTableViewDelegate
@property (nonatomic,strong) NSMutableArray *heightArray;
- (instancetype)initWithVC:(UIViewController *)vc;
@property (nonatomic, strong) UITableViewCell *prototypeCell;

@end

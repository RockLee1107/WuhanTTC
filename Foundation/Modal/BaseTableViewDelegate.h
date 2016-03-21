//
//  BaseTableViewDelegate.h
//  Foundation
//
//  Created by Dotton on 16/3/21.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateUtil.h"
#import "StringUtil.h"
#import "UIImageView+AFNetworking.h"

@interface BaseTableViewDelegate : NSObject<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) UIViewController *vc;
@end

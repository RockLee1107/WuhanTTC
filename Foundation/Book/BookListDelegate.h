//
//  BookListDelegate.h
//  Foundation
//
//  Created by Dotton on 16/3/25.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseTableViewDelegate.h"

@interface BookListDelegate : BaseTableViewDelegate
@property (nonatomic,assign) BOOL shouldEditing;
@property (nonatomic,strong) NSNumber *num;
@end

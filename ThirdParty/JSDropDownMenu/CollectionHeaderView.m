//
//  CollectionHeaderView.m
//  Xiupin_Demo
//
//  Created by qianfeng on 15/10/26.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#import "CollectionHeaderView.h"

@implementation CollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, frame.size.width-15, frame.size.height)];
        titleLabel.backgroundColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
    }
    return self;
}


@end

//
//  NoteOrCollectTableHeaderView.m
//  Foundation
//
//  Created by Dotton on 16/4/27.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "NoteOrCollectTableHeaderView.h"
#import "Masonry.h"

@implementation NoteOrCollectTableHeaderView
- (instancetype)initWithFrame:(CGRect)frame icon:(NSString *)icon num:(NSNumber *)num {
    if (self = [super initWithFrame:frame]) {
        
        //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60.0)];
        //    小图标
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",icon]]];
        [self addSubview:imageView];//需先加入view中，不然报找不到super view的错误
        //    总计
        UILabel *totalLabel = [[UILabel alloc] init];
        totalLabel.text = @"总计";
        totalLabel.textColor = [UIColor darkGrayColor];
        totalLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:totalLabel];
        //    数值
        UILabel *numLabel = [[UILabel alloc] init];
        numLabel.text = [num stringValue];
        numLabel.textColor = [UIColor redColor];
        numLabel.font = [UIFont systemFontOfSize:20.0];
        [self addSubview:numLabel];
        //    条
        UILabel *unitLabel = [[UILabel alloc] init];
        unitLabel.text = @"条";
        unitLabel.textColor = [UIColor darkGrayColor];
        unitLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:unitLabel];
        //    app_comment@2x
        //    图标布局
        [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_leading.layoutAttribute + 10);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(21.0);
            make.height.mas_equalTo(21.0);
        }];
        //    总计布局
        [totalLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).with.offset(10);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(30.0);
        }];
        //    数值布局
        [numLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(totalLabel.mas_right).with.offset(10);
            //        make.width.mas_equalTo(40.0);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        //    条布局
        [unitLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(numLabel.mas_right).with.offset(10);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(20.0);
        }];
    }
    return self;
}
@end

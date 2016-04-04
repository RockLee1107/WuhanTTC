//
//  LXPasswordView.m
//  
//
//  Created by HuangXiuJie on 16/3/30.
//
//

#import "LXPasswordView.h"
#import "Masonry.h"

@implementation LXPasswordView

- (void)drawRect:(CGRect)rect {
//    密码框初始化
    self.textField = [[UITextField alloc] init];
    self.textField.secureTextEntry = YES;
    self.textField.font = [UIFont systemFontOfSize:14.0];
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.placeholder = @"请输入密码";
    self.textField.text = @"123456";
//    按钮初始化
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.button setImage:[[UIImage imageNamed:@"app_pwd_unvisible.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

//    [self.showButton set:[UIImage imageNamed:@"app_pwd_unvisible.png"] forState:(UIControlStateNormal)];
    [self addSubview:self.textField];
    [self addSubview:self.button];
//    按钮布局
    [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(37.0 / 2.0);
//        make.height.mas_equalTo(20.0 / 2.0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing);
    }];
//    密码框布局
    [self.textField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.button.mas_leading);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(30.0);
    }];
    //按钮点击事件
    [self.button addTarget:self action:@selector(showOrHide) forControlEvents:(UIControlEventTouchUpInside)];
    //关闭键盘
    self.textField.delegate = self;
}

///显示开头
- (void)showOrHide {
    if (self.isShow) {
        [self.button setImage:[[UIImage imageNamed:@"app_pwd_unvisible.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    } else {
        [self.button setImage:[[UIImage imageNamed:@"app_pwd_visible.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    self.textField.secureTextEntry = self.isShow;
    self.isShow = !self.isShow;
}

//关闭键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end

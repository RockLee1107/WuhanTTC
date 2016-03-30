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
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.font = [UIFont systemFontOfSize:14.0];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    按钮初始化
    self.showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.showButton setImage:[[UIImage imageNamed:@"app_pwd_unvisible.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];

//    [self.showButton set:[UIImage imageNamed:@"app_pwd_unvisible.png"] forState:(UIControlStateNormal)];
    [self addSubview:self.passwordTextField];
    [self addSubview:self.showButton];
//    按钮布局
    [self.showButton mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(37.0 / 2.0);
//        make.height.mas_equalTo(20.0 / 2.0);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing);
    }];
//    密码框布局
    [self.passwordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.showButton.mas_leading);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(30.0);
    }];
    //按钮点击事件
    [self.showButton addTarget:self action:@selector(showOrHide) forControlEvents:(UIControlEventTouchUpInside)];
    
}

///显示开头
- (void)showOrHide {
    if (self.isShow) {
        [self.showButton setImage:[[UIImage imageNamed:@"app_pwd_unvisible.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    } else {
        [self.showButton setImage:[[UIImage imageNamed:@"app_pwd_visible.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    }
    self.passwordTextField.secureTextEntry = self.isShow;
    self.isShow = !self.isShow;
}

@end

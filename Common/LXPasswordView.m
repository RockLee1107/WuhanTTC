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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.font = [UIFont systemFontOfSize:14.0];
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.showButton setBackgroundImage:[UIImage imageNamed:@"app_pwd_unvisible.png"] forState:(UIControlStateNormal)];
    [self addSubview:self.passwordTextField];
    [self addSubview:self.showButton];
    [self.showButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing);
    }];
    [self.passwordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading);
        make.trailing.mas_equalTo(self.showButton.mas_leading);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(30.0);
    }];
}

@end

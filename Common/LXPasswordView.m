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
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.passwordTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.passwordTextField.mas_width);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    self.showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.showButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.trailing.mas_equalTo(self.mas_trailing);
    }];
    [self.showButton setBackgroundImage:[UIImage imageNamed:@"app_pwd_unvisible.png"] forState:(UIControlStateNormal)];
}

@end

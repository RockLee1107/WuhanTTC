//
//  LoginTableViewController.m
//  
//
//  Created by HuangXiuJie on 16/3/30.
//
//

#import "LoginTableViewController.h"
#import "LXPasswordView.h"
#import "MainTabBarController.h"
#import "LXButton.h"

@interface LoginTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet LXPasswordView *passwordView;
@property (weak, nonatomic) IBOutlet LXButton *visitorButton;
@end

@implementation LoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.scrollEnabled = NO;
    self.usernameTextField.delegate = self;
    self.passwordView.textField.delegate = self;
    self.visitorButton.backgroundColor = [UIColor grayColor];
//    自动登录，调试阶段打开
//    [self performSelector:@selector(loginButtonPress:) withObject:nil afterDelay:.1f];
}


@end

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

- (IBAction)loginButtonPress:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordView.textField.text;
    NSDictionary *param = @{@"username":username,
                            @"password":password};
    [self.service POST:@"login" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"login:%@",responseObject);
        User *user = [User getInstance];
        user.username = responseObject[@"username"];
        user.uid = responseObject[@"userId"];
        if (responseObject[@"userinfo"] != [NSNull null]) {
            user.hasInfo = [NSNumber numberWithBool:YES];
        } else {
            user.hasInfo = [NSNumber numberWithBool:NO];
        }
        [self jumpMain];
    } noResult:^{
        
    }];
}

- (void)jumpMain {
    MainTabBarController *vc = [[MainTabBarController alloc] init];
    [[[UIApplication sharedApplication].windows firstObject] setRootViewController:vc];
}
@end

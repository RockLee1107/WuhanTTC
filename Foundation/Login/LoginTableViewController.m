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

@interface LoginTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet LXPasswordView *passwordView;
@end

@implementation LoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        [self jumpMain];
    } noResult:^{
        
    }];
}

- (void)jumpMain {
    MainTabBarController *vc = [[MainTabBarController alloc] init];
    [[[UIApplication sharedApplication].windows firstObject] setRootViewController:vc];
}
@end

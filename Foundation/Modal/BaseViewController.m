//
//  BaseViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/3.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "BaseViewController.h"
#import "MainTabBarController.h"
#import "LoginViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.service = [HttpService getInstance];
    //后退按钮标题与按钮图片
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    UIImage *backBarItemImage = [[UIImage imageNamed:@"arrow_left"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [backItem setBackButtonBackgroundImage:backBarItemImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    self.navigationItem.backBarButtonItem = backItem;
    //tap
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
}

- (void)viewWillAppear:(BOOL)animated {
//    self.tabBarController.tabBar.hidden = YES;
}

- (void)dismissKeyboard {
    [self.currentTextField resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.currentTextField resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.currentTextField = textField;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.currentTextField resignFirstResponder];
    return YES;
}

- (void)jumpMain {
    MainTabBarController *vc = [[MainTabBarController alloc] init];
    [[[UIApplication sharedApplication].windows firstObject] setRootViewController:vc];
}

- (void)jumpLogin {
    LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
    [self.navigationController presentViewController:vc animated:YES completion:nil];
//    [[[UIApplication sharedApplication].windows firstObject] setRootViewController:vc];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

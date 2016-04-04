//
//  LoginViewController.m
//  
//
//  Created by HuangXiuJie on 16/3/4.
//
//

#import "LoginViewController.h"
#import "LocationUtil.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[LocationUtil getInstance] fetchLocation];
    self.containerView.layer.cornerRadius = 6.0;
    self.containerView.clipsToBounds = YES;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
//}

@end

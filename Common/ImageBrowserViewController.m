//
//  ImageBrowserViewController.m
//  Beauty
//
//  Created by HuangXiuJie on 15/3/17.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ImageBrowserViewController.h"
#import "KL_ImageZoomView.h"
#import "KL_ImagesZoomController.h"
#import "UIImageView+WebCache.h"
#import "Global.h"
#import "AppDelegate.h"
#import "HttpService.h"
#import "SVProgressHUD.h"

@interface ImageBrowserViewController ()<UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSDictionary *userInfo;

@end

@implementation ImageBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userInfo = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
//    self.navigationItem.title = self.navigationItemTitle;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    设置Done按钮
    KL_ImagesZoomController *img = [[KL_ImagesZoomController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )imgViewSize:CGSizeZero];
    [self.view addSubview:img];


//    添加单击事件
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(handleSingleFingerEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    singleFingerOne.delegate = self;
    [img addGestureRecognizer:singleFingerOne];
//    加载图片
    [img updateImageDate:[self imageArray] selectIndex:self.selectedIndex];
    

}


- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)tap {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setBarTintColor:MAIN_COLOR];
}

@end

//
//  AboutViewController.m
//  Foundation
//
//  Created by 黄侃 on 16/5/6.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *standardLabel;

@end

@implementation AboutViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _naviTitle;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
   
//    self.logoImageView =[UIImage imageNamed:@"1.jpg"];
    
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"%@%@",self.versionLabel.text,app_Version];
    [self fetchData];
}

- (void)fetchData {
    NSDictionary *param = @{
                            @"type":self.type
                            };
    [self.service POST:@"standard/getStandard" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.contentLabel setAttributedText:[[NSAttributedString alloc] initWithString:responseObject[@"content"] attributes:[StringUtil textViewAttribute]]];
    } noResult:nil];
}

@end

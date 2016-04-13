//
//  StandardViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/13.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "StandardViewController.h"

@interface StandardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation StandardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _naviTitle;
    [self fetchData];
}

- (void)fetchData {
    NSDictionary *param = @{
                            @"type":self.type
                            };
    [self.service POST:@"standard/getStandard" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.titleLabel.text = responseObject[@"title"];
        [self.contentTextView setAttributedText:[[NSAttributedString alloc] initWithString:responseObject[@"content"] attributes:[StringUtil textViewAttribute]]];
    } noResult:nil];
}

@end

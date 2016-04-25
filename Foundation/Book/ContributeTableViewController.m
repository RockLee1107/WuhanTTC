//
//  ContributeTableViewController.m
//  Foundation
//
//  Created by HuangXiuJie on 16/4/25.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ContributeTableViewController.h"
#import "EMTextView.h"
#import "LXButton.h"
#import "VerifyUtil.h"

@interface ContributeTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField; //名称
@property (weak, nonatomic) IBOutlet EMTextView *contentTextView;  //活动详情
@end

@implementation ContributeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    隐藏键盘
    self.titleTextField.delegate = self;
    // Do any additional setup after loading the view.
}

///提交到网络
- (IBAction)postButtonPress:(id)sender {
    if (![VerifyUtil hasValue:self.titleTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入正确的文章链接"];
        return;
    }
    if (![VerifyUtil isValidStringLengthRange:self.contentTextView.text between:3 and:200]) {
        [SVProgressHUD showErrorWithStatus:@"请输入帖子内容(1-1000字)"];
        return;
    }
    NSDictionary *param = @{
                            @"Contribute":[StringUtil dictToJson:@{
                                                                    @"url":self.titleTextField.text,
                                                                    @"content":self.contentTextView.text,
                                                                    @"type":@"0"
                                                                    }]
                            };
    [self.service POST:@"book/contribute" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"推荐成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } noResult:nil];
}

@end

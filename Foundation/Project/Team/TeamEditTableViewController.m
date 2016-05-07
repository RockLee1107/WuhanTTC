//
//  TeamEditTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/5/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "TeamEditTableViewController.h"

@interface TeamEditTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UITextField *dutyTextField;

@end

@implementation TeamEditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dutyTextField.text = self.dataDict[@"duty"];
    self.realnameLabel.text = self.dataDict[@"realName"];
}

//delete
- (IBAction)deleteButtonPress:(id)sender {
    [[PXAlertView showAlertWithTitle:@"确定要删除吗？" message:nil cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if (!cancelled) {
            [self.service POST:@"team/delete" parameters:@{@"id":self.dataDict[@"parterId"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [SVProgressHUD showSuccessWithStatus:@"删除成功"];
                [self.parentVC.dataArray removeObject:self.dataDict];
                [self.navigationController popViewControllerAnimated:YES];
            } noResult:nil];
        }
    }] useDefaultIOS7Style];
}

//modity
- (IBAction)submitButtonPress:(id)sender {
//    form verify
    if (![VerifyUtil hasValue:self.dutyTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写职务"];
        return ;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataDict];
    [dict setObject:self.dutyTextField.text forKey:@"duty"];
//    找回原来的index
    NSInteger index = [self.parentVC.dataArray indexOfObject:self.dataDict];
    [self.parentVC.dataArray setObject:dict atIndexedSubscript:index];
    [self.navigationController popViewControllerAnimated:YES];
}

@end

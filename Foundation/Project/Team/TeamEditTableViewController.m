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
            //有id则是数据库里即有的，否则是刚刚添加进的
            if (self.dataDict[@"id"] == nil) {
                [self deleteAndPop];
            } else {
                [self.service POST:@"team/delete" parameters:@{@"id":self.dataDict[@"id"]} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self deleteAndPop];
                } noResult:nil];
            }
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
//    定义一个dict，初始与写入
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataDict];
    [dict setObject:self.dutyTextField.text forKey:@"duty"];
//    找回原来的index
    NSInteger index = [self.parentVC.dataArray indexOfObject:self.dataDict];
    [self.parentVC.dataArray setObject:dict atIndexedSubscript:index];
    [self.navigationController popViewControllerAnimated:YES];
}

//删除内存数据以及返回前一页
- (void)deleteAndPop {
    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
    [self.parentVC.dataArray removeObject:self.dataDict];
    [self.navigationController popViewControllerAnimated:YES];
}
@end

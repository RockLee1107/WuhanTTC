//
//  ActivityCreateTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/13.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "PostSubjectTableViewController.h"
#import "EMTextView.h"
#import "LXButton.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetStringPicker.h"
#import "StatusDict.h"
#import "VerifyUtil.h"

@interface PostSubjectTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField; //名称
//活动类型
@property (weak, nonatomic) IBOutlet UIButton *typeButton;         //按钮，用于显示所选中文值
@property (assign, nonatomic) NSInteger selectedTypeIndex;           //状态index，用于选择框反显
@property (strong, nonatomic) NSString *selectedTypeValue;           //状态value，用于数据提交
@property (weak, nonatomic) IBOutlet EMTextView *contentTextView;  //活动详情
@end

@implementation PostSubjectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    隐藏键盘
    self.titleTextField.delegate = self;
}

//选择活动类型
- (IBAction)selectType:(id)sender {
    //    数据预处理
    NSArray *array = [StatusDict specialType];
    NSMutableArray *names = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [names addObject:dict[@"specialName"]];
    }
    //弹出选择框
    [ActionSheetStringPicker showPickerWithTitle:@"选择专栏名称" rows:names initialSelection:self.selectedTypeIndex doneBlock: ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        //            按钮赋值当前区名称
        self.selectedTypeIndex = selectedIndex;
        //            当前选值以提交
        self.selectedTypeValue = array[selectedIndex][@"specialCode"];
        [self.typeButton setTitle:selectedValue forState:(UIControlStateNormal)];
    } cancelBlock:nil origin:sender];
}

///提交到网络
- (IBAction)postButtonPress:(id)sender {
    if (self.selectedTypeValue == nil) {
        [SVProgressHUD showErrorWithStatus:@"请选择专栏名称"];
        return;
    }
    if (![VerifyUtil isValidStringLengthRange:self.titleTextField.text between:2 and:26]) {
        [SVProgressHUD showErrorWithStatus:@"请输入帖子内容(2-26字)"];
        return;
    }
    if (![VerifyUtil isValidStringLengthRange:self.contentTextView.text between:1 and:1000]) {
        [SVProgressHUD showErrorWithStatus:@"请输入帖子内容(1-1000字)"];
        return;
    }
    NSDictionary *param = @{
                            @"PostSubject":[StringUtil dictToJson:@{
                                                                    @"title":self.titleTextField.text,
                                                                    @"content":self.contentTextView.text,
                                                                    @"specialCode":self.selectedTypeValue
                                                                    }]
                            };
    [self.service POST:@"book/postSubject/submitPost" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } noResult:nil];
}

@end

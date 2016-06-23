//
//  ProcessCreateViewController.m
//  Foundation
//
//  Created by Dotton on 16/5/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ProcessCreateTableViewController.h"
#import "EMTextView.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetDatePicker.h"
#import "StatusDict.h"
#import "DateUtil.h"

@interface ProcessCreateTableViewController ()
//日期选择器
@property (weak, nonatomic) IBOutlet UIButton *processDateButton;
@property (nonatomic, strong) NSDate *processDate;
//投资人/投资机构
@property (weak, nonatomic) IBOutlet EMTextView *descTextView;

@property (nonatomic, strong) NSDate *planDate;
@end

@implementation ProcessCreateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    初始化日期
    self.processDate = [NSDate date];
    [self.processDateButton setTitle:[DateUtil dateToString:self.processDate] forState:(UIControlStateNormal)];
    
    if ([self.title isEqualToString:@"添加进度信息"]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
//    else {
//        self.processDate =  [DateUtil toDate:self.dateText format:@"YYYYMMdd"];
//        self.descTextView.text = self.descText;
//    }
    
    
    if (self.dataDict != nil) {
        //编辑页面将有传值
        self.navigationItem.title = @"编辑项目进展";
        [self.processDateButton setTitle:[DateUtil toString:self.dataDict[@"processDate"]] forState:(UIControlStateNormal)];
        self.processDate = [DateUtil toDate:self.dataDict[@"processDate"] format:@"YYYYMMdd"];
        self.descTextView.text = self.dataDict[@"desc"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"app_delete"] style:(UIBarButtonItemStyleBordered) target:self action:@selector(deleteButtonPress:)];
    }
}

///选择开始日期
- (IBAction)selectProcessDate:(id)sender {
    AbstractActionSheetPicker *actionSheetPicker;
    actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"选择进度时间" datePickerMode:UIDatePickerModeDate selectedDate:self.processDate minimumDate:nil maximumDate:nil target:self action:@selector(dateWasSelected:element:) origin:sender];
    [actionSheetPicker showActionSheetPicker];
}

///开始日期回调
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.processDate = selectedDate;
    [self.processDateButton setTitle:[DateUtil dateToString:self.processDate] forState:(UIControlStateNormal)];
}

//点击删除
- (IBAction)deleteBtnClick:(id)sender {
    [[PXAlertView showAlertWithTitle:@"确定要删除吗？" message:nil cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if (!cancelled) {
            //有id则是数据库里即有的，否则是刚刚添加进的
            if (self.idStr == nil) {
                [self deleteAndPop];
            }else {
                [self.service POST:@"process/deleteProcess" parameters:@{@"id":self.idStr} success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [self deleteAndPop];
                } noResult:nil];
            }
        }
    }] useDefaultIOS7Style];
}

//提交数据
- (IBAction)submit:(id)sender {
    if (self.isFromAdd) {
        
        NSString *projectId;
        if ([User getInstance].srcId != nil && ![[User getInstance].srcId isEqualToString:@""] && ![[User getInstance].srcId isKindOfClass:[NSNull class]]) {
            projectId = [User getInstance].srcId;
        }
        else if ([User getInstance].createProjectId != nil && ![[User getInstance].createProjectId isEqualToString:@""]) {
            projectId = [User getInstance].createProjectId;
        }
        
        
        //修改进度信息
        if (self.idStr) {
            //    考虑结束日期要大于开始日期
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                         @{
                                           @"processDate":[[DateUtil dateToDatePart:self.processDate] substringToIndex:6],
                                           @"processDesc":self.descTextView.text,
                                           @"projectId":projectId,
                                           @"id":self.idStr
                                           }
                                         ];
            
            NSString *jsonStr = [StringUtil dictToJson:dict];
            NSDictionary *param = @{@"Process":jsonStr};
            
            [self.service POST:@"process/saveProcess" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [User getInstance].projectId = responseObject[@"data"];
                [self.navigationController popViewControllerAnimated:YES];
                
            } noResult:^{
                NSLog(@"22222222222");
            }];
        }
        //添加进度信息
        else {
            //    考虑结束日期要大于开始日期
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                         @{
                                           @"processDate":[[DateUtil dateToDatePart:self.processDate] substringToIndex:6],
                                           @"processDesc":self.descTextView.text,
                                           @"projectId":projectId
                                           }
                                         ];
            
            NSString *jsonStr = [StringUtil dictToJson:dict];
            NSDictionary *param = @{@"Process":jsonStr};
            
            [self.service POST:@"process/saveProcess" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } noResult:^{
                NSLog(@"22222222222");
            }];
        }
    
    }else {
        if (![VerifyUtil isValidStringLengthRange:self.descTextView.text between:1 and:50]) {
            [SVProgressHUD showErrorWithStatus:@"请输入填写重要事件或重大进展(50字以内)"];
            return;
        }
        
        if (self.dataDict != nil) {
            //编辑页面将有传值
            //    定义一个dict，初始与写入
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:self.dataDict];
            [dict setObject:self.descTextView.text forKey:@"desc"];
            [dict setObject:[DateUtil dateToDatePart:self.processDate] forKey:@"processDate"];
            //    找回原来的index
            NSInteger index = [self.parentVC.dataArray indexOfObject:self.dataDict];
            [self.parentVC.dataArray setObject:dict atIndexedSubscript:index];
            [self.navigationController popViewControllerAnimated:YES];
            return ;
        }
        
        NSDictionary *financeDict = @{
                                      @"desc":self.descTextView.text,
                                      @"processDate":[DateUtil dateToDatePart:self.processDate],
                                      @"projectId":self.pid
                                      };
        [self.parentVC.dataArray addObject:financeDict];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//删除内存数据以及返回前一页
- (void)deleteAndPop {
    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
    [self.parentVC.dataArray removeObject:self.dataDict];
    [self.navigationController popViewControllerAnimated:YES];
}
@end

//
//  TeamEditTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/5/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "TeamEditTableViewController.h"
#import "EMTextView.h"
#import "DateUtil.h"
#import "TeamMemberTableViewController.h"


@interface TeamEditTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UITextField *dutyTextField;
@property (weak, nonatomic) IBOutlet EMTextView *memberDesc;

@property (nonatomic, strong) NSDate *planDate;

@end

@implementation TeamEditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if ([self.title isEqualToString:@"添加团队成员"]) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (self.isFromAdd) {
        self.dutyTextField.text = self.addDuty;
        self.realnameLabel.text = self.addName;
        self.memberDesc.text = self.intro;
    }else {
        self.dutyTextField.text = self.dataDict[@"duty"];
        self.realnameLabel.text = self.dataDict[@"realName"];
    }
}

//delete
- (IBAction)deleteButtonPress:(id)sender {
    [[PXAlertView showAlertWithTitle:@"确定要删除吗？" message:nil cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if (!cancelled) {
            //有id则是数据库里即有的，否则是刚刚添加进的
            if (self.idStr == nil) {
                [self deleteAndPop];
            } else {
                
                NSDictionary *dict = @{@"id":self.idStr};
                
                [self.service POST:@"team/deleteTeam" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                    [self deleteAndPop];
                } noResult:nil];
                
            }
        }
    }] useDefaultIOS7Style];
}

//modity
- (IBAction)submitButtonPress:(id)sender {

    //从项目信息 团队成员入口 进入
    if (self.isFromAdd) {
        //修改成员
        if (self.idStr) {
            NSLog(@"=======修改成员信息\n%@", self.idStr);
            //获取系统时间
            self.planDate = [NSDate date];
            
            //    考虑结束日期要大于开始日期
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                         @{
                                           @"duty":self.dutyTextField.text,
                                           @"introduction":self.memberDesc.text,
                                           @"createdDate":[DateUtil dateToDatePart:self.planDate],//日期需要转化20151123格式  记录创建时间当前年月日
                                           @"createdTime":[DateUtil dateToSecondPart:self.planDate],//Time convert to 2315 Style  当前时分秒
                                           @"projectId":self.projectId,
                                           @"parterId":self.friendId,
                                           @"id":self.idStr
                                           }
                                         ];
            
            NSString *jsonStr = [StringUtil dictToJson:dict];
            NSDictionary *param = @{@"Team":jsonStr};
            
            [self.service POST:@"team/saveTeam" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                //返回副本id覆盖掉原id
                [User getInstance].projectId = responseObject[@"data"];
                [self.navigationController popViewControllerAnimated:YES];
                
            } noResult:^{
                NSLog(@"22222222222");
            }];
            
        }//添加成员
        else {
            //获取系统时间
            self.planDate = [NSDate date];
            
            NSString *projectId;
            if ([User getInstance].srcId != nil && ![[User getInstance].srcId isEqualToString:@""] && ![[User getInstance].srcId isKindOfClass:[NSNull class]]) {
                projectId = [User getInstance].srcId;
            }
            else if ([User getInstance].createProjectId != nil && ![[User getInstance].createProjectId isEqualToString:@""]) {
                projectId = [User getInstance].createProjectId;
            }
            
            //    考虑结束日期要大于开始日期
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                         @{
                                           @"duty":self.dutyTextField.text,
                                           @"introduction":self.memberDesc.text,
                                           @"createdDate":[DateUtil dateToDatePart:self.planDate],//日期需要转化20151123格式  记录创建时间当前年月日
                                           @"createdTime":[DateUtil dateToSecondPart:self.planDate],//Time convert to 2315 Style  当前时分秒
                                           @"projectId":projectId,
                                           @"parterId":self.friendId
                                           }
                                         ];
            
            NSString *jsonStr = [StringUtil dictToJson:dict];
            NSDictionary *param = @{@"Team":jsonStr};
            
            [self.service POST:@"team/saveTeam" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                
                [self.navigationController popViewControllerAnimated:YES];
                
            } noResult:^{
                NSLog(@"22222222222");
            }];
        }
        
    }else {
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
}

//删除内存数据以及返回前一页
- (void)deleteAndPop {
    [SVProgressHUD showSuccessWithStatus:@"删除成功"];
    [self.parentVC.dataArray removeObject:self.dataDict];
    [self.navigationController popViewControllerAnimated:YES];
}
@end

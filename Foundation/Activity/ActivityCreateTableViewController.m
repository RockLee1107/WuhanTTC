//
//  ActivityCreateTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/13.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ActivityCreateTableViewController.h"
#import "EMTextView.h"
#import "CityViewController.h"
#import "LXButton.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetStringPicker.h"
#import "StatusDict.h"
#import "VerifyUtil.h"
#import "LXPhotoPicker.h"
#import "LocationUtil.h"
#import "StandardViewController.h"
#import "AJPhotoPickerView.h"
//保存或发布
typedef enum : NSUInteger {
    BizStatusSave,
    BizStatusPublish
} BizStatus;
@interface ActivityCreateTableViewController ()<CityViewControllerDelegete,LXPhotoPickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *activityTitleTextField; //名称
@property (weak, nonatomic) IBOutlet UIButton *headPictUrlButton;       //头像
@property (weak, nonatomic) IBOutlet EMTextView *projectResumeTextView; //简介
@property (weak, nonatomic) IBOutlet LXButton *currentCityButton;       //城市
//活动类型
@property (weak, nonatomic) IBOutlet UIButton *typeButton;         //按钮，用于显示所选中文值
@property (assign, nonatomic) NSInteger selectedTypeIndex;           //状态index，用于选择框反显
@property (strong, nonatomic) NSString *selectedTypeValue;           //状态value，用于数据提交
@property (strong, nonatomic) LXPhotoPicker *picker;
//日期选择器
@property (weak, nonatomic) IBOutlet UIButton *planDateButton;
@property (weak, nonatomic) IBOutlet UIButton *endDateButton;
@property (nonatomic, strong) NSDate *planDate;
@property (nonatomic, strong) NSDate *endDate;
//联系人
@property (weak, nonatomic) IBOutlet UITextField *linkmanTextField;
@property (weak, nonatomic) IBOutlet UITextField *telephoneTextField;
@property (weak, nonatomic) IBOutlet UIView *pictureView;

@end

@implementation ActivityCreateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityTitleTextField.delegate = self;
    [self.currentCityButton setTitle:[LocationUtil getInstance].locatedCityName forState:(UIControlStateNormal)];
    self.planDate = [NSDate date];
    self.endDate = [NSDate date];
    self.linkmanTextField.text = [User getInstance].realname;
    self.telephoneTextField.text = [User getInstance].username;
    AJPhotoPickerView *picker = [[AJPhotoPickerView alloc] init];
    picker.frame = CGRectMake(0, 50, SCREEN_WIDTH, 58.0);
    picker.vc = self;
    [self.pictureView addSubview:picker];
}

///切换城市
- (IBAction)switchCity:(id)sender {
    CityViewController *vc = [[CityViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.delegete = self;
}

///选择了城市之后的回调
- (void)cityViewdidSelectCity:(NSString *)city anamation:(BOOL)anamation {
    [self.currentCityButton setTitle:city forState:(UIControlStateNormal)];
}

//选择活动类型
- (IBAction)selectType:(id)sender {
    //    数据预处理
    NSArray *array = [StatusDict activityType];
    NSMutableArray *names = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [names addObject:dict[@"typeName"]];
    }
    //弹出选择框
    [ActionSheetStringPicker showPickerWithTitle:@"选择活动类型" rows:names initialSelection:self.selectedTypeIndex doneBlock: ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        //            按钮赋值当前区名称
        self.selectedTypeIndex = selectedIndex;
        //            当前选值以提交
        self.selectedTypeValue = array[selectedIndex][@"typeCode"];
        [self.typeButton setTitle:selectedValue forState:(UIControlStateNormal)];
    } cancelBlock:nil origin:sender];
}

///选择开始日期
- (IBAction)selectPlanTime:(id)sender {
    AbstractActionSheetPicker *actionSheetPicker;actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"选择开始时间" datePickerMode:UIDatePickerModeDateAndTime selectedDate:self.planDate minimumDate:nil maximumDate:nil target:self action:@selector(dateWasSelected:element:) origin:sender];
    [actionSheetPicker showActionSheetPicker];
}

///开始日期回调
- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.planDate = selectedDate;
    [self.planDateButton setTitle:[DateUtil dateToFullString:self.planDate] forState:(UIControlStateNormal)];
}

///选择结束日期
- (IBAction)selectEndTime:(id)sender {
    AbstractActionSheetPicker *actionSheetPicker;actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"选择结束时间" datePickerMode:UIDatePickerModeDateAndTime selectedDate:self.endDate minimumDate:nil maximumDate:nil target:self action:@selector(endDateWasSelected:element:) origin:sender];
    [actionSheetPicker showActionSheetPicker];
}

///结束日期回调
- (void)endDateWasSelected:(NSDate *)selectedDate element:(id)element {
    self.endDate = selectedDate;
    [self.endDateButton setTitle:[DateUtil dateToFullString:self.endDate] forState:(UIControlStateNormal)];
}

///活动规范
- (IBAction)standardButtonPress:(id)sender {
    StandardViewController *vc = [[UIStoryboard storyboardWithName:@"Activity" bundle:nil] instantiateViewControllerWithIdentifier:@"standard"];
    vc.type = @"0";
    vc.naviTitle = @"活动发布规范";
    [self.navigationController pushViewController:vc animated:YES];
}

//点选相片或拍照
- (IBAction)selectPicture:(id)sender {
    [self.currentTextField resignFirstResponder];
    self.picker = [[LXPhotoPicker alloc] initWithParentView:self];
    self.picker.delegate = self;
    [self.picker selectPicture];
}

///LXPhoto Delegate
- (void)didSelectPhoto:(UIImage *)image {
    [self.headPictUrlButton setImage:image forState:(UIControlStateNormal)];
}

//保存按钮
- (IBAction)saveButtonPress:(id)sender {
    [self postData:BizStatusSave];
}

///提交到网络
- (void)postData:(NSInteger)bizStatus {

    NSMutableDictionary *activity = [NSMutableDictionary dictionaryWithDictionary:
                                     @{
                                       @"activityTitle":self.activityTitleTextField.text,
                                       @"bizStatus":[NSString stringWithFormat:@"%zi",bizStatus],//bizStatus区分保存与提交 保存是0 发布是1
                                       }
                                     ];
    if (self.picker.filePath) {
        [activity setObject:self.picker.filePath forKey:@"pictURL"];
    } else {
        [activity setObject:@"" forKey:@"pictURL"];
    }
    NSDictionary *param = @{
                            @"Activity":[StringUtil dictToJson:activity],
                            @"SrcStatus":@""
                            };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",HOST_URL,@"activity/saveActivity"];
    [manager POST:urlstr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (self.picker.filePath) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(self.picker.imageOriginal,0.8) name:@"pictURL" fileName:@"something.jpg" mimeType:@"image/jpeg"];
        }
        //            NSLog(@"urlstr:%@ param:%@",urlstr,param);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //            NSLog(@"responseObject:%@",responseObject);
        if ([responseObject[@"success"] boolValue]) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
            [self goBack];
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [[[UIAlertView alloc]initWithTitle:@"发布失败" message:@"网络故障，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
}

@end

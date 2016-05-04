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
#import "AJPhotoPickerGallery.h"
#import "JCTagListView.h"
#import "ImageUtil.h"


//线上或线下
typedef enum : NSUInteger {
    CityStyleOffline,
    CityStyleOnline
} CityStyle;
@interface ActivityCreateTableViewController ()<CityViewControllerDelegete,LXPhotoPickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *activityTitleTextField; //名称
@property (weak, nonatomic) IBOutlet UIButton *headPictUrlButton;       //头像
//@property (weak, nonatomic) IBOutlet EMTextView *projectResumeTextView; //简介
@property (weak, nonatomic) IBOutlet LXButton *currentCityButton;       //城市
@property (weak, nonatomic) IBOutlet LXButton *onlineCityButton;       //城市
@property (strong, nonatomic) NSString *cityname;       //城市名称或“线上”以传值服务端
@property (assign, nonatomic) CityStyle cityStyle;

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
@property (strong, nonatomic) AJPhotoPickerGallery *photoGallery;
//活动地点
@property (weak, nonatomic) IBOutlet UIView *planSiteContentView;
@property (weak, nonatomic) IBOutlet UITextField *planSiteTextField;
//报名人信息
@property (nonatomic, weak) IBOutlet JCTagListView *tagListView;
//基本成员变量
@property (weak, nonatomic) IBOutlet UITextField *planJoinNumTextField;      //限定人数
@property (weak, nonatomic) IBOutlet EMTextView *activityDetailsTextView;  //活动详情
@property (weak, nonatomic) IBOutlet EMTextView *applyRequireMentTextView;   //活动要求
//infoType = @"姓名、微信等6个"
@end

@implementation ActivityCreateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    隐藏键盘
    self.activityTitleTextField.delegate = self;
    if (self.dataDict != nil) {
//        编辑会传入dataDict
        [self editSetup];
    } else {
        [self createSetup];
    }
}

//编辑活动初始化
- (void) editSetup {
//    标题
    self.activityTitleTextField.text = [StringUtil toString:self.dataDict[@"activityTitle"]];
//    城市
    self.cityname = self.dataDict[@"city"];
    if (![self.dataDict[@"city"] isEqualToString:@"线上"]) {
//        线下
        [self.currentCityButton setTitle:self.dataDict[@"city"] forState:(UIControlStateNormal)];
        self.currentCityButton.backgroundColor = MAIN_COLOR;
        self.onlineCityButton.backgroundColor = [UIColor lightGrayColor];
    } else {
//        线上
        self.currentCityButton.backgroundColor = [UIColor lightGrayColor];
        self.onlineCityButton.backgroundColor = MAIN_COLOR;
    }
//    活动类型
    [self.typeButton setTitle:[StringUtil toString:self.dataDict[@"type"]] forState:(UIControlStateNormal)];
//      开始时间
    [self.planDateButton setTitle:[DateUtil toString:self.dataDict[@"planDate"] time:self.dataDict[@"planTime"]] forState:(UIControlStateNormal)];
    self.planDate = [DateUtil toDate:[NSString stringWithFormat:@"%@%@",self.dataDict[@"planDate"],self.dataDict[@"planTime"]] format:@"YYYYMMddHHmm"];
//      结束时间
    [self.endDateButton setTitle:[DateUtil toString:self.dataDict[@"endDate"] time:self.dataDict[@"endTime"]] forState:(UIControlStateNormal)];
    self.endDate = [DateUtil toDate:[NSString stringWithFormat:@"%@%@",self.dataDict[@"endDate"],self.dataDict[@"endTime"]] format:@"YYYYMMddHHmm"];
//      活动地点
    self.planSiteTextField.text = [StringUtil toString:self.dataDict[@"planSite"]];
//    报名人数
    if ([self.dataDict[@"planJoinNum"] integerValue] > 0) {
        self.planJoinNumTextField.text = [self.dataDict[@"planJoinNum"] stringValue];
    }
//    联系人
    self.linkmanTextField.text = [StringUtil toString:self.dataDict[@"linkMan"]];
    self.telephoneTextField.text = [StringUtil toString:self.dataDict[@"telePhone"]];
    //    照片选择器
    NSArray *photoArray = [[StringUtil toString:self.dataDict[@"detailPictURL"]] componentsSeparatedByString:@","];
    self.photoGallery = [[AJPhotoPickerGallery alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, IMAGE_WIDTH_WITH_PADDING) imageUrlArray: photoArray];
    self.photoGallery.vc = self;
    self.photoGallery.maxCount = 9;
    [self.pictureView addSubview:self.photoGallery];
//    活动介绍
    self.activityDetailsTextView.text = [StringUtil toString:self.dataDict[@"activityDetails"]];
    self.applyRequireMentTextView.text = [StringUtil toString:self.dataDict[@"applyRequirement"]];
    //    报名人要求，必须是无人报名时方可改动
    if ([self.dataDict[@"applyNum"] integerValue] == 0) {
        self.tagListView.canSelectTags = YES;
    } else {
        self.tagListView.canSelectTags = NO;
    }
//    初始
    self.tagListView.tags = [NSMutableArray arrayWithArray:@[@"姓名",@"手机",@"公司",@"职务",@"微信",@"邮箱"]];
//已选
    self.tagListView.selectedTags = [NSMutableArray arrayWithArray:[[StringUtil toString:self.dataDict[@"infoType"]] componentsSeparatedByString:@","]];
}

//创建活动初始化
- (void)createSetup {
    //    照片拾取
    self.picker = [[LXPhotoPicker alloc] initWithParentView:self];
    self.picker.delegate = self;
    self.picker.filename = [NSString stringWithFormat:@"avatar_%d.jpg",(int)([[NSDate date] timeIntervalSince1970])];
    
    //    当前城市
    [self.currentCityButton setTitle:[LocationUtil getInstance].locatedCityName forState:(UIControlStateNormal)];
    //    开始与结束时间
    self.planDate = [NSDate date];
    self.endDate = [NSDate date];
    //    默认联系人与电话
    self.linkmanTextField.text = [User getInstance].realname;
    self.telephoneTextField.text = [User getInstance].username;
    //    照片选择器
    self.photoGallery = [[AJPhotoPickerGallery alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, IMAGE_WIDTH_WITH_PADDING)];
    self.photoGallery.vc = self;
    self.photoGallery.maxCount = 9;
    [self.pictureView addSubview:self.photoGallery];
    //    线上样式
    self.onlineCityButton.backgroundColor = [UIColor lightGrayColor];
    self.cityname = [LocationUtil getInstance].locatedCityName;
    //    报名人要求
    self.tagListView.canSelectTags = YES;
    //    初始
    self.tagListView.tags = [NSMutableArray arrayWithArray:@[@"姓名",@"手机",@"公司",@"职务",@"微信",@"邮箱"]];
    //已选
    self.tagListView.selectedTags = [NSMutableArray arrayWithArray:@[@"姓名"]];
}

///线上与城市按钮相互切换
- (IBAction)switchCityStyle:(UIButton *)sender {
    self.cityStyle = sender.tag;
    if (sender.tag == CityStyleOffline) {
        self.currentCityButton.backgroundColor = MAIN_COLOR;
        self.onlineCityButton.backgroundColor = [UIColor lightGrayColor];
    } else {
        self.currentCityButton.backgroundColor = [UIColor lightGrayColor];
        self.onlineCityButton.backgroundColor = MAIN_COLOR;
    }
    [self.tableView reloadData];
    self.cityname = [sender titleForState:(UIControlStateNormal)];
}

//主要针对图片选择的回调
-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return the number of sections.
    if (indexPath.row == 11) {
        NSInteger imageCount = self.photoGallery.photos.count;
        CGFloat imageWidth = (SCREEN_WIDTH - 32) / 4.0 - 4;
        CGFloat height = ((imageCount / 4) + 1) * imageWidth + 60;
        return height;
    } else if (indexPath.row == 7) {
        if (self.cityStyle == CityStyleOnline) {
            self.planSiteContentView.hidden = YES;
            return 0.0;
        } else {
            self.planSiteContentView.hidden = NO;
            return 44.0;
        }
    }
    
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
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

//发布按钮
- (IBAction)publishButtonPress:(id)sender {
    [self postData:BizStatusPublish];
}

///提交到网络
- (void)postData:(NSInteger)bizStatus {
    if (bizStatus == BizStatusPublish) {
        
        //表单验证，考虑保存模式下可为空，
    }
//    考虑结束日期要大于开始日期
    NSMutableDictionary *activity = [NSMutableDictionary dictionaryWithDictionary:
                                     @{
                                       @"activityTitle":self.activityTitleTextField.text,
                                       @"city":self.cityname,
//                                       @"typeCode":self.selectedTypeValue,
                                       @"planDate":[DateUtil dateToDatePart:self.planDate],//日期需要转化20151123格式
                                       @"planTime":[DateUtil dateToTimePart:self.planDate],//Time convert to 2315 Style
                                       @"endDate":[DateUtil dateToDatePart:self.endDate],
                                       @"endTime":[DateUtil dateToTimePart:self.endDate],
                                       @"planJoinNum":self.planJoinNumTextField.text,
                                       @"planSite":self.planSiteTextField.text,
                                       @"linkMan":self.linkmanTextField.text,
                                       @"telePhone":self.telephoneTextField.text,
                                       @"applyRequireMent":self.applyRequireMentTextView.text,
                                       @"activityDetails":self.activityDetailsTextView.text,
                                       @"bizStatus":[NSString stringWithFormat:@"%zi",bizStatus],//bizStatus区分保存与提交 保存是0 发布是1
                                       @"infoType":[self.tagListView.selectedTags componentsJoinedByString:@","]
                                       }
                                     ];
//    活动类型
    if (self.selectedTypeValue != nil) {
        [activity setObject:self.selectedTypeValue forKey:@"typeCode"];
    }
//    多图
    if (self.photoGallery.photos.count > 0) {
        [activity setObject:[[ImageUtil getInstance] savePicture:@"detailPictURL" images:self.photoGallery.photos] forKey:@"detailPictURL"];
    }
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
//        logo
        if (self.picker.filePath) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(self.picker.imageOriginal,0.8) name:@"pictURL" fileName:self.picker.filename mimeType:@"image/jpeg"];
        }
//        多图
        if (self.photoGallery.photos.count > 0) {
            for (int i = 0; i < self.photoGallery.photos.count; i++) {
                UIImage *image = self.photoGallery.photos[i];
                [formData appendPartWithFileData:UIImageJPEGRepresentation(image,0.8) name:[NSString stringWithFormat:@"%zi",i] fileName:[ImageUtil getInstance].filenames[i] mimeType:@"image/jpeg"];
            }
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

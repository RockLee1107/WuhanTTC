//
//  ProjectBasicInfoViewController.m
//  Foundation
//
//  Created by 李志强 on 16/6/5.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

/***项目基本信息***/

#import "ProjectBasicInfoViewController.h"
#import "EMTextView.h"
#import "VerifyUtil.h"
#import "LXPhotoPicker.h"
#import "StatusDict.h"
#import "ActionSheetStringPicker.h"
#import "DateUtil.h"

@interface ProjectBasicInfoViewController ()<LXPhotoPickerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UITextField *projectName;
@property (weak, nonatomic) IBOutlet UIImageView *projectIconImage;
@property (weak, nonatomic) IBOutlet EMTextView *projectIntroduce;
@property (weak, nonatomic) IBOutlet UITextField *companyName;
@property (weak, nonatomic) IBOutlet UITextField *projectUrl;
@property (weak, nonatomic) IBOutlet UIButton *projectPeriod;
@property (weak, nonatomic) IBOutlet EMTextView *projectDesc;

@property (nonatomic, copy) NSString *originalAddress;

//项目领域
@property (strong, nonatomic) NSMutableArray *selectedCodeArray;
@property (strong, nonatomic) NSMutableArray *selectedNameArray;
@property (assign, nonatomic) NSInteger selectedStatusIndex;           //状态index，用于选择框反显
@property (strong, nonatomic) NSString *selectedStatusValue;           //状态value，用于数据提交

@property (strong, nonatomic) NSString *procStatusCode;
@property (strong, nonatomic) NSString *iconUrl;//选取的图片路径
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) UIImage  *img;

@property (strong, nonatomic) LXPhotoPicker *picker;

@property (nonatomic, strong) NSDate *planDate;

@end

@implementation ProjectBasicInfoViewController

- (void)viewWillDisappear:(BOOL)animated {
    if (self.block != nil) {
        self.block(@"ok");
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    //根据projectId判断是创建项目信息还是更新
//    if (![self.projectId isEqualToString:@""] && self.projectId != nil && ![self.projectId isKindOfClass:[NSNull class]]) {
//        [self loadData];
//    }
    
    //修改
    if (self.hasProject) {
        [self loadData];
    }
    //根据传过来的projectId来更新项目
    if (self.projectId != nil && ![self.projectId isKindOfClass:[NSNull class]] && ![self.projectId isEqualToString:@""]) {
        [self loadData];
    }

    [self createUI];
}

- (void)loadData {
    
    NSDictionary *dict = @{
                           @"sEQ_projectId":self.projectId,
                           @"sEQ_visible":@"private"
                           };
    NSString *jsonStr = [StringUtil dictToJson:dict];
    NSDictionary *param = @{@"QueryParams":jsonStr};
    
    [self.service POST:@"project/getProjectBaseInfo" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //展现请求的已经填过的数据
        self.projectName.text = responseObject[@"projectName"];
        [self.projectIconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", UPLOAD_URL,responseObject[@"headPictUrl"]]]];
        
        //取出已经传到服务器的地址
        self.originalAddress = [NSString stringWithFormat:@"%@", responseObject[@"headPictUrl"]];
        
        self.projectIntroduce.text = responseObject[@"projectResume"];
        self.companyName.text = responseObject[@"company"] ? responseObject[@"company"] : @"";
        if (![responseObject[@"procUrl"] isKindOfClass:[NSNull class]]) {
            self.projectUrl.text = responseObject[@"procUrl"];
        }
        [self.projectPeriod setTitle:responseObject[@"procStatusName"] forState:UIControlStateNormal];
        self.projectDesc.text = responseObject[@"projectDesc"];
        self.procStatusCode = [NSString stringWithFormat:@"%@", responseObject[@"procStatusCode"]];
        
    } noResult:^{
        NSLog(@"22222222222");
    }];
    
}

- (void)createUI {
    self.projectIconImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *taper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    taper.numberOfTapsRequired    = 1;
    taper.numberOfTouchesRequired = 1;
    [self.projectIconImage addGestureRecognizer:taper];
    
    //    照片拾取
    self.picker = [[LXPhotoPicker alloc] initWithParentView:self];
    self.picker.delegate = self;
    self.picker.filename = [NSString stringWithFormat:@"avatar_%d.jpg",(int)([[NSDate date] timeIntervalSince1970])];
    
    self.commitBtn.backgroundColor = MAIN_COLOR;
    [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)tap {
    [self.currentTextField resignFirstResponder];
    [self.picker selectPicture];
}

//点击提交
- (IBAction)commitBtnClick:(id)sender {
    
    //提交--->更新项目
    if (self.projectId != nil && ![self.projectId isEqualToString:@""] && ![self.projectId isKindOfClass:[NSNull class]]) {
        if (![VerifyUtil isValidStringLengthRange:self.projectName.text between:2 and:20]) {
            [SVProgressHUD showErrorWithStatus:@"请输入活动名称(2-20字)"];
            return ;
        }
        if (![VerifyUtil isValidStringLengthRange:self.projectIntroduce.text between:2 and:50]) {
            [SVProgressHUD showErrorWithStatus:@"请填写项目简介(2-50字)"];
            return ;
        }
        if (![VerifyUtil isValidStringLengthRange:self.companyName.text between:2 and:50]) {
            [SVProgressHUD showErrorWithStatus:@"请填写公司信息(2-50字)"];
            return ;
        }
        if ([self.commitBtn.titleLabel.text isEqualToString:@"请选择"]) {
            [SVProgressHUD showErrorWithStatus:@"请选择项目阶段"];
            return ;
        }
        if (![VerifyUtil isValidStringLengthRange:self.projectDesc.text between:2 and:50]) {
            [SVProgressHUD showErrorWithStatus:@"请输入项目描述(2-500字)"];
            return ;
        }
        
        //获取系统时间
        self.planDate = [NSDate date];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                     @{
                                       @"bizStatus":self.bizStatus ? self.bizStatus : @"0",
                                       @"bpId":[User getInstance].bpId,
                                       @"bpVisible":@"0",
                                       @"company":self.companyName.text,
                                       @"createdDate":[DateUtil dateToDatePart:self.planDate],//日期需要转化20151123格式  记录创建时间当前年月日
                                       @"createdTime":[DateUtil dateToSecondPart:self.planDate],//Time convert to 2315 Style  当前时分秒
                                       @"procStatusCode":self.selectedStatusValue ? self.selectedStatusValue : self.procStatusCode,
                                       @"projectDesc":self.projectDesc.text,
                                       @"projectName":self.projectName.text,
                                       @"projectResume":self.projectIntroduce.text,
                                       @"projectId":self.projectId,
                                       @"procUrl":self.projectUrl.text ? self.projectUrl.text : @"",

                                       }];
        NSString *flag = [self.bizStatus isEqualToString:@"2"] ? @"true" : @"false";
        
        
        if (self.picker.filePath) {
            [dict setObject:self.picker.filePath forKey:@"headPictUrl"];
        } else {
            [dict setObject:self.originalAddress forKey:@"headPictUrl"];
        }
        
        NSString *jsonStr = [StringUtil dictToJson:dict];
        NSDictionary *param = @{@"Project":jsonStr,
                                @"flag":flag};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *urlstr = [NSString stringWithFormat:@"%@/%@",HOST_URL,@"project/saveProject"];
        urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager POST:urlstr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //        logo
//            NSLog(@"修改后上传的路径\n%@", self.iconUrl);
                //如果是选择了图片
            if (self.picker.filePath) {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(self.picker.imageOriginal,0.8) name:@"headPictUrl" fileName:self.picker.filename mimeType:@"image/jpeg"];
            }
           
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            
            //
            self.commitBtn.userInteractionEnabled = NO;
        
            if ([responseObject[@"success"] boolValue]) {
                NSString *oldId = [User getInstance].projectId;
                NSString *newId = responseObject[@"data"];
                NSLog(@"aaaaaaaaaaaaa\n 审核通过后第一次修改获得副本newId:%@", newId);
                NSLog(@"bbbbbbbbbbbbb\n 原Id:%@", oldId);
                
                //提交审核通过后再进行修改会返回一个新的projectId，也就是副本id,把之前的老id覆盖掉,之后加载该页面用的就是新id,后台会自动判断，如果项目没有提交审核通过，只是修改的话会返回老projectId
                [User getInstance].projectId = newId;
                
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
    //提交--->创建项目
    else {
        
        if (![VerifyUtil isValidStringLengthRange:self.projectName.text between:2 and:20]) {
            [SVProgressHUD showErrorWithStatus:@"请输入活动名称(2-20字)"];
            return ;
        }
        if (self.picker.imageOriginal == nil) {
            [SVProgressHUD showErrorWithStatus:@"请上传项目图片"];
            return ;
        }
        if (![VerifyUtil isValidStringLengthRange:self.projectIntroduce.text between:3 and:50]) {
            [SVProgressHUD showErrorWithStatus:@"请填写项目简介(3-50字)"];
            return ;
        }
        if (![VerifyUtil isValidStringLengthRange:self.companyName.text between:3 and:50]) {
            [SVProgressHUD showErrorWithStatus:@"请填写公司信息(3-50字)"];
            return ;
        }
        
        if ([self.commitBtn.titleLabel.text isEqualToString:@"请选择"]) {
            [SVProgressHUD showErrorWithStatus:@"请选择项目阶段"];
            return ;
        }
        if (![VerifyUtil isValidStringLengthRange:self.projectDesc.text between:3 and:50]) {
            [SVProgressHUD showErrorWithStatus:@"请输入项目描述(3-500字)"];
            return ;
        }
        
        //获取系统时间
        self.planDate = [NSDate date];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                     @{
                                       @"bizStatus":@"0",
                                       @"bpId":[User getInstance].bpId,
                                       @"bpVisible":@"0",
                                       @"company":self.companyName.text,
                                       @"SEQ_orderBy":@"pbDate",//（pbDate发布时间，planDate活动开始时间，applyNum参与数
                                       @"createdDate":[DateUtil dateToDatePart:self.planDate],//日期需要转化20151123格式  记录创建时间当前年月日
                                       @"createdTime":[DateUtil dateToSecondPart:self.planDate],//Time convert to 2315 Style  当前时分秒
                                       @"procStatusCode":self.selectedStatusValue,
                                       @"projectDesc":self.projectDesc.text,
                                       @"projectName":self.projectName.text,
                                       @"projectResume":self.projectIntroduce.text,
                                       @"headPictUrl":self.iconUrl,
                                       @"procUrl":self.projectUrl.text ? self.projectUrl.text : @""
                                       }];
        
        //活动的单张图片路径
        //     NSLog(@"\n选取的图片路径为：%@", self.picker.filePath);
        if (self.iconUrl) {
            [dict setObject:self.iconUrl forKey:@"headPictUrl"];
        
        } else {
            [dict setObject:@"" forKey:@"headPictUrl"];
        }
        
        NSString *jsonStr = [StringUtil dictToJson:dict];
        NSDictionary *param = @{@"Project":jsonStr};
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSString *urlstr = [NSString stringWithFormat:@"%@/%@",HOST_URL,@"project/saveProject"];
        urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager POST:urlstr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //        logo
            if (self.iconUrl) {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(self.picker.imageOriginal,0.8) name:@"headPictUrl" fileName:self.iconUrl mimeType:@"image/jpeg"];
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            
            self.commitBtn.userInteractionEnabled = NO;
            
            if ([responseObject[@"success"] boolValue]) {
                [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
                
                //创建的时候用一个不同的单例传值回去 下次进入这个页面根据pid进行修改
                [User getInstance].createProjectId = responseObject[@"data"];
                
                
                //保存成功后通知上个页面刷新勾选状态
                if (self.block != nil) {
                    self.block(@"ok");
                }
    
                [self goBack];
            } else {
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [[[UIAlertView alloc]initWithTitle:@"发布失败" message:@"网络故障，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
    }
}

//选择项目阶段
- (IBAction)projectPeriodBtnClick:(id)sender {
    //    数据预处理
    NSArray *array = [StatusDict procStatus];
    NSMutableArray *names = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [names addObject:dict[@"procStatusName"]];
    }
    //弹出选择框
    [ActionSheetStringPicker showPickerWithTitle:@"选择项目阶段" rows:names initialSelection:self.selectedStatusIndex doneBlock: ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        //            按钮赋值当前区名称
        self.selectedStatusIndex = selectedIndex;
        //            当前选值以提交
        self.selectedStatusValue = array[selectedIndex][@"procStatusCode"];
        [self.projectPeriod setTitle:selectedValue forState:(UIControlStateNormal)];
    } cancelBlock:nil origin:sender];
}

#pragma mark - LXPhotoPickerDelegate
// Logo图片选取后回调
- (void)didSelectPhoto:(UIImage *)image {
    self.projectIconImage.image = image;
}

- (void)sendImageFilePath:(NSString *)filePath {
    self.iconUrl = filePath;
    NSLog(@"选择照片回调路径:\n%@", self.iconUrl);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

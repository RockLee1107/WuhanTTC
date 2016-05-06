//
//  ProjectCreateTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ProjectCreateTableViewController.h"
#import "CityViewController.h"
#import "ActionSheetStringPicker.h"
#import "StatusDict.h"
#import "BizViewController.h"
#import "VerifyUtil.h"
//#import "SingletonObject.h"

//编辑、添加共用ProjectCreateTableViewController
@interface ProjectCreateTableViewController ()<CityViewControllerDelegete,BizViewControllerDelegate,LXPhotoPickerDelegate>

@end

@implementation ProjectCreateTableViewController

- (instancetype)init {
    self = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"create"];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectNameTextField.delegate = self;
    //pid意味着编辑，而不是创建
    
    if (self.pid != nil) {
       
        NSDictionary *param = @{
                                @"projectId":self.pid
                                };
        [self.service GET:@"/project/getProjectDto" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.dataDict = responseObject;
            [self editSetup];
            
        } noResult:^{
            
        }];
        
    } else {
        [self createSetup];
    }


}

//创建时初始化
- (void)createSetup {
    [self.currentCityButton setTitle:[LocationUtil getInstance].locatedCityName forState:(UIControlStateNormal)];
    self.pictureView.hidden = YES;
}

//编辑时初始化
- (void)editSetup {
//    名称
    self.projectNameTextField.text = [StringUtil toString:self.dataDict[@"projectName"]];
    //    照片拾取
    self.picker = [[LXPhotoPicker alloc] initWithParentView:self];
    self.picker.delegate = self;
    self.picker.filename = [NSString stringWithFormat:@"avatar_%d.jpg",(int)([[NSDate date] timeIntervalSince1970])];
    UIImageView *avatarImageView = [UIImageView new];
    NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:self.dataDict[@"headPictUrl"]]];
    [avatarImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] placeholderImage:[UIImage new] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        //        self.avatarImage = image;
        self.picker.imageOriginal = image;
        [self.headPictUrlButton setImage:image forState:(UIControlStateNormal)];
    } failure:nil];
//    项目简介
    self.projectResumeTextView.text = [StringUtil toString:self.dataDict[@"projectResume"]];
//    项目阶段
    [self.statusButton setTitle:[StringUtil toString:self.dataDict[@"procStatusName"]] forState:(UIControlStateNormal)];
//    融资阶段
    [self.financeButton setTitle:[StringUtil toString:self.dataDict[@"financeProcName"]] forState:(UIControlStateNormal)];
//    项目领域
    [self.bizButton setTitle:[StringUtil toString:self.dataDict[@"bizName"]] forState:(UIControlStateNormal)];
    self.selectedNameArray = [NSMutableArray arrayWithArray:[[StringUtil toString:self.dataDict[@"bizName"]] componentsSeparatedByString:@","]];
    //    项目描述
    self.projectResumeTextView.text = [StringUtil toString:self.dataDict[@"desc"]];
    //    照片选择器
    NSArray *photoArray = [[StringUtil toString:self.dataDict[@"bppictUrl"]] componentsSeparatedByString:@","];
    self.photoGallery = [[AJPhotoPickerGallery alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, IMAGE_WIDTH_WITH_PADDING) imageUrlArray: photoArray];
    self.photoGallery.vc = self;
    self.photoGallery.maxCount = 20;
    [self.pictureView addSubview:self.photoGallery];
    
//      城市
    [self.currentCityButton setTitle:self.dataDict[@"area"] forState:(UIControlStateNormal)];
    [self.tableView reloadData];
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

///选择了投资领域的回调
- (void)didSelectedTags:(NSMutableArray *)selectedCodeArray selectedNames:(NSMutableArray *)selectedNameArray {
    [self.bizButton setTitle:[selectedNameArray componentsJoinedByString:@","] forState:(UIControlStateNormal)];
    self.selectedCodeArray = selectedCodeArray;
    self.selectedNameArray = selectedNameArray;
}

//选择项目阶段
- (IBAction)selectStatus:(id)sender {
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
        [self.statusButton setTitle:selectedValue forState:(UIControlStateNormal)];
    } cancelBlock:nil origin:sender];
}

//选择融资阶段
- (IBAction)selectFinace:(id)sender {
    //    数据预处理
    NSArray *array = [StatusDict financeProc];
    NSMutableArray *names = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [names addObject:dict[@"financeProcName"]];
    }
    //弹出选择框
    [ActionSheetStringPicker showPickerWithTitle:@"选择融资阶段" rows:names initialSelection:self.selectedFinanceIndex doneBlock: ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        //            按钮赋值当前区名称
        self.selectedFinanceIndex = selectedIndex;
        //            当前选值以提交
        self.selectedFinanceValue = array[selectedIndex][@"financeProcCode"];
        [self.financeButton setTitle:selectedValue forState:(UIControlStateNormal)];
    } cancelBlock:nil origin:sender];
}

//投资领域
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"biz"]) {
        BizViewController *vc = segue.destinationViewController;
        vc.selectedCodeArray = self.selectedCodeArray;
        vc.selectedNameArray = self.selectedNameArray;
        vc.delegate = self;
    }
}

//提交数据
- (IBAction)createButtonPress:(id)sender {
    if (![VerifyUtil hasValue:self.projectNameTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写项目名称"];
        return;
    }
    if (![VerifyUtil hasValue:self.picker.filePath]) {
        [SVProgressHUD showErrorWithStatus:@"请上传项目Logo"];
        return;
    }
    if (![VerifyUtil isValidStringLengthRange:self.projectResumeTextView.text between:3 and:50]) {
        [SVProgressHUD showErrorWithStatus:@"项目简介字数为3～50"];
        return;
    }
    if ([[self.currentCityButton titleForState:(UIControlStateNormal)] isEqualToString:@"城市"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择所在城市"];
        return;
    }
    if (![VerifyUtil hasValue:self.selectedStatusValue]) {
        [SVProgressHUD showErrorWithStatus:@"请选择项目阶段"];
        return;
    }
    if (![VerifyUtil hasValue:self.selectedFinanceValue]) {
        [SVProgressHUD showErrorWithStatus:@"请选择融资阶段"];
        return;
    }
    if (self.selectedCodeArray.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择项目领域"];
        return;
    }
    if (![VerifyUtil isValidStringLengthRange:self.descTextView.text between:3 and:50]) {
        [SVProgressHUD showErrorWithStatus:@"项目描述字数为3～500"];
        return;
    }
    
    NSDictionary *project = @{
                            @"projectName":self.projectNameTextField.text,
                            @"headPictUrl":self.picker.filePath,
                            @"projectResume":self.projectResumeTextView.text,
                            @"desc":self.descTextView.text,
                            @"procStatusCode":self.selectedStatusValue,
                            @"financeProcCode":self.selectedFinanceValue,
                            @"area":[self.currentCityButton titleForState:(UIControlStateNormal)],
                            @"bizCode":[self.selectedCodeArray componentsJoinedByString:@","]
                            };
    NSDictionary *team = @{
                           @"parterId":[User getInstance].uid,
                           @"duty":@"创始人"
                           };
    NSDictionary *param = @{
                            @"Project":[StringUtil dictToJson:project],
                            @"Team":[StringUtil dictToJson:@[team]]
                            };
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",HOST_URL,@"project/prefectProject"];
    [manager POST:urlstr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(self.picker.imageOriginal,0.8) name:@"headPictUrl" fileName:@"something.jpg" mimeType:@"image/jpeg"];
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
//    [self.service POST:@"personal/prefectProject" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
//        [self goBack];
//    } noResult:nil];
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

#pragma mark - tb delegate 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //pid意味着真正的编辑，而不是创建
    if (self.dataDict == nil || self.pid == nil) {
        if (indexPath.section == 0 && indexPath.row == 8) {
            return 0;
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //pid意味着真正的编辑，而不是创建
    if (self.dataDict != nil && self.pid != nil) {
        return 1;
    }
    return [super numberOfSectionsInTableView:tableView];
}
@end

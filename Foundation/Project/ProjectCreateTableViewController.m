//
//  ProjectCreateTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/4/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ProjectCreateTableViewController.h"
#import "EMTextView.h"
#import "CityViewController.h"
#import "LXButton.h"
#import "ActionSheetStringPicker.h"
#import "StatusDict.h"
#import "BizViewController.h"
#import "VerifyUtil.h"

@interface ProjectCreateTableViewController ()<CityViewControllerDelegete,BizViewControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *projectNameTextField; //名称
@property (weak, nonatomic) IBOutlet UIButton *headPictUrlButton;       //头像
@property (strong, nonatomic) UIImage *imageOriginal;
@property (weak, nonatomic) IBOutlet EMTextView *projectResumeTextView; //简介
@property (weak, nonatomic) IBOutlet LXButton *currentCityButton;       //城市
//项目状态
@property (weak, nonatomic) IBOutlet UIButton *statusButton;         //按钮，用于显示所选中文值
@property (assign, nonatomic) NSInteger selectedStatusIndex;           //状态index，用于选择框反显
@property (strong, nonatomic) NSString *selectedStatusValue;           //状态value，用于数据提交
//融资阶段
@property (weak, nonatomic) IBOutlet UIButton *financeButton;
@property (assign, nonatomic) NSInteger selectedFinanceIndex;
@property (strong, nonatomic) NSString *selectedFinanceValue;
//项目领域
@property (weak, nonatomic) IBOutlet UIButton *bizButton;
@property (strong, nonatomic) NSMutableArray *selectedCodeArray;
@property (strong, nonatomic) NSMutableArray *selectedNameArray;

@property (weak, nonatomic) IBOutlet EMTextView *descTextView;          //描述
@property (nonatomic,strong) NSString *filePath;

@end

@implementation ProjectCreateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.projectNameTextField.delegate = self;
}

///切换城市
- (IBAction)switchCity:(id)sender {
    CityViewController *vc = [[CityViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.delegete = self;
//    vc.vc = self;
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
    if (![VerifyUtil hasValue:self.filePath]) {
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
                            @"headPictUrl":self.filePath,
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
        [formData appendPartWithFileData:UIImageJPEGRepresentation(self.imageOriginal,0.8) name:@"headPictUrl" fileName:@"something.jpg" mimeType:@"image/jpeg"];
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
        [[[UIAlertView alloc]initWithTitle:@"上传失败" message:@"网络故障，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
//    [self.service POST:@"personal/prefectProject" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
//        [self goBack];
//    } noResult:nil];
}


/**upload img*/
//点选相片或拍照
- (IBAction)selectPicture:(id)sender {
    [self.currentTextField resignFirstResponder];
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄图片",@"图片选择",nil];
    [sheet showInView:self.view];
}
//保存图片到沙盒
- (void)savePicture {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"something.jpg"]];   // 保存文件的名称
    BOOL result = [UIImagePNGRepresentation(self.imageOriginal)writeToFile: filePath    atomically:YES]; // 保存成功会返回YES
    if (result) {
        self.filePath = filePath;
    }
}
//点击选取or从本机相册选择的ActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex) {
        [self takeOrSelectPhoto:UIImagePickerControllerSourceTypeCamera];
    } else if (1 == buttonIndex){
        [self takeOrSelectPhoto:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    }
}

- (void)takeOrSelectPhoto:(UIImagePickerControllerSourceType)sourceType {
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.mediaTypes = mediaTypes;
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
}

//用户上传照片-取消操作
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //    最原始的图
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //    先减半传到服务器
    UIImage *imageOriginal = [CommonUtil shrinkImage:image toSize:CGSizeMake(0.3*image.size.width, 0.3*image.size.height)];
    self.imageOriginal = imageOriginal;
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.headPictUrlButton setImage:self.imageOriginal forState:(UIControlStateNormal)];
        [self savePicture];
    }];
}
@end

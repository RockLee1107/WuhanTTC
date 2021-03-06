//
//  UserInfoTableViewController.m
//  Foundation
//
//  Created by HuangXiuJie on 16/4/5.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "UserInfoTableViewController.h"
#import "CityViewController.h"
#import "LXPhotoPicker.h"
#import "ModifyMobileViewController.h"
#import "LXButton.h"
#import "ActionSheetStringPicker.h"
#import "StatusDict.h"
#import "BizViewController.h"
#import "ProcessViewController.h"
#import "VerifyUtil.h"
#import "EMTextView.h"

@interface UserInfoTableViewController ()<LXPhotoPickerDelegate,BizViewControllerDelegate,ProcessViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *realnameTextField;
@property (weak, nonatomic) IBOutlet UIButton    *mobileButton;
@property (weak, nonatomic) IBOutlet UITextField *wechatTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *dutyTextField;
@property (weak, nonatomic) IBOutlet UITextField *companyTextField;
@property (weak, nonatomic) IBOutlet UITextField *areaTextField;
@property (strong, nonatomic) LXPhotoPicker *picker;
@property (strong, nonatomic) NSDictionary  *userinfo;
@property (strong, nonatomic) NSDictionary  *investorInfo;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic) UIImage  *avatarImage;
@property (strong, nonatomic) NSString *filename;
/*投资人部分*/
//投资领域
@property (weak, nonatomic) IBOutlet UIButton *bizButton;
@property (strong, nonatomic) NSMutableArray *selectedCodeArray;
@property (strong, nonatomic) NSMutableArray *selectedNameArray;
//投资阶段
@property (weak, nonatomic) IBOutlet UIButton *processButton;
@property (strong, nonatomic) NSMutableArray *processCodeArray;
@property (strong, nonatomic) NSMutableArray *processNameArray;
@property (weak, nonatomic) IBOutlet EMTextView *investIdeaTextView;
@property (weak, nonatomic) IBOutlet EMTextView *investCaseTextView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UIView *cell0;
@property (weak, nonatomic) IBOutlet UIView *cell1;
@property (weak, nonatomic) IBOutlet UIView *cell2;
@property (weak, nonatomic) IBOutlet UIView *cell3;
@property (weak, nonatomic) IBOutlet UIView *cell4;

@end

@implementation UserInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    隐藏键盘
    self.realnameTextField.delegate = self;
    self.wechatTextField.delegate = self;
    self.emailTextField.delegate = self;
    self.dutyTextField.delegate = self;
    self.companyTextField.delegate = self;
    self.areaTextField.delegate = self;
//    请求网络
    [self fetchData];
//    初始化图片选择控件，重点是filename要预先设置好，适配不传图原路返回的情况
    self.picker = [[LXPhotoPicker alloc] initWithParentView:self];
    self.picker.delegate = self;
    self.picker.filename = [NSString stringWithFormat:@"avatar_%d.jpg",(int)([[NSDate date] timeIntervalSince1970])];
//    头像圆角
    self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.frame) / 2.0;
    self.avatarImageView.clipsToBounds = YES;
}

//访问网络
- (void)fetchData {
    NSDictionary *param = @{
                            @"userId":[User getInstance].uid
                            };
    [self.service POST:@"/personal/info/getUserInfo" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.userinfo = responseObject[@"userinfo"];
        self.investorInfo = responseObject[@"investorInfo"];
        responseObject = responseObject[@"userinfo"];
        NSString *pictUrl = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,self.userinfo[@"pictUrl"]];
        
        [self.avatarImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pictUrl]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            self.avatarImage = image;
            [self.avatarImageView setImage:image];
        } failure:nil];
        self.realnameTextField.text = [StringUtil toString:responseObject[@"realName"]];
        [self.mobileButton setTitle:[User getInstance].username forState:(UIControlStateNormal)];
        self.wechatTextField.text = [StringUtil toString:responseObject[@"weChat"]];
        self.emailTextField.text = [StringUtil toString:responseObject[@"email"]];
        self.dutyTextField.text = [StringUtil toString:responseObject[@"duty"]];
        self.companyTextField.text = [StringUtil toString:responseObject[@"company"]];
        self.areaTextField.text = [StringUtil toString:responseObject[@"area"]];
        //投资人部分
        self.typeLabel.text = [[[User getInstance] isInvestor] boolValue] ? @"投资人" : @"创业者";
        if ([[[User getInstance] isInvestor] boolValue]){
            self.investIdeaTextView.text = [StringUtil toString:self.investorInfo[@"investIdea"]];
            self.investCaseTextView.text = [StringUtil toString:self.investorInfo[@"investProjects"]];
            [self.bizButton setTitle:self.investorInfo[@"investArea"] forState:(UIControlStateNormal)];
            [self.processButton setTitle:self.investorInfo[@"investProcess"] forState:(UIControlStateNormal)];
        } else {
            self.cell0.hidden = YES;
            self.cell1.hidden = YES;
            self.cell2.hidden = YES;
            self.cell3.hidden = YES;
            self.cell4.hidden = YES;
        }
        
    } noResult:nil];
}

//modify mobile
- (IBAction)mobileButtonPress:(id)sender {
    [[PXAlertView showAlertWithTitle:@"确定要修改手机号码？" message:nil cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if (!cancelled) {
            ModifyMobileViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"modify"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }] useDefaultIOS7Style];
}


//tb delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //上传头像
        [self selectPicture];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//点选相片或拍照
- (void)selectPicture {
    [self.picker selectPicture];
}

#pragma mark - PickerDelegate
- (void)didSelectPhoto:(UIImage *)image {
    [self.avatarImageView setImage:image];
    self.avatarImage = image;
}
- (void)sendImageFilePath:(NSString *)filePath {
    
}

//点击保存
- (IBAction)updateUserInfo:(id)sender {
    NSMutableDictionary *userinfo = [NSMutableDictionary dictionaryWithDictionary:
                                     @{
                                       @"userId":[User getInstance].uid,
                                       @"realName":self.realnameTextField.text,
                                       @"email":self.emailTextField.text,
                                       @"duty":self.dutyTextField.text,
                                       @"company":self.companyTextField.text,
                                       @"area":self.areaTextField.text,
                                       @"weChat":self.wechatTextField.text,
                                       @"mobile":[User getInstance].username
                                       }
                                     ];
    
    if (self.picker.filePath != nil) {
        [userinfo setObject:self.picker.filePath forKey:@"pictUrl"];
    } else if(self.userinfo[@"pictUrl"] == [NSNull null]){
        //且原先就没有头像的，赋值空串，否则逻辑有误，则原头像弄丢。
        [userinfo setObject:@"" forKey:@"pictUrl"];
    } else if (self.userinfo[@"pictUrl"] != [NSNull null]) {
        //原先就有头像的，原值传回
        NSString *pictUrl = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,self.userinfo[@"pictUrl"]];
        [userinfo setObject:pictUrl forKey:@"pictUrl"];
        //不选图片名称，则取回之前的图片名称
        self.picker.filename = self.userinfo[@"pictUrl"];
    }
//    @"pictUrl":self.picker.filePath,
    if ([[User getInstance].isInvestor boolValue]) {
        if (![VerifyUtil isValidStringLengthRange:self.investIdeaTextView.text between:3 and:200]) {
            [SVProgressHUD showErrorWithStatus:@"请输入投资理念(3-200字)"];
            return;
        }
        
        if (![VerifyUtil isValidStringLengthRange:self.investCaseTextView.text between:3 and:500]) {
            [SVProgressHUD showErrorWithStatus:@"请输入投资案例(3-500字)"];
            return;
        }
    }
    
    
    
//    NSDictionary *dict = @{
//              @"userinfo":userinfo,
//              @"investorInfo":@{}
//              };
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    //userinfo必有
    [dict setObject:userinfo forKey:@"userinfo"];
    if ([[[User getInstance] isInvestor] boolValue]) {
//        投资人才要传如下值

        
        NSDictionary *investorInfo = @{
                                                                                @"investIdea":self.investIdeaTextView.text,
                                                                                @"investProjects":self.investCaseTextView.text,
                                                                                @"investProcess":self.processButton.currentTitle,
                                                                                @"investArea":self.bizButton.currentTitle,
                                                                                @"bizStatus":@0,
                                                                                @"userId":[User getInstance].uid
                                                                                };
        [dict setObject:investorInfo forKey:@"investorInfo"];

    }

    NSDictionary *param = @{@"UserInfoDto":[StringUtil dictToJson:dict]};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",HOST_URL,@"personal/info/setUserTotalInfo"];
    [manager POST:urlstr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (self.picker.filePath != nil || self.userinfo[@"pictUrl"] != [NSNull null]) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(self.avatarImage,0.8) name:@"pictUrl" fileName:self.picker.filename mimeType:@"image/jpeg"];
        }
        //            NSLog(@"urlstr:%@ param:%@",urlstr,param);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //            NSLog(@"responseObject:%@",responseObject);
        if ([responseObject[@"success"] boolValue]) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
            User *user = [User getInstance];
            if ([VerifyUtil hasValue:self.companyTextField.text]) {
                user.company = self.companyTextField.text;
            }
            if ([VerifyUtil hasValue:self.emailTextField.text]) {
                user.email = self.emailTextField.text;
            }
            if ([VerifyUtil hasValue:self.dutyTextField.text]) {
                user.duty = self.dutyTextField.text;
            }
            if ([VerifyUtil hasValue:self.wechatTextField.text]) {
                user.wechat = self.wechatTextField.text;
            }
            [self goBack];
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [[[UIAlertView alloc]initWithTitle:@"上传失败" message:@"网络故障，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
}

//选择城市
- (IBAction)selectArea:(id)sender {
    CityViewController *vc = [[CityViewController alloc] init];
    vc.vc = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//回调填充城市
- (void)fillArea {
    self.areaTextField.text = [LocationUtil getInstance].locatedCityName;
}

///选择了投资领域的回调
- (void)didSelectedTags:(NSMutableArray *)selectedCodeArray selectedNames:(NSMutableArray *)selectedNameArray {
    
    [self.bizButton setTitle:[selectedNameArray componentsJoinedByString:@","] forState:(UIControlStateNormal)];
    self.selectedCodeArray = selectedCodeArray;
    self.selectedNameArray = selectedNameArray;
}

//投资阶段
- (IBAction)selectProcess:(id)sender {
    ProcessViewController *vc = [[UIStoryboard storyboardWithName:@"Investor" bundle:nil] instantiateViewControllerWithIdentifier:@"process"];
    vc.selectedCodeArray = self.processCodeArray;
    vc.selectedNameArray = self.processNameArray;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//投资领域
- (IBAction)selectBiz:(id)sender {
    BizViewController *vc = [[UIStoryboard storyboardWithName:@"Investor" bundle:nil] instantiateViewControllerWithIdentifier:@"biz"];
    vc.selectedCodeArray = self.selectedCodeArray;
    vc.selectedNameArray = self.selectedNameArray;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"biz"]) {
//        BizViewController *vc = segue.destinationViewController;
//        vc.selectedCodeArray = self.selectedCodeArray;
//        vc.selectedNameArray = self.selectedNameArray;
//        vc.delegate = self;
//    }
//    else if ([segue.identifier isEqualToString:@"process"]) {
//        ProcessViewController *vc = segue.destinationViewController;
//        vc.selectedCodeArray = self.processCodeArray;
//        vc.selectedNameArray = self.processNameArray;
//        vc.delegate = self;
//    }
//}


///选择了投资阶段的回调
- (void)didSelectedProcess:(NSMutableArray *)selectedCodeArray selectedNames:(NSMutableArray *)selectedNameArray {
    [self.processButton setTitle:[selectedNameArray componentsJoinedByString:@","] forState:(UIControlStateNormal)];
    self.processCodeArray = selectedCodeArray;
    self.processNameArray = selectedNameArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![[[User getInstance] isInvestor] boolValue]){
        if (indexPath.section == 1) {
            return 0;
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
@end

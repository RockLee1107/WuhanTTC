//
//  VerifyTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/5/4.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "VerifyTableViewController.h"
#import "StandardViewController.h"
#import "EMTextView.h"

#import "LXButton.h"
#import "ActionSheetStringPicker.h"
#import "StatusDict.h"
#import "BizViewController.h"
#import "ProcessViewController.h"
#import "VerifyUtil.h"
#import "LXPhotoPicker.h"
#import "AJPhotoPickerGallery.h"
#import "ImageUtil.h"

@interface VerifyTableViewController ()<BizViewControllerDelegate,ProcessViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UITextField *investInstitutionTextField;
@property (weak, nonatomic) IBOutlet UITextField *investUrlTextField;


//投资领域
@property (weak, nonatomic) IBOutlet UIButton *bizButton;
@property (strong, nonatomic) NSMutableArray *selectedCodeArray;
@property (strong, nonatomic) NSMutableArray *selectedNameArray;

@property (weak, nonatomic) IBOutlet EMTextView *investIdeaTextView;

@property (weak, nonatomic) IBOutlet EMTextView *investCaseTextView;

//投资阶段
@property (weak, nonatomic) IBOutlet UIButton *processButton;
@property (strong, nonatomic) NSMutableArray *processCodeArray;
@property (strong, nonatomic) NSMutableArray *processNameArray;
//photo picker
@property (weak, nonatomic) IBOutlet UIView *pictureView;
@property (strong, nonatomic) AJPhotoPickerGallery *photoGallery;
@end

@implementation VerifyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setDynamicLayout];
    self.realnameLabel.text = [User getInstance].realname;
    self.mobileLabel.text = [User getInstance].username;
    //    照片选择器
    self.photoGallery = [[AJPhotoPickerGallery alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, IMAGE_WIDTH_WITH_PADDING)];
    self.photoGallery.vc = self;
    self.photoGallery.maxCount = 3;
    [self.pictureView addSubview:self.photoGallery];
    // Do any additional setup after loading the view.
}

///认证投资人规范
- (IBAction)standardButtonPress:(id)sender {
    StandardViewController *vc = [[UIStoryboard storyboardWithName:@"Activity" bundle:nil] instantiateViewControllerWithIdentifier:@"standard"];
    vc.type = @"1";
    vc.naviTitle = @"认证投资人规范";
    [self.navigationController pushViewController:vc animated:YES];
}


///选择了投资领域的回调
- (void)didSelectedTags:(NSMutableArray *)selectedCodeArray selectedNames:(NSMutableArray *)selectedNameArray {
    
    [self.bizButton setTitle:[selectedNameArray componentsJoinedByString:@","] forState:(UIControlStateNormal)];
    self.selectedCodeArray = selectedCodeArray;
    self.selectedNameArray = selectedNameArray;
}



//投资领域
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"biz"]) {
        BizViewController *vc = segue.destinationViewController;
        vc.selectedCodeArray = self.selectedCodeArray;
        vc.selectedNameArray = self.selectedNameArray;
        vc.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"process"]) {
        ProcessViewController *vc = segue.destinationViewController;
        vc.selectedCodeArray = self.processCodeArray;
        vc.selectedNameArray = self.processNameArray;
        vc.delegate = self;
    }
}


///选择了投资阶段的回调
- (void)didSelectedProcess:(NSMutableArray *)selectedCodeArray selectedNames:(NSMutableArray *)selectedNameArray {
    [self.processButton setTitle:[selectedNameArray componentsJoinedByString:@","] forState:(UIControlStateNormal)];
    self.processCodeArray = selectedCodeArray;
    self.processNameArray = selectedNameArray;
}




///提交按钮点击
- (IBAction)submitButtonPress:(id)sender {
    if (![VerifyUtil isValidStringLengthRange:self.investInstitutionTextField.text between:3 and:200]) {
        [SVProgressHUD showErrorWithStatus:@"请输入投资机构(3-200字)"];
        return;
    }
    
    if (![VerifyUtil hasValue:self.investUrlTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入投资机构网址"];
        return;
    }
    
    if (![VerifyUtil isValidStringLengthRange:self.investIdeaTextView.text between:3 and:200]) {
        [SVProgressHUD showErrorWithStatus:@"请输入投资理念(3-200字)"];
        return;
    }
    
    if (![VerifyUtil isValidStringLengthRange:self.investCaseTextView.text between:3 and:500]) {
        [SVProgressHUD showErrorWithStatus:@"请输入投资案例(3-500字)"];
        return;
    }
    
    //    多图
    if (self.photoGallery.photos.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请上传名片"];
        return ;
    }
    
    NSDictionary *param = @{
                            @"InvestorInfo":[StringUtil dictToJson:@{
                                                                     @"investInstitution":self.investInstitutionTextField.text,
                                                                     @"investIdea":self.investIdeaTextView.text,
                                                                     @"investProjects":self.investCaseTextView.text,
                                                                     @"investUrl":self.investUrlTextField.text,
                                                                     @"investProcess":self.processButton.currentTitle,
                                                                     @"investArea":self.bizButton.currentTitle,
                                                                     @"bizStatus":@0,
                                                                     @"cardPictUrl":[[ImageUtil getInstance] savePicture:@"cardPictUrl" images:self.photoGallery.photos] ,
                                                                     @"userId":[User getInstance].uid
                                                                     }]
                            };
    

    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",HOST_URL,@"personal/info/setInvestorInfo"];
    [manager POST:urlstr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
        //        多图
        if (self.photoGallery.photos.count > 0) {
            for (int i = 0; i < self.photoGallery.photos.count; i++) {
                UIImage *image = self.photoGallery.photos[i];
                [formData appendPartWithFileData:UIImageJPEGRepresentation(image,0.8) name:[NSString stringWithFormat:@"%zi",i] fileName:[ImageUtil getInstance].filenames[i] mimeType:@"image/jpeg"];
            }
        }
        //            NSLog(@"urlstr:%@ param:%@",urlstr,param);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        //            NSLog(@"responseObject:%@",responseObject);
        if ([responseObject[@"success"] boolValue]) {
            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
            [self goBack];
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [[[UIAlertView alloc]initWithTitle:@"提交失败" message:@"网络故障，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return the number of sections.
    if (indexPath.row == 9) {
        NSInteger imageCount = self.photoGallery.photos.count;
        CGFloat imageWidth = (SCREEN_WIDTH - 32) / 4.0 - 4;
        CGFloat height = ((imageCount / 4) + 1) * imageWidth + 60;
        return height;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
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

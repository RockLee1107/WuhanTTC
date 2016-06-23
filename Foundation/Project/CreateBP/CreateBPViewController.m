//
//  CreateBPViewController.m
//  Foundation
//
//  Created by hyfy002 on 16/5/23.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "CreateBPViewController.h"
#import "StatusDict.h"
#import "ActionSheetStringPicker.h"
#import "BizViewController.h"
#import "LXButton.h"
#import "CityViewController.h"

@interface CreateBPViewController ()<LXPhotoPickerDelegate,BizViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,CityViewControllerDelegete,UITextFieldDelegate>
{
    UILabel *_slideLabel;
    NSArray *_photoArray;
    NSString *_status;
}

@property (strong, nonatomic) IBOutlet UIButton *createBPBtn;//创建BP按钮

@property (weak, nonatomic) IBOutlet UITextField *bPNameTextField;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet LXButton *cityButton;
@property (nonatomic, copy) NSString *cityTitle;

@property (nonatomic, copy) NSString *logoFilePath;//logo的路径
@property (nonatomic, copy) NSString *bPFilePath;//项目BP图片的路径
@property (nonatomic, strong) NSArray *allPhotoFilePathArray;
@property (nonatomic, strong) NSArray *savePhotoFilePathArray;//选择控件修改后新添加的图片路径
@property (nonatomic, copy) NSString *originalBpFilePath;
@property (nonatomic, copy) NSString *financeProcCode;
@property (nonatomic, copy) NSString *bizCode;
@property (nonatomic, copy) NSString *bizName;
@property (nonatomic, copy) NSString *bpVisible;

@end

@implementation CreateBPViewController

- (void)viewWillAppear:(BOOL)animated {
    self.tabBarController.tabBar.hidden = YES;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createUI];
    //根据进入的标题判断是否更新BP
    if ([self.title isEqualToString:@"更新BP"]) {
        [self upDateBP];
    }
}

- (void)upDateBP {
    
    NSDictionary *dict = @{
                           @"bpId":[User getInstance].bpId
                           };
    [self.service POST:@"bp/getBpDetailDto" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {

        self.originalBpFilePath = [NSString stringWithFormat:@"%@", responseObject[@"bpLogo"]];
        //    标题
        self.bPNameTextField.text = [StringUtil toString:responseObject[@"bpName"]];
        
        //     Logo
        [self.logoImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", UPLOAD_URL, responseObject[@"bpLogo"]]]];
        
        //多图
        //    照片选择器
        NSArray *photoArray = [[StringUtil toString:responseObject[@"bpPictUrl"]] componentsSeparatedByString:@","];
        self.photoGallery = [[AJPhotoPickerGallery alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, IMAGE_WIDTH_WITH_PADDING) imageUrlArray: photoArray];
        self.photoGallery.vc = self;
        self.photoGallery.maxCount = 9;
        [self.cellContentView addSubview:self.photoGallery];
        
        
        if ([[responseObject[@"bpVisible"] stringValue] isEqualToString:@"0"]) {
            _slideLabel.frame = CGRectMake(CGRectGetMaxX(self.allVisibleBtn.frame)-10.5, CGRectGetMaxY(self.allVisibleBtn.frame)-10.5, 7, 7);
        }else {
            _slideLabel.frame = CGRectMake(CGRectGetMaxX(self.onlyInvestorsBtn.frame)-10.5, CGRectGetMaxY(self.onlyInvestorsBtn.frame)-10.5, 7, 7);
        }
        //城市
        self.cityTitle = responseObject[@"area"];
        [self.cityButton setTitle:responseObject[@"area"] forState:UIControlStateNormal];
        //融资阶段
        [self.financeButton setTitle:responseObject[@"financeProcName"] forState:UIControlStateNormal];
        //项目领域
        [self.bizButton setTitle:responseObject[@"bizName"] forState:UIControlStateNormal];
        //BP描述
        self.descTextView.text = responseObject[@"bpDesc"];
        //
        self.financeProcCode = responseObject[@"financeProcCode"];
        //
        self.bizCode = responseObject[@"bizCode"];
        //
        self.bizName = responseObject[@"bizName"];
        //
        self.bpVisible = responseObject[@"bpVisible"];
        
    } noResult:nil];
        
    [self.createBPBtn setTitle:@"提交" forState:UIControlStateNormal];
}

- (void)createUI {
    
    //默认全部可见
    _status = @"0";
    //城市
    self.cityTitle = @"武汉";
    [self.cityButton setTitle:@"武汉" forState:UIControlStateNormal];
    
    //Logo选择图片
    self.logoImageView.userInteractionEnabled = YES;
    self.logoImageView.tag = 888;
    UITapGestureRecognizer *taper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    taper.numberOfTapsRequired    = 1;
    taper.numberOfTouchesRequired = 1;
    [self.logoImageView addGestureRecognizer:taper];
    
    //    照片拾取
    self.picker = [[LXPhotoPicker alloc] initWithParentView:self];
    self.picker.delegate = self;
    self.picker.filename = [NSString stringWithFormat:@"avatar_%d.jpg",(int)([[NSDate date] timeIntervalSince1970])];
    
    //全部可见
    self.allVisibleBtn.layer.cornerRadius = 7.5;
    self.allVisibleBtn.layer.masksToBounds = YES;
    self.allVisibleBtn.layer.borderWidth = 2;
    self.allVisibleBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    //滑动圆点
    _slideLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.allVisibleBtn.frame)-10.5, CGRectGetMaxY(self.allVisibleBtn.frame)-10.5, 7, 7)];
    _slideLabel.layer.cornerRadius = 3.5;
    _slideLabel.layer.masksToBounds = YES;
    _slideLabel.backgroundColor = [UIColor blackColor];
    [self.rightView addSubview:_slideLabel];
    
    //仅限投资人
    self.onlyInvestorsBtn.layer.cornerRadius = 7.5;
    self.onlyInvestorsBtn.layer.masksToBounds = YES;
    self.onlyInvestorsBtn.layer.borderWidth = 2;
    self.onlyInvestorsBtn.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    //    照片选择器
    self.photoGallery = [[AJPhotoPickerGallery alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, IMAGE_WIDTH_WITH_PADDING)];
    self.photoGallery.vc = self;
    self.photoGallery.maxCount = 20;
    [self.cellContentView addSubview:self.photoGallery];
}

///选择了城市之后的回调
- (void)cityViewdidSelectCity:(NSString *)city anamation:(BOOL)anamation {
    [self.cityButton setTitle:city forState:(UIControlStateNormal)];
    self.cityTitle = city;
}

- (IBAction)switchCityBtnClick:(id)sender {
    CityViewController *vc = [[CityViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.delegete = self;
}

//点击上传Logo BP 图片
- (void)tap:(UITapGestureRecognizer *)tt {
    //Logo
    if (tt.view.tag == 888) {
        [self.currentTextField resignFirstResponder];
        [self.picker selectPicture];
    }
}

//点击全部可见
- (IBAction)allVisibleBtnClick:(id)sender {
    [UIView animateWithDuration:0 animations:^{
        _slideLabel.frame = CGRectMake(CGRectGetMaxX(self.allVisibleBtn.frame)-10.5, CGRectGetMaxY(self.allVisibleBtn.frame)-10.5, 7, 7);
        _status = @"0";
    }];
}

//仅限投资人
- (IBAction)onlyInvestorsBtnClick:(id)sender {
    [UIView animateWithDuration:0 animations:^{
        _slideLabel.frame = CGRectMake(CGRectGetMaxX(self.onlyInvestorsBtn.frame)-10.5, CGRectGetMaxY(self.onlyInvestorsBtn.frame)-10.5, 7, 7);
        _status = @"1";
    }];
}

//点击融资阶段
- (IBAction)selectFinaceBtnClick:(id)sender {
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

#pragma mark - BizViewControllerDelegate
///选择了项目领域的回调
- (void)didSelectedTags:(NSMutableArray *)selectedCodeArray selectedNames:(NSMutableArray *)selectedNameArray {
    [self.bizButton setTitle:[selectedNameArray componentsJoinedByString:@","] forState:(UIControlStateNormal)];
    self.selectedCodeArray = selectedCodeArray;
    self.selectedNameArray = selectedNameArray;
}

//点击项目领域
- (IBAction)bizButtonClick:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Project" bundle:nil];
    BizViewController *bizVC = [storyBoard instantiateViewControllerWithIdentifier:@"bizVC"];
    bizVC.selectedCodeArray = self.selectedCodeArray;
    bizVC.selectedNameArray = self.selectedNameArray;
    bizVC.delegate = self;
    [self.navigationController pushViewController:bizVC animated:YES];
}

//提交
- (IBAction)createBPBtnClick:(id)sender {
    
    //创建BP
    if ([self.title isEqualToString:@"创建BP"]) {
        //        标题
        if (![VerifyUtil isValidStringLengthRange:self.bPNameTextField.text between:1 and:26]) {
            [SVProgressHUD showErrorWithStatus:@"请输入活动名称(1-26字)"];
            return ;
        }
        //        主图
        if (self.picker.imageOriginal == nil) {
            [SVProgressHUD showErrorWithStatus:@"请上传活动图片"];
            return ;
        }
        //        可见权限
        if (_status == nil) {
            [SVProgressHUD showErrorWithStatus:@"请设置可见权限"];
            return ;
        }
        //        所在城市
        if ([[self.cityButton titleForState:(UIControlStateNormal)] isEqualToString:@"城市"]) {
            [SVProgressHUD showErrorWithStatus:@"请选择所在城市"];
            return;
        }
        //        融资阶段
        if (![VerifyUtil hasValue:self.selectedFinanceValue]) {
            [SVProgressHUD showErrorWithStatus:@"请选择融资阶段"];
            return;
        }
        //        项目领域
        if (self.selectedCodeArray.count == 0) {
            [SVProgressHUD showErrorWithStatus:@"请选择项目领域"];
            return;
        }
        //        BP描述
        if (![VerifyUtil isValidStringLengthRange:self.descTextView.text between:3 and:2000]) {
            [SVProgressHUD showErrorWithStatus:@"请输入BP描述(3-500字)"];
            return ;
        }
        [SVProgressHUD showWithStatus:@"创建中..."];
        //获取系统时间
        self.planDate = [NSDate date];
        
        //    考虑结束日期要大于开始日期
        NSMutableDictionary *businessPlan = [NSMutableDictionary dictionaryWithDictionary:
                                             @{
                                               @"bpName":self.bPNameTextField.text,
                                               @"bpLogo":self.logoFilePath,
                                               @"bpVisible":_status,//可见权限  0:全部 1:仅限投资人
                                               @"financeProcCode":self.selectedFinanceValue,//融资阶段
                                               @"bizCode":[self.selectedCodeArray componentsJoinedByString:@","],//项目领域
                                               @"bizName":[self.selectedNameArray componentsJoinedByString:@","],
                                               @"bpDesc":self.descTextView.text,//BP描述
                                               @"createdDate":[DateUtil dateToDatePart:self.planDate],//日期需要转化20151123格式  记录创建时间当前年月日
                                               @"createdTime":[DateUtil dateToSecondPart:self.planDate],//Time convert to 2315 Style  当前时分秒
                                               @"bizStatus":@"1",//bizStatus区分保存与提交 保存是0 发布是1
                                               @"area":self.cityTitle
                                               }
                                             ];
        //    多图
        if (self.photoGallery.photos.count > 0) {
            //不能使用图片单例ImageUtil
            ImageUtil *activityImageUtil = [[ImageUtil alloc] init];
            
            NSString *filePath = [self.photoGallery fetchPhoto:@"bpPictUrl" imageUtil:activityImageUtil];
            
            if (filePath) {
                [businessPlan setObject:filePath forKey:@"bpPictUrl"];
                self.allPhotoFilePathArray = [filePath componentsSeparatedByString:@","];
            }else {
                [businessPlan setObject:@"" forKey:@"bpPictUrl"];
            }
            
        }
        
        //活动的单张图片路径
        if (self.picker.filePath) {
            [businessPlan setObject:self.picker.filePath forKey:@"pictURL"];
        } else {
            [businessPlan setObject:@"" forKey:@"pictURL"];
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *param = @{
                                @"BusinessPlan":[StringUtil dictToJson:businessPlan],
                                @"SrcStatus":@"0"
                                };
        
        NSString *urlstr = [NSString stringWithFormat:@"%@/%@",HOST_URL,@"bp/saveBp"];
        urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager POST:urlstr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            //        logo
            if (self.picker.filePath) {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(self.picker.imageOriginal,0.8) name:@"bpLogo" fileName:self.picker.filename mimeType:@"image/jpeg"];
            }
            //        多图
            if (self.photoGallery.photosArrival.count > 0) {
                for (int i = 0; i < self.photoGallery.photosArrival.count; i++) {
                    UIImage *image = self.photoGallery.photosArrival[i];
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(image,0.8) name:[NSString stringWithFormat:@"BPPictUrl%d",i] fileName:self.allPhotoFilePathArray[i] mimeType:@"image/jpeg"];
                }
            }
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            
            //
            self.createBPBtn.userInteractionEnabled = NO;
            
            if ([responseObject[@"success"] boolValue]) {
                [SVProgressHUD dismiss];
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
    //提交->更新BP
    else {
        
        //获取系统时间
        self.planDate = [NSDate date];
        
        //    考虑结束日期要大于开始日期
        NSMutableDictionary *businessPlan = [NSMutableDictionary dictionaryWithDictionary:
                                             @{
                                               @"bpName":self.bPNameTextField.text,
                                               @"bpVisible":_status ? _status : self.bpVisible,//可见权限  0:全部 1:仅限投资人
                                               @"financeProcCode":self.selectedFinanceValue ? self.selectedFinanceValue : self.financeProcCode,//融资阶段
                                               @"bizCode":[self.selectedCodeArray componentsJoinedByString:@","] ? [self.selectedCodeArray componentsJoinedByString:@","] : self.bizCode,//项目领域
                                               @"bizName":[self.selectedNameArray componentsJoinedByString:@","] ? [self.selectedNameArray componentsJoinedByString:@","] : self.bizName,
                                               @"bpDesc":self.descTextView.text,//BP描述
                                               @"createdDate":[DateUtil dateToDatePart:self.planDate],//日期需要转化20151123格式  记录创建时间当前年月日
                                               @"createdTime":[DateUtil dateToSecondPart:self.planDate],//Time convert to 2315 Style  当前时分秒
                                               @"bizStatus":@"1",//bizStatus区分保存与提交 保存是0 发布是1
                                               @"area":self.cityTitle,
                                               @"id":[User getInstance].bpId
                                               }
                                             ];
        
        //    多图
        //不能使用图片单例ImageUtil
        ImageUtil *activityImageUtil = [[ImageUtil alloc] init];
        
        //用一个数组接收回调过来的所有图片路径
        self.allPhotoFilePathArray = [[self.photoGallery fetchPhoto:@"bpPictUrl" imageUtil:activityImageUtil] componentsSeparatedByString:@","];
        
        //接收修改图片后新添加的图片路径
        self.savePhotoFilePathArray = [self.photoGallery.savePath componentsSeparatedByString:@","];
        
        //如果只有老图，只上传老图
        if ([self.photoGallery.photosStrArray count] && [self.savePhotoFilePathArray count] == 0) {
            [businessPlan setObject:[self.photoGallery.photosStrArray componentsJoinedByString:@","] forKey:@"bpPictUrl"];
        }//如果删了老图，只有新图
        else if ([self.savePhotoFilePathArray count] && [self.photoGallery.photosStrArray count] == 0) {
            [businessPlan setObject:[self.savePhotoFilePathArray componentsJoinedByString:@","] forKey:@"bpPictUrl"];
        }//如果既有老图，又有新图
        else if ([self.photoGallery.photosStrArray count] && [self.savePhotoFilePathArray count]) {
            [businessPlan setObject:[self.allPhotoFilePathArray componentsJoinedByString:@","] forKey:@"bpPictUrl"];
        }
        
        //活动的单张图片路径
        if (self.picker.filePath) {
            [businessPlan setObject:self.picker.filePath forKey:@"pictURL"];
        } else {
            [businessPlan setObject:self.originalBpFilePath forKey:@"pictURL"];
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *param = @{
                                @"BusinessPlan":[StringUtil dictToJson:businessPlan],
                                @"SrcStatus":@"0"
                                };
        
        NSString *urlstr = [NSString stringWithFormat:@"%@/%@",HOST_URL,@"bp/saveBp"];
        urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [SVProgressHUD showWithStatus:@"更新中..."];
        
        [manager POST:urlstr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            //        logo
            if (self.picker.filePath) {
                [formData appendPartWithFileData:UIImageJPEGRepresentation(self.picker.imageOriginal,0.8) name:@"bpLogo" fileName:self.picker.filename mimeType:@"image/jpeg"];
            }
            //        多图
            if (self.photoGallery.photos.count > 0) {
                for (int i = 0; i < self.photoGallery.photos.count; i++) {
                    UIImage *image = self.photoGallery.photos[i];
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(image,0.8) name:[NSString stringWithFormat:@"BPPictUrl%d",i] fileName:self.allPhotoFilePathArray[i] mimeType:@"image/jpeg"];
                }
            }
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            
            if ([responseObject[@"success"] boolValue]) {
                [SVProgressHUD dismiss];
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
}

#pragma mark - LXPhotoPickerDelegate
// Logo图片选取后回调
- (void)didSelectPhoto:(UIImage *)image {
    self.logoImageView.image = image;
}
- (void)sendImageFilePath:(NSString *)filePath {
    self.logoFilePath = filePath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//主要针对图片选择的回调
-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 7) {
    
        NSLog(@"%ld", (unsigned long)[_photoArray count]);
        //        详情图片
//        if ([_photoArray count]) {
//            CGFloat height = IMAGE_WIDTH_WITH_PADDING * ceil([_photoArray count] / 4.0);
//            NSLog(@"\n height : %f", height);
//            return 40 + height;
            
            NSInteger imageCount = self.photoGallery.photos.count;
            CGFloat imageWidth = (SCREEN_WIDTH - 32) / 4.0 - 4;
            CGFloat height = ((imageCount / 4) + 1) * imageWidth + 60;
            return height;
        
//        }
    }
    
//    //详情图片
//    if (indexPath.row == 7) {
//        NSInteger imageCount = self.photoGallery.photos.count;
//        CGFloat imageWidth = (SCREEN_WIDTH - 32) / 4.0 - 4;
//        CGFloat height = ((imageCount / 4) + 1) * imageWidth + 60;
//        return height;
//    }

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


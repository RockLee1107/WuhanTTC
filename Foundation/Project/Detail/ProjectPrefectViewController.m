//
//  ProjectDetailViewController.m
//  
//
//  Created by HuangXiuJie on 16/3/21.
//
//

#import "ProjectPrefectViewController.h"
#import "ProjectCreateTableViewController.h"
#import "TeamListTableViewController.h"
#import "ProcessTableViewController.h"
#import "FinanceTableViewController.h"
#import "ProductTableViewController.h"
#import "SingletonObject.h"
#import "DTKDropdownMenuView.h"
#import "HttpService.h"
#import "Global.h"
#import "LXButton.h"
#import "Masonry.h"
#import "ImageUtil.h"

@interface ProjectPrefectViewController ()
@end

@implementation ProjectPrefectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *containerView = [[UIView alloc] init];
//    包裹按钮的白底背景图层
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    [containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(60.0);
    }];
//    提交按钮
    LXButton *publishButton = [LXButton buttonWithType:(UIButtonTypeSystem)];
    [publishButton setTitle:@"发布项目" forState:(UIControlStateNormal)];
//    绑定点击事件
    [publishButton addTarget:self action:@selector(publishButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
    [containerView addSubview:publishButton];
    [publishButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(containerView.mas_centerY);
        make.left.equalTo(containerView.mas_left).offset(20);
        make.right.equalTo(containerView.mas_right).offset(-20);
        make.height.mas_equalTo(40.0);
    }];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSArray *viewControllerClasses = @[
                                           [ProjectCreateTableViewController class],
                                           [TeamListTableViewController class],
                                           [ProductTableViewController class],
                                           [ProcessTableViewController class],
                                           [FinanceTableViewController class]
                                           ];
        NSArray *titles = @[
                            @"详情",
                            @"团队",
                            @"产品",
                            @"进展",
                            @"融资"
                            ];
        self.viewControllerClasses = viewControllerClasses;
        self.titles = titles;
        self.menuItemWidth = SCREEN_WIDTH / titles.count;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.titleSizeSelected = 15.0;
        self.titleColorSelected = MAIN_COLOR;
        //为不同页面设置相对应的标签，每一个key对应一个values
        self.keys = @[
                      @"pid",
                      @"pid",
                      @"pid",
                      @"pid",
                      @"pid"
                      ];
        self.values = @[
                        [SingletonObject getInstance].pid,
                        [SingletonObject getInstance].pid,
                        [SingletonObject getInstance].pid,
                        [SingletonObject getInstance].pid,
                        [SingletonObject getInstance].pid
                        ];
    }
    return self;
}

- (IBAction)save:(UIBarButtonItem *)sender {
    
}

- (void)publishButtonPress:(UIButton *)sender {
    ProjectCreateTableViewController *projectVC = self.childViewControllers[0];
    ProductTableViewController *productVC = nil;
    TeamListTableViewController *teamVC = nil;
    ProcessTableViewController *processVC = nil;
    FinanceTableViewController *financeVC = nil;
//    设置vc
    for(int i = 0; i < self.childViewControllers.count; i++) {
        if ([self.childViewControllers[i] isKindOfClass:[ProductTableViewController class]]) {
            productVC = self.childViewControllers[i];
        } else if ([self.childViewControllers[i] isKindOfClass:[TeamListTableViewController class]]){
            teamVC = self.childViewControllers[i];
        } else if ([self.childViewControllers[i] isKindOfClass:[ProcessTableViewController class]]){
            processVC = self.childViewControllers[i];
        } else if ([self.childViewControllers[i] isKindOfClass:[FinanceTableViewController class]]){
            financeVC = self.childViewControllers[i];
        }
    }

/*项目信息*/
    if (![VerifyUtil hasValue:projectVC.projectNameTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请填写项目名称"];
        return;
    }
    if (projectVC.picker.imageOriginal == nil) {
        [SVProgressHUD showErrorWithStatus:@"请上传项目Logo"];
        return;
    }
    if (![VerifyUtil isValidStringLengthRange:projectVC.projectResumeTextView.text between:3 and:50]) {
        [SVProgressHUD showErrorWithStatus:@"项目简介字数为3～50"];
        return;
    }
    if ([[projectVC.currentCityButton titleForState:(UIControlStateNormal)] isEqualToString:@"城市"]) {
        [SVProgressHUD showErrorWithStatus:@"请选择所在城市"];
        return;
    }
    if (![VerifyUtil hasValue:projectVC.selectedStatusValue]) {
        [SVProgressHUD showErrorWithStatus:@"请选择项目阶段"];
        return;
    }
    if (![VerifyUtil hasValue:projectVC.selectedFinanceValue]) {
        [SVProgressHUD showErrorWithStatus:@"请选择融资阶段"];
        return;
    }
    if (projectVC.selectedCodeArray.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"请选择项目领域"];
        return;
    }
    if (![VerifyUtil isValidStringLengthRange:projectVC.descTextView.text between:3 and:500]) {
        [SVProgressHUD showErrorWithStatus:@"项目描述字数为3～500"];
        return;
    }
    
    NSMutableDictionary *project = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                            @"projectId":[SingletonObject getInstance].pid,
                                                                            @"projectName":projectVC.projectNameTextField.text,
                                                                            @"headPictUrl":projectVC.picker.filePath,
                                                                            @"projectResume":projectVC.projectResumeTextView.text,
                                                                            @"desc":projectVC.descTextView.text,
                                                                            @"procStatusCode":projectVC.selectedStatusValue,
                                                                            @"financeProcCode":projectVC.selectedFinanceValue,
                                                                            @"area":[projectVC.currentCityButton titleForState:(UIControlStateNormal)],
                                                                            @"bizCode":[projectVC.selectedCodeArray componentsJoinedByString:@","]
                                                                            }];
    //不能使用图片单例ImageUtil
    ImageUtil *projectImageUtil = [[ImageUtil alloc] init];
    //    多图
    if (projectVC.photoGallery.photos.count > 0) {
        [project setObject:[projectImageUtil savePicture:@"bpPictUrl" images:projectVC.photoGallery.photos] forKey:@"bpPictUrl"];
    }
    

/*产品信息*/
//    后端api要求，产品信息与项目基本共用Project对象
    if (![productVC.procDetailsTextView.text isEqualToString:@""] && productVC.procDetailsTextView.text != nil) {
        [project setObject:productVC.procDetailsTextView.text forKey:@"procDetails"];
    }
    //不能使用图片单例ImageUtil
    ImageUtil *productImageUtil = [[ImageUtil alloc] init];
//    判断有没有productVC，展示过才有
    if (productVC != nil) {
        //    多图
        if (productVC.photoGallery.photos.count > 0) {
            [project setObject:[productImageUtil savePicture:@"procShows" images:productVC.photoGallery.photos] forKey:@"procShows"];
        }
    }
    //Project为首页，必然存在
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    [param setObject:[StringUtil dictToJson:project] forKey:@"Project"];
//    判断有没有teamVC，展示过才有
    if (teamVC != nil) {
        [param setObject:[StringUtil dictToJson:teamVC.dataArray] forKey:@"Team"];
    }
//    判断有没有processVC，展示过才有
    if (processVC != nil) {
        [param setObject:[StringUtil dictToJson:processVC.dataArray] forKey:@"Process"];
    }
//    判断有没有financeVC，展示过才有
    if (financeVC != nil) {
        [param setObject:[StringUtil dictToJson:financeVC.dataArray] forKey:@"Finance"];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",HOST_URL,@"project/prefectProject"];
    [manager POST:urlstr parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        针对保存草稿时不传递数据
        if (projectVC.picker.filePath) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(projectVC.picker.imageOriginal,0.8) name:@"headPictUrl" fileName:projectVC.picker.filename mimeType:@"image/jpeg"];
        }
//        图片名称加了前缀，不然会冲突覆盖
//        bp
        //        多图
        if (projectVC.photoGallery.photos.count > 0) {
            for (int i = 0; i < projectVC.photoGallery.photos.count; i++) {
                UIImage *image = projectVC.photoGallery.photos[i];
                [formData appendPartWithFileData:UIImageJPEGRepresentation(image,0.8) name:[NSString stringWithFormat:@"bpPictUrl_%zi",i] fileName:projectImageUtil.filenames[i] mimeType:@"image/jpeg"];
            }
        }
//        产品
        //        多图
        if (productVC.photoGallery.photos.count > 0) {
            for (int i = 0; i < productVC.photoGallery.photos.count; i++) {
                UIImage *image = productVC.photoGallery.photos[i];
                [formData appendPartWithFileData:UIImageJPEGRepresentation(image,0.8) name:[NSString stringWithFormat:@"procShows_%zi",i] fileName:productImageUtil.filenames[i] mimeType:@"image/jpeg"];
            }
        }
        //            NSLog(@"urlstr:%@ param:%@",urlstr,param);
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //            NSLog(@"responseObject:%@",responseObject);
        if ([responseObject[@"success"] boolValue]) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [[[UIAlertView alloc]initWithTitle:@"发布失败" message:@"网络故障，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
    
}
@end

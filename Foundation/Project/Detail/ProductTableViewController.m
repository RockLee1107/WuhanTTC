//
//  ProductTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/5/5.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "ProductTableViewController.h"

@interface ProductTableViewController ()
{
    NSArray *_photoArray;
    NSDictionary *_picDict;
}

@property (strong,nonatomic) NSString *pid;
@property (nonatomic, copy) NSString *idStr;
@property (nonatomic, copy) NSArray *photosFilePathArray;
@property (nonatomic, copy) NSString *photosFilePath;

@property (weak, nonatomic) IBOutlet UIView *pictureView;//整个cell的视图




@property (weak, nonatomic) IBOutlet EMTextView *productFunction;//产品功能

@property (nonatomic, strong) NSDate *planDate;
@property (nonatomic, strong) NSArray *allPhotoFilePathArray;//选择控件回调后的所有图片路径
@property (nonatomic, strong) NSArray *savePhotoFilePathArray;//选择控件修改后新添加的图片路径
@property (nonatomic, strong) NSArray *originalFilePathArray;//从服务器请求回的路径
@property (nonatomic, copy) NSString *fileStr;

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation ProductTableViewController

- (instancetype)init {
    self = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"product"];
    return self;
}

//主要针对图片选择的回调
-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self setDynamicLayout];
    
    //根据projectId 判断是否第一次创建  存在则是更新该页面
    if (![self.projectId isEqualToString:@""] && self.projectId != nil && ![self.projectId isKindOfClass:[NSNull class]]) {
        [self loadData];
    }
    
    //修改
    else if (self.hasProduct) {
        [self loadData];
    }
    
}

- (void)loadData {
    
    NSDictionary *dict = @{
                           @"sEQ_projectId":self.projectId,
                           @"sEQ_visible":@"private"
                           };
    NSString *jsonStr = [StringUtil dictToJson:dict];
    NSDictionary *param = @{@"QueryParams":jsonStr};
    
    [self.service POST:@"product/getProduct" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        NSLog(@"%@", responseObject);
        _picDict = responseObject;

        
        //展现请求的已经填过的数据
        self.productFunction.text = responseObject[@"procDetails"];
        //服务器返回一个id
        self.idStr = responseObject[@"id"];
        
        _photoArray = [[StringUtil toString:responseObject[@"procShows"]] componentsSeparatedByString:@","];
        self.photoGallery = [[AJPhotoPickerGallery alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, IMAGE_WIDTH_WITH_PADDING) imageUrlArray: _photoArray];
        self.photoGallery.vc = self;
        self.photoGallery.maxCount = 20;
        [self.pictureView addSubview:self.photoGallery];
        
    } noResult:^{
        NSLog(@"22222222222");
    }];
}

//提交
- (IBAction)commitBtnClick:(id)sender {
    
    //修改后提交
    if (self.idStr) {
        
        //        BP描述
        if (![VerifyUtil isValidStringLengthRange:self.productFunction.text between:3 and:2000]) {
            [SVProgressHUD showErrorWithStatus:@"请输入BP描述(3-500字)"];
            return ;
        }
        
        //获取系统时间
        self.planDate = [NSDate date];
     
        //    考虑结束日期要大于开始日期
        NSMutableDictionary *product = [NSMutableDictionary dictionaryWithDictionary:
                                        @{
                                          @"procDetails":self.productFunction.text,
                                          @"id":self.idStr,
                                          @"status":@"0",//可见权限  0:全部 1:仅限投资人
                                          @"projectId":self.projectId,
                                          @"createdDate":[DateUtil dateToDatePart:self.planDate],//日期需要转化20151123格式  记录创建时间当前年月日
                                          @"createdTime":[DateUtil dateToSecondPart:self.planDate],//Time convert to 2315 Style  当前时分秒
                                          }
                                        ];
        
        //    多图
        //不能使用图片单例ImageUtil
        ImageUtil *activityImageUtil = [[ImageUtil alloc] init];
        
        //用一个数组接收回调过来的所有图片路径
        self.allPhotoFilePathArray = [[self.photoGallery fetchPhoto:@"procShows" imageUtil:activityImageUtil] componentsSeparatedByString:@","];
        
        //接收修改图片后新添加的图片路径
        self.savePhotoFilePathArray = [self.photoGallery.savePath componentsSeparatedByString:@","];
    
        //如果只有老图，只上传老图
        if ([self.photoGallery.photosStrArray count] && [self.savePhotoFilePathArray count] == 0) {
            [product setObject:[self.photoGallery.photosStrArray componentsJoinedByString:@","] forKey:@"procShows"];
        }//如果删了老图，只有新图
        else if ([self.savePhotoFilePathArray count] && [self.photoGallery.photosStrArray count] == 0) {
            [product setObject:[self.savePhotoFilePathArray componentsJoinedByString:@","] forKey:@"procShows"];
        }//如果既有老图，又有新图
        else if ([self.photoGallery.photosStrArray count] && [self.savePhotoFilePathArray count]) {
            [product setObject:[self.allPhotoFilePathArray componentsJoinedByString:@","] forKey:@"procShows"];
        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *param = @{
                                @"Product":[StringUtil dictToJson:product]
                                };
        NSDictionary *param2 = @{@"Product":[param[@"Product"] stringByReplacingOccurrencesOfString:@"\\" withString:@""]};
        
        NSString *urlstr = [NSString stringWithFormat:@"%@/%@",HOST_URL,@"product/saveProduct"];
        urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager POST:urlstr parameters:param2 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [SVProgressHUD showWithStatus:@"更新中..."];
            if (self.photoGallery.photos.count > 0) {
                for (int i = 0; i < self.photoGallery.photos.count; i++) {
                    UIImage *image = self.photoGallery.photos[i];
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(image,0.8) name:[NSString stringWithFormat:@"procShows%d",i] fileName:self.allPhotoFilePathArray[i] mimeType:@"image/jpeg"];
                }
            }
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            
            self.commitBtn.userInteractionEnabled = NO;
            
            if ([responseObject[@"success"] boolValue]) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
            
                [User getInstance].projectId = responseObject[@"data"];
                [self goBack];
            } else {
                [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            [[[UIAlertView alloc]initWithTitle:@"发布失败" message:@"网络故障，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
        
    }
    //创建
    else {
        //        BP描述
        if (![VerifyUtil isValidStringLengthRange:self.productFunction.text between:3 and:2000]) {
            [SVProgressHUD showErrorWithStatus:@"请输入BP描述(3-500字)"];
            return ;
        }
        
        //获取系统时间
        self.planDate = [NSDate date];
        
        //    考虑结束日期要大于开始日期
        NSMutableDictionary *product = [NSMutableDictionary dictionaryWithDictionary:
                                        @{
                                          @"procDetails":self.productFunction.text,
                                          @"status":@"0",//可见权限  0:全部 1:仅限投资人
                                          @"projectId":self.projectId,
                                          @"createdDate":[DateUtil dateToDatePart:self.planDate],//日期需要转化20151123格式  记录创建时间当前年月日
                                          @"createdTime":[DateUtil dateToSecondPart:self.planDate]//Time convert to 2315 Style  当前时分秒
                                          }
                                        ];
        //    多图
        if (self.photoGallery.photos.count > 0) {
            //不能使用图片单例ImageUtil
            ImageUtil *activityImageUtil = [[ImageUtil alloc] init];
            
            NSString *filePath = [self.photoGallery fetchPhoto:@"procShows" imageUtil:activityImageUtil];
            
            if (filePath) {
                [product setObject:filePath forKey:@"procShows"];
                self.allPhotoFilePathArray = [filePath componentsSeparatedByString:@","];
            }else {
                [product setObject:@"" forKey:@"procShows"];
            }

        }
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        NSDictionary *param = @{
                                @"Product":[StringUtil dictToJson:product]
                                };
        NSDictionary *param2 = @{@"Product":[param[@"Product"] stringByReplacingOccurrencesOfString:@"\\" withString:@""]};
        
        NSString *urlstr = [NSString stringWithFormat:@"%@/%@",HOST_URL,@"product/saveProduct"];
        urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager POST:urlstr parameters:param2 constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [SVProgressHUD showWithStatus:@"创建中..."];
            //        多图
            if (self.photoGallery.photosArrival.count > 0) {
                for (int i = 0; i < self.photoGallery.photosArrival.count; i++) {
                    UIImage *image = self.photoGallery.photosArrival[i];
                    [formData appendPartWithFileData:UIImageJPEGRepresentation(image,0.8) name:[NSString stringWithFormat:@"procShows%d",i] fileName:self.allPhotoFilePathArray[i] mimeType:@"image/jpeg"];
                }
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD dismiss];
            
            self.commitBtn.userInteractionEnabled = NO;
            
            if ([responseObject[@"success"] boolValue]) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
            
                //block回调刷新状态
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

- (void)createUI {
    
    self.commitBtn.backgroundColor = MAIN_COLOR;
    [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.photoGallery = [[AJPhotoPickerGallery alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, IMAGE_WIDTH_WITH_PADDING) imageUrlArray: _photoArray];
    self.photoGallery.vc = self;
    self.photoGallery.maxCount = 20;
    [self.pictureView addSubview:self.photoGallery];
    
}


#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Return the number of sections.
    if (indexPath.row == 0) {
        NSInteger imageCount = self.photoGallery.photos.count;
        CGFloat imageWidth = (SCREEN_WIDTH - 32) / 4.0 - 4;
        CGFloat height = ((imageCount / 4) + 1) * imageWidth + 60;
        return height;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}
@end

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

@interface CreateBPViewController ()<LXPhotoPickerDelegate,BizViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UILabel *_slideLabel;
    NSArray *_photoArray;
}

@property (strong, nonatomic) IBOutlet UIButton *createBPBtn;//创建BP按钮

@end

@implementation CreateBPViewController

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.tableView.contentOffset.y == 36.000000) {
        [UIView animateWithDuration:0.4 animations:^{
            self.tableView.contentOffset = CGPointMake(0,0);
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"创建BP";
    [self createUI];
}

- (void)createUI {
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
    
    //项目BP(限20张)
    self.pictureView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired    = 1;
    tap.numberOfTouchesRequired = 1;
    [self.pictureView addGestureRecognizer:tap];
  
}

//选择logo
- (IBAction)chooseLogoBtnClick:(id)sender {
    
    [self.currentTextField resignFirstResponder];
    [self.picker selectPicture];
}

///LXPhoto Delegate
- (void)didSelectPhoto:(UIImage *)image {
    [self.logoBtn setImage:image forState:(UIControlStateNormal)];
}

//点击全部可见
- (IBAction)allVisibleBtnClick:(id)sender {
    [UIView animateWithDuration:0 animations:^{
        _slideLabel.frame = CGRectMake(CGRectGetMaxX(self.allVisibleBtn.frame)-10.5, CGRectGetMaxY(self.allVisibleBtn.frame)-10.5, 7, 7);
    }];
}

//仅限投资人
- (IBAction)onlyInvestorsBtnClick:(id)sender {
    [UIView animateWithDuration:0 animations:^{
        _slideLabel.frame = CGRectMake(CGRectGetMaxX(self.onlyInvestorsBtn.frame)-10.5, CGRectGetMaxY(self.onlyInvestorsBtn.frame)-10.5, 7, 7);
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
///选择了投资领域的回调
- (void)didSelectedTags:(NSMutableArray *)selectedCodeArray selectedNames:(NSMutableArray *)selectedNameArray {
    [self.bizButton setTitle:[selectedNameArray componentsJoinedByString:@","] forState:(UIControlStateNormal)];
    self.selectedCodeArray = selectedCodeArray;
    self.selectedNameArray = selectedNameArray;
}

//点击投资领域
- (IBAction)bizButtonClick:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Project" bundle:nil];
    BizViewController *bizVC = [storyBoard instantiateViewControllerWithIdentifier:@"bizVC"];
    bizVC.selectedCodeArray = self.selectedCodeArray;
    bizVC.selectedNameArray = self.selectedNameArray;
    bizVC.delegate = self;
    [self.navigationController pushViewController:bizVC animated:YES];
}

//选择项目BP图片
- (void)tap:(UITapGestureRecognizer *)tt {
    
    //    照片选择器
    _photoArray = [[StringUtil toString:self.dataDict[@"bppictUrl"]] componentsSeparatedByString:@","];
    self.photoGallery = [[AJPhotoPickerGallery alloc] initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, IMAGE_WIDTH_WITH_PADDING) imageUrlArray: _photoArray];
    self.photoGallery.vc = self;
    self.photoGallery.maxCount = 20;
    [self.cellContentView addSubview:self.photoGallery];
}

//创建BP
- (IBAction)createBPBtnClick:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 6) {
    
        NSLog(@"%ld", (unsigned long)[_photoArray count]);
        //        详情图片
        if ([_photoArray count]) {
            CGFloat height = IMAGE_WIDTH_WITH_PADDING * ceil([_photoArray count] / 4.0);
            
            return 40 + height;
        }
    }
    //    if (indexPath.row == 6) {
    //        return 200;
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


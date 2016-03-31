//
//  SubjectDetailTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "SubjectDetailTableViewController.h"
#import "DTKDropdownMenuView.h"
#import "PostTableViewDelegate.h"

@interface SubjectDetailTableViewController ()
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *realnameLabel;
@property (nonatomic,strong) IBOutlet UILabel *pbDateTimeLabel;
@property (nonatomic,strong) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
/*回复的TableView*/
@property (weak, nonatomic) IBOutlet UITableView *postTableView;
@property (strong, nonatomic) PostTableViewDelegate *postTableViewDelegate;

@end

@implementation SubjectDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightItem];
    [self initDelegate];
//    @"subjectId"
//    读取值
    self.titleLabel.text = self.dict[@"title"];
    self.realnameLabel.text = self.dict[@"realName"];
    self.pbDateTimeLabel.text = [DateUtil toString:self.dict[@"pbDate"] time:self.dict[@"pbTime"]];
    self.contentTextView.attributedText = [[NSAttributedString alloc] initWithString:self.dict[@"content"] attributes:[StringUtil textViewAttribute]];
    [self.contentTextView sizeToFit];
        [self.thumbImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:self.dict[@"pictUrl"]]]]];
    [self.tableView reloadData];
    //回复内容
//    self.postTableView.scrollEnabled = NO;
    [self fetchData];
}

///初始化代理
- (void)initDelegate {
    self.postTableViewDelegate = [[PostTableViewDelegate alloc] init];
    self.postTableViewDelegate.vc = self;
    self.postTableView.delegate = self.postTableViewDelegate;
    self.postTableView.dataSource = self.postTableViewDelegate;
}


///访问网络
- (void)fetchData {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:
                                 @{
                                   @"SEQ_subjectId":self.dict[@"subjectId"]
                                   }];
    NSString *jsonStr = [StringUtil dictToJson:dict];
    
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service POST:@"/book/postSubject/getSubjectDetail" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.postTableViewDelegate.dataArray = responseObject[@"postReplyDto"];
        [self.postTableView reloadData];
        [self.tableView reloadData];
    } noResult:nil];
}
///导航栏下拉菜单
- (void)addRightItem
{
    //    __weak typeof(self) weakSelf = self;
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"举报" iconName:@"menu_report" callBack:^(NSUInteger index, id info) {
        [SVProgressHUD showSuccessWithStatus:@"^_^"];
    }];
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"只看楼主" iconName:@"menu_auther" callBack:^(NSUInteger index, id info) {
        [SVProgressHUD showSuccessWithStatus:@"^_^"];
    }];
    DTKDropdownItem *item2 = [DTKDropdownItem itemWithTitle:@"回复" iconName:@"menu_reply" callBack:^(NSUInteger index, id info) {
        [SVProgressHUD showSuccessWithStatus:@"^_^"];
    }];
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 60.f, 44.f) dropdownItems:@[item0,item1,item2] icon:@"ic_menu"];
    menuView.cellColor = MAIN_COLOR;
    menuView.cellHeight = 50.0;
    menuView.dropWidth = 150.f;
    menuView.titleFont = [UIFont systemFontOfSize:18.f];
    menuView.textColor = [UIColor whiteColor];
    menuView.cellSeparatorColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    menuView.textFont = [UIFont systemFontOfSize:16.f];
    menuView.animationDuration = 0.4f;
    menuView.backgroundAlpha = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuView];
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
//        主帖
        return self.contentTextView.frame.size.height + 130.0;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
//        总高度汇总
        NSLog(@"%.2f",self.sumPostHeight);
//        if (self.sumPostHeight != 0) {
//            return self.sumPostHeight;
//        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

//估算高度
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0 && indexPath.row == 1) {
//        //        总高度汇总
//        return self.sumPostHeight;
//    }
//    return SCREEN_HEIGHT - 160.0;
//}

@end

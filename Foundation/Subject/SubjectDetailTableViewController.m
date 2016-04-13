//
//  SubjectDetailTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "SubjectDetailTableViewController.h"
#import "DTKDropdownMenuView.h"
#import "PostTableViewCell.h"
#import "SubjectDetailTableViewCell.h"
#import "EYPopupViewHeader.h"

@interface SubjectDetailTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation SubjectDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightItem];
    [self.tableView registerNib:[UINib nibWithNibName:@"PostTableViewCell" bundle:nil] forCellReuseIdentifier:@"post"];
    [self fetchData];
    [self setDynamicLayout];
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
        self.dataArray = responseObject[@"postReplyDto"];
        [self.tableView reloadData];
    } noResult:nil];
}

///导航栏下拉菜单
- (void)addRightItem
{
    //    __weak typeof(self) weakSelf = self;
    DTKDropdownItem *item0 = [DTKDropdownItem itemWithTitle:@"举报" iconName:@"menu_report" callBack:^(NSUInteger index, id info) {
        [EYInputPopupView popViewWithTitle:@"举报帖子" contentText:@"请填写举报内容(1-200字)"
                                      type:EYInputPopupView_Type_multi_line
                               cancelBlock:^{
                                   
                               } confirmBlock:^(UIView *view, NSString *text) {
                                   if (![VerifyUtil isValidStringLengthRange:text between:1 and:200]) {
                                       [SVProgressHUD showErrorWithStatus:@"请举报回复内容(1-200字)"];
                                       return ;
                                   }
                                   NSDictionary *param = @{
                                                           @"PostReport":[StringUtil dictToJson:@{
                                                                                                 @"subjectId":self.dict[@"subjectId"],
                                                                                                 @"userId":[User getInstance].uid,
                                                                                                 @"remark":text,
                                                                                                 }]
                                                           };
                                   [self.service POST:@"book/postSubject/reportSubject" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [SVProgressHUD showSuccessWithStatus:@"举报成功"];
                                   } noResult:nil];
                               } dismissBlock:^{
                                   
                               }];
    }];
    DTKDropdownItem *item1 = [DTKDropdownItem itemWithTitle:@"只看楼主" iconName:@"menu_auther" callBack:^(NSUInteger index, id info) {
        [SVProgressHUD showSuccessWithStatus:@"^_^"];
    }];
    DTKDropdownItem *item2 = [DTKDropdownItem itemWithTitle:@"回复" iconName:@"menu_reply" callBack:^(NSUInteger index, id info) {
        [EYInputPopupView popViewWithTitle:@"回复帖子" contentText:@"请填写回复内容(1-200字)"
                                      type:EYInputPopupView_Type_multi_line
                               cancelBlock:^{
                                   
                               } confirmBlock:^(UIView *view, NSString *text) {
                                   if (![VerifyUtil isValidStringLengthRange:text between:1 and:200]) {
                                       [SVProgressHUD showErrorWithStatus:@"请填写回复内容(1-200字)"];
                                       return ;
                                   }
                                   NSDictionary *param = @{
                                                           @"PostReply":[StringUtil dictToJson:@{
                                                                                                 @"subjectId":self.dict[@"subjectId"],
                                                                                                 @"userId":[User getInstance].uid,
                                                                                                 @"content":text,
                                                                                                 }]
                                                           };
                                   [self.service POST:@"book/postReply/reply" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       [SVProgressHUD showSuccessWithStatus:@"回复成功"];
                                       [self fetchData];
                                   } noResult:nil];
                               } dismissBlock:^{
                                   
                               }];
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

#pragma mark - tb代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.dataArray.count;
    }
    return 1;
}

//单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        PostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"post"];
        NSDictionary *object = self.dataArray[indexPath.row];
        /**图片*/
        [cell.thumbImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:object[@"pictUrl"]]]]];
        cell.thumbImageView.clipsToBounds = YES;
        cell.thumbImageView.layer.cornerRadius = 10.0;
        /**作者*/
        cell.realnameLabel.text = object[@"realName"] == [NSNull null] ? @"匿名用户" : object[@"realName"];
        /**发布时间*/
        cell.pbDateTimeLabel.text = [DateUtil toShortDate:object[@"pbDate"] time:object[@"pbTime"]];
        /**回复数*/
        cell.praiseCountLabel.text = object[@"praiseCount"];
        cell.contentLabel.text = object[@"content"];
        return cell;
    }
    SubjectDetailTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SubjectDetailTableViewCell" owner:nil options:nil] firstObject];
    //    读取值
    cell.titleLabel.text = self.dict[@"title"];
    cell.realnameLabel.text = self.dict[@"realName"];
    cell.pbDateTimeLabel.text = [DateUtil toString:self.dict[@"pbDate"] time:self.dict[@"pbTime"]];
    cell.contentTextView.attributedText = [[NSAttributedString alloc] initWithString:self.dict[@"content"] attributes:[StringUtil textViewAttribute]];
    [cell.thumbImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:self.dict[@"pictUrl"]]]]];
    return cell;
    
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //        主帖
        NSDictionary *attribute = [StringUtil textViewAttribute];
        CGRect frame = [self.dict[@"content"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, FLT_MAX) options:((NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)) attributes:attribute context:nil];
        return frame.size.height + 140;
    } else if (indexPath.section == 1) {
//        回复
        NSDictionary *object = self.dataArray[indexPath.row];
        NSString *content = object[@"content"];
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGRect frame = [content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, FLT_MAX) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:attribute context:nil];
        return frame.size.height + 60.0;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end

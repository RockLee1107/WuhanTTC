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
#define AUTHOR_POST @"只看楼主"
#define ALL_POST @"全部回复"

@interface SubjectDetailTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign) BOOL flag;
@property (nonatomic,strong) DTKDropdownMenuView *menuView;
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
    [SVProgressHUD showWithStatus:@"正在加载"];
    if (self.flag) {
        //服务器有时竟然userId返回null
        if (self.dataDict[@"userId"] != [NSNull null]) {
            [dict setObject:self.dataDict[@"userId"] forKey:@"SEQ_userId"];
        }
    } else {
        [dict removeObjectForKey:@"SEQ_userId"];
    }
    NSString *jsonStr = [StringUtil dictToJson:dict];
    
    NSDictionary *param = @{@"QueryParams":jsonStr,@"Page":[StringUtil dictToJson:[self.page dictionary]]};
    [self.service POST:@"/book/postSubject/getSubjectDetail" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD dismiss];
        self.dataDict = responseObject;
        self.dataArray = responseObject[@"postReplyDto"];
        [self.tableView reloadData];
    } noResult:nil];
}

///切换楼主或全部回复
- (void)switchAuthorOrAllPost {
    //self.flag作为我的评论与全部评论的标识
    DTKDropdownItem *postItem = [self.menuView.items objectAtIndex:1];
    postItem.title = self.flag ? AUTHOR_POST : ALL_POST;
    self.flag = !self.flag;
    //访问网络
    self.page.pageNo = 1;
    [self fetchData];
}

///导航栏下拉菜单
- (void)addRightItem
{
    NSDictionary *param = @{
                            @"subjectId":self.dict[@"subjectId"]
                            };
    //    __weak typeof(self) weakSelf = self;
    DTKDropdownItem *itemBm0 = [DTKDropdownItem itemWithTitle:@"关闭本帖" iconName:@"menu_close_post" callBack:^(NSUInteger index, id info) {
        [self.service POST:@"book/postSubject/closeSubject" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"帖子关闭成功"];
        } noResult:nil];
    }];
    DTKDropdownItem *itemBm1 = [DTKDropdownItem itemWithTitle:@"置顶" iconName:@"menu_top" callBack:^(NSUInteger index, id info) {
        [self.service POST:@"book/postSubject/topSubject" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"帖子置顶成功"];
        } noResult:nil];
    }];
    DTKDropdownItem *itemBm2 = [DTKDropdownItem itemWithTitle:@"加精" iconName:@"menu_essential" callBack:^(NSUInteger index, id info) {
        [self.service POST:@"book/postSubject/essenceSubject" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"帖子加精成功"];
        } noResult:nil];
    }];
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
        [self switchAuthorOrAllPost];
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
    NSMutableArray *array = [NSMutableArray array];
    if ([[User getInstance].isBm boolValue]) {
        [array addObject:itemBm0];
        [array addObject:itemBm1];
        [array addObject:itemBm2];
    }
    [array addObject:item0];
    [array addObject:item1];
    [array addObject:item2];
    DTKDropdownMenuView *menuView = [DTKDropdownMenuView dropdownMenuViewWithType:dropDownTypeRightItem frame:CGRectMake(0, 0, 60.f, 44.f) dropdownItems:array icon:@"ic_menu"];
    menuView.cellColor = MENU_COLOR;
    menuView.cellHeight = 50.0;
    menuView.dropWidth = 150.f;
    menuView.titleFont = [UIFont systemFontOfSize:18.f];
    menuView.textColor = [UIColor blackColor];
    menuView.cellSeparatorColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    menuView.textFont = [UIFont systemFontOfSize:16.f];
    menuView.animationDuration = 0.4f;
    menuView.backgroundAlpha = 0;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuView];
    self.menuView = menuView;
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
//    回复组
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
        /**点赞数*/
        cell.praiseCountLabel.text = object[@"praiseCount"];
        cell.contentLabel.text = object[@"content"];
        //    因为这次没有分组，所以可使用tag传值，不用UIControlStateDisabled更方便
        cell.praiseButton.tag = indexPath.row;
        [cell.praiseButton addTarget:self action:@selector(praiseButtonPress:) forControlEvents:(UIControlEventTouchUpInside)];
        return cell;
    }
//    默认主帖组
    SubjectDetailTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"SubjectDetailTableViewCell" owner:nil options:nil] firstObject];
    //    读取值
    cell.titleLabel.text = [StringUtil toString:self.dict[@"title"]];
    cell.realnameLabel.text = [StringUtil toString:self.dict[@"realName"]];
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

///点赞
- (void)praiseButtonPress:(UIButton *)sender {
    NSDictionary *param = @{
                            @"replyId": self.dataArray[sender.tag][@"replyId"]

                            };
    [self.service POST:@"book/postReply/praiseReply" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"点赞成功"];
//        改图标为蓝
        [sender setImage:[UIImage imageNamed:@"app_praise_done"] forState:(UIControlStateNormal)];
//        禁止再次点击
        sender.enabled = NO;
//        赞数+1
        PostTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:1]];
        NSInteger newPraiseCount = [cell.praiseCountLabel.text integerValue] + 1;
        cell.praiseCountLabel.text = [NSString stringWithFormat:@"%zi",newPraiseCount];
    } noResult:nil];
}
@end

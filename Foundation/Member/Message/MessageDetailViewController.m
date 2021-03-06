//
//  MessageDetailViewControllr.m
//  Foundation
//
//  Created by Dotton on 16/4/29.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

/***消息->消息详情***/

#import "MessageDetailViewController.h"
#import "LXButton.h"
#import "UserDetailViewController.h"
#import "ProjectDetailViewController.h"
#import "ActivityDetailViewController.h"
#import "BookDetailViewController.h"
#import "SingletonObject.h"
#import "VerifyUtil.h"
#import "MessageWebViewController.h"

@interface MessageDetailViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) IBOutlet UILabel *createdDatetimeLabel;//时间
@property (nonatomic,strong) IBOutlet UILabel *contentLabel;//内容
@property (nonatomic,strong) IBOutlet UIImageView *avatarImageView;//收信下的头像
@property (nonatomic,strong) IBOutlet UIButton *realNameButton;//收信－>消息详情的 发信人按钮
@property (nonatomic,strong) IBOutlet UILabel *realNameLabel;//系统管理员
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;//来自
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;//标题
//跳转按钮
@property (weak, nonatomic) IBOutlet LXButton *jumpButton;
//灰底背景色ContentView
@property (weak, nonatomic) IBOutlet UIView *msgContentView;//收信-->消息详情 下方的框
//输入框
@property (nonatomic,strong) IBOutlet UITextField *msgTextField;//收信->消息详情 下方的输入框

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIButton *spreeBtn;

@property (nonatomic, copy) NSString *urlStr;


@end

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self setDynamicLayout];
    
    self.msgTextField.delegate = self;
    [self changeMsgStatus];
    
    //时间
    self.createdDatetimeLabel.text = [DateUtil toShortDateCN:self.dataDict[@"createdDate"] time:self.dataDict[@"createdTime"]];
    //标题
    self.captionLabel.text = [StringUtil toString:self.dataDict[@"title"]];
    //内容
    self.contentLabel.text = [StringUtil toString:self.dataDict[@"content"]];
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentLabel.frame);
    
    //正则表达式获取url
    NSError *error;
    NSString *regulaStr = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:self.contentLabel.text options:0 range:NSMakeRange(0, [self.contentLabel.text length])];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        self.urlStr = [self.contentLabel.text substringWithRange:match.range];
        if (![self.urlStr isEqualToString:@""]) {
            [self.spreeBtn setTitle:@"点击领取创业学习大礼包" forState:UIControlStateNormal];
        }else {
            self.spreeBtn.hidden = YES;
        }
    }
    
    //如根据从上一个页面传过来的 type  加载不同的详情页面 1-->收信页面
    if ([self.dataDict[@"type"] integerValue] == 1) {
        //私信
        [self.realNameButton setTitle:self.dataDict[@"realName"] forState:(UIControlStateNormal)];
        NSString *url = [NSString stringWithFormat:@"%@/%@",UPLOAD_URL,[StringUtil toString:self.dataDict[@"pictUrl"]]];
        self.avatarImageView.clipsToBounds = YES;
        self.avatarImageView.layer.cornerRadius = CGRectGetWidth(self.avatarImageView.frame) / 2.0;
        [self.avatarImageView setImageWithURL:[NSURL URLWithString:url]];
        self.realNameLabel.hidden = YES;
    
//        消息发送者为本人
        if ([self.dataDict[@"userId"] isEqualToString:[User getInstance].uid]) {
            //隐藏文本输入框与发送按钮
            self.msgContentView.hidden = YES;
        }
    }
    //加载系统通知详情页面
    else {
        
//        系统消息
//        self.realNameLabel.text = self.dataDict[@"realName"];
        self.realNameLabel.text = @"系统管理员";
        self.realNameButton.hidden = YES;
        self.avatarImageView.hidden = YES;
        //隐藏文本输入框与发送按钮
        self.msgContentView.hidden = YES;
//        self.msgContentView.backgroundColor = [UIColor whiteColor];
    }
//    立即查看、加为好友等按钮
    if (self.dataDict[@"contentType"] == [NSNull null] || [self.dataDict[@"contentType"] isEqualToString:@""]) {
        self.jumpButton.hidden = YES;
    } else {
        switch ([self.dataDict[@"contentType"] integerValue]) {
//                contentType: 文献1,活动2,项目3,好友4
            case 1:
                [self.jumpButton setTitle:@"立即查看" forState:(UIControlStateNormal)];
                [self.jumpButton addTarget:self action:@selector(jumpBook:) forControlEvents:(UIControlEventTouchUpInside)];
                break;
            case 2:
                [self.jumpButton setTitle:@"立即查看" forState:(UIControlStateNormal)];
                [self.jumpButton addTarget:self action:@selector(jumpActivity:) forControlEvents:(UIControlEventTouchUpInside)];
                break;
            case 3:
                [self.jumpButton setTitle:@"立即查看" forState:(UIControlStateNormal)];
                [self.jumpButton addTarget:self action:@selector(jumpProject:) forControlEvents:(UIControlEventTouchUpInside)];
                break;
            case 4:
                [self.jumpButton setTitle:@"通过验证" forState:(UIControlStateNormal)];
                [self.jumpButton addTarget:self action:@selector(makeFriends:) forControlEvents:(UIControlEventTouchUpInside)];
                break;
            default:
                break;
        }
    }
}
- (IBAction)spreeBtnClick:(UIButton *)sender {
    MessageWebViewController *webVC = [[MessageWebViewController alloc] init];
    webVC.urlStr = self.urlStr;
    [self.navigationController pushViewController:webVC animated:YES];
}

///加载本页时改变消息状态
- (void)changeMsgStatus {
//    首先得是非对方已回复的，也非已读，才调。同时还得非本人，与回复框显示与否同理。
    if ((self.dataDict[@"status"] == [NSNull null] || [self.dataDict[@"status"] integerValue] == 0) && ![[StringUtil toString:self.dataDict[@"userId"]] isEqualToString:[User getInstance].uid]) {
        NSDictionary *param = @{
                                @"msgId":self.dataDict[@"id"],
                                @"status":@"1"
                                };
        [self.service POST:@"personal/msg/changeMsgStatus" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [SVProgressHUD showSuccessWithStatus:@"已读"];
        } noResult:nil];
    }
}

//跳转个人详情
- (IBAction)showUserDetail:(id)sender {
    UserDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Friends" bundle:nil] instantiateViewControllerWithIdentifier:@"userDetail"];
    vc.userId = self.dataDict[@"userId"];
    [self.navigationController pushViewController:vc animated:YES];
}

//立即查看4种跳转
//文章
- (void)jumpBook:(id)sender {
    BookDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Book" bundle:nil] instantiateViewControllerWithIdentifier:@"detail"];
    vc.bookId = self.dataDict[@"contentId"];
    [self.navigationController pushViewController:vc animated:YES];
}

//活动
- (void)jumpActivity:(id)sender {
    [SingletonObject getInstance].pid = self.dataDict[@"contentId"];
    ActivityDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Activity" bundle:nil] instantiateViewControllerWithIdentifier:@"detail"];
    vc.activityId = self.dataDict[@"contentId"];
    [self.navigationController pushViewController:vc animated:YES];
}

//项目
- (void)jumpProject:(id)sender {
    [SingletonObject getInstance].pid = self.dataDict[@"contentId"];
    ProjectDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"detail"];;
    [self.navigationController pushViewController:vc animated:YES];
}

//通过验证
- (void)makeFriends:(id)sender {
    NSDate *now = [NSDate date];
    NSDictionary *param = @{@"Friends":[StringUtil dictToJson:@{
                                                                @"friendId":self.dataDict[@"userId"],
                                                                @"userId":[User getInstance].uid,
                                                                @"createdDate": [DateUtil dateToDatePart:now],
                                                                @"createdTime": [DateUtil dateToTimePart:now],
                                                                @"realName":self.dataDict[@"realName"]
                                                                }
                                        ],
                            @"msgId":self.dataDict[@"id"]
                            };
    [self.service POST:@"personal/friends/makeFriends" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.jumpButton.hidden = YES;
        [SVProgressHUD showSuccessWithStatus:@"添加好友成功"];
    } noResult:nil];
    
}

// 消息->收信->消息详情 发送文本按钮
- (IBAction)sendButtonPress:(id)sender {
//    msgTextField
    if (![VerifyUtil hasValue:self.msgTextField.text]) {
        [SVProgressHUD showErrorWithStatus:@"请输入要回复的内容"];
        return;
    }
    [self.msgTextField resignFirstResponder];
    NSDate *now = [NSDate date];
    NSDictionary *param = @{
                            @"UserMessage":[StringUtil dictToJson:@{
                                                                    @"content": self.msgTextField.text,
                                                                    @"createdDate": [DateUtil dateToDatePart:now],
                                                                    @"createdTime": [DateUtil dateToTimePart:now],
                                                                    @"replyMsgId": self.dataDict[@"id"],
                                                                    @"status": @"0",
                                                                    @"toUserId": self.dataDict[@"userId"],
                                                                    @"type": @"1",
                                                                    @"userId": [User getInstance].uid
                                                                    }
                                            ]
                            };
    [self.service POST:@"personal/msg/sendMsg" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        self.msgTextField.text = @"";
    } noResult:nil];
}

#pragma mark - textField delegate 
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendButtonPress:nil];
    return YES;
}

#pragma mark - tb delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
//        跳转按钮所在行；分别减去导航栏、消息摘要行、文本框所在行，但不包括底部栏
        CGFloat height = SCREEN_HEIGHT - 64.0 - 100.0 - 44.0 - 49.0;
//        if (self.dataDict[@"title"] != [NSNull null]) {
//            //当如系统信息是没有标题栏的时候
//            height += 40.0;
//        }
        
        NSLog(@"height:%f", height);
        
        return height;
    } else if (indexPath.row == 0) {
        if (self.dataDict[@"title"] == [NSNull null]) {
            return 60.0;
        }else {
            //自适应获得文本的高度
            CGSize size = [self.contentLabel systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
            NSLog(@"%f", size.height);
            return size.height + 100;
        }
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end

//
//  BookDetailViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/4.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//


/***创成长->文献列表->文献详情***/

#import "BookDetailViewController.h"
#import "DTKDropdownMenuView.h"
#import "ShareUtil.h"
#import "EYInputPopupView.h"
#import "VerifyUtil.h"
#import "CommentTableViewController.h"
#import "CopyrightViewController.h"
#import "LXWebView.h"
#import "BookSearchByTitleOrOthersTableViewController.h"

@interface BookDetailViewController ()<UIWebViewDelegate,UIAlertViewDelegate>
{
    DTKDropdownItem *_item0;
    DTKDropdownItem *_item1;
    DTKDropdownItem *_item2;
    DTKDropdownItem *_item3;
}
@property (weak, nonatomic) IBOutlet LXWebView *webView;
@property (assign, nonatomic) CGFloat introWebViewHeight;
//是否已经加载网页
@property (assign, nonatomic) BOOL isLoadedWeb;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *readNumLabel;//阅读数
@property (weak, nonatomic) IBOutlet UILabel *collectNumLabel;//收藏数
@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;//评论数

@property (weak, nonatomic) IBOutlet UIView  *footContentView;

@property (weak, nonatomic) IBOutlet UIImageView *collectNumImageView;//收藏视图

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //给收藏视图添加手势
    self.collectNumImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired    = 1;
    tap.view.tag = 0;
    tap.numberOfTouchesRequired = 1;
    [self.collectNumImageView addGestureRecognizer:tap];
    
    //导航栏下拉菜单
    [self addRightItem];
    
    [self setDynamicLayout];
    
//    self.footContentView.hidden = YES;
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
    [self.webView customMenu];
    
    
    
    [SVProgressHUD showWithStatus:@"正在加载"];
    NSDictionary *param = @{@"bookId":self.bookId};
    [self.service POST:@"book/getBook" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.webView.bookId = self.bookId;
        self.webView.bookName = responseObject[@"title"];
//        self.footContentView.hidden = NO;
        self.dataDict = responseObject;
//        NSString *cssStr = @"<style>img{width:100%;}</style>";
//        标题栏
        self.navigationItem.title = responseObject[@"specialName"];
//        title
        self.captionLabel.text = responseObject[@"title"];
        if ([[User getInstance].isAdmin boolValue] && [self.dataDict[@"status"] integerValue] != 1) {
            self.captionLabel.textColor = [UIColor redColor];
            self.captionLabel.text = [NSString stringWithFormat:@"%@[待发布]",responseObject[@"title"]];
        }
//        date
        self.publishDateLabel.text = [DateUtil toString:responseObject[@"publishDate"]];
        //nums
        self.readNumLabel.text = [responseObject[@"readNum"] stringValue];
        self.collectNumLabel.text = [responseObject[@"collectNum"] stringValue];
        self.commentNumLabel.text = [responseObject[@"commentNum"] stringValue];
        NSString *contentStr = responseObject[@"content"];
        [self.webView loadHTMLString:contentStr baseURL:nil];
        
        
    } noResult:^{
        
    }];
    
}


//点击收藏
- (void)tap:(UITapGestureRecognizer *)tt {
    if ([[User getInstance] isLogin]) {
        
        if (tt.view.tag == 0) {
            //收藏后及时更新数据
            NSString *collectNum = self.collectNumLabel.text;
            int num = [collectNum intValue] + 1;
            self.collectNumLabel.text = [NSString stringWithFormat:@"%d", num];
            tt.view.tag = 1;
            //        访问网络
            NSDictionary *param = @{
                                    @"Collect":[StringUtil dictToJson:@{
                                                                        @"bookId":self.bookId,
                                                                        @"userId":[User getInstance].uid,
                                                                        @"specialType":self.dataDict[@"specialCode"],
                                                                        @"bookType":self.dataDict[@"bookType"],
                                                                        @"isAttention":@1
                                                                        }]
                                    };
            [self.service GET:@"personal/collect/collectBook" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            } noResult:nil];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"该文献已经收藏"];
        }
    }else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
        [alertView show];
    }

}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        //进入团团创登陆页面
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
}

//点击版权声明
- (IBAction)copyrightButtonPress:(id)sender {
    CopyrightViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"copyright"];
    vc.bookId = self.bookId;
    [self.navigationController pushViewController:vc animated:YES];
}

//webView delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if(self.isLoadedWeb)
    {
        NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"];
        
        if (self.introWebViewHeight == 0) {
            self.introWebViewHeight = [height_str intValue];
            [self.tableView reloadData];
        }
        return;
    }
    
    //js获取body宽度
    NSString *bodyWidth= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollWidth "];
    
    int widthOfBody = [bodyWidth intValue];
    
    NSString *htmlBody  = [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    
    //    NSLog(@"htmlBody: %@",htmlBody);
    //获取实际要显示的html
    NSString *html = [self htmlAdjustWithPageWidth:widthOfBody
                                              html:htmlBody
                                           webView:webView];
    //    NSLog(@"new htmlBody: %@",html);
    self.isLoadedWeb = YES;
    //加载实际要现实的html
    [webView loadHTMLString:html baseURL:nil];
    
    self.footContentView.hidden = NO;
    [SVProgressHUD dismiss];
}

//获取宽度已经适配于webView的html。这里的原始html也可以通过js从webView里获取
- (NSString *)htmlAdjustWithPageWidth:(CGFloat )pageWidth
                                 html:(NSString *)html
                              webView:(UIWebView *)webView
{
    NSMutableString *str = [NSMutableString stringWithString:html];
    //计算要缩放的比例
    //    CGFloat initialScale = webView.frame.size.width/pageWidth;
    //将</head>替换为meta+head
    CGFloat webWidth = SCREEN_WIDTH - 16;
    if (SCREEN_WIDTH == 414) {
        webWidth = SCREEN_WIDTH - 32;
    }
    
    NSString *stringForReplace = [NSString stringWithFormat:@"<meta name=\"viewport\" http-equiv=\"Content-Type\"  content=\"charset=utf-8\"><style>body{margin:10px auto;padding:0;width:%.2f;white-space:normal;}body img{width:100%%;} p{margin-left:0px;padding-left:0px;text-align:justify;text-align-last:justify;}</style></head>",webWidth];
    
    NSRange range =  NSMakeRange(0, str.length);
    //替换
    [str replaceOccurrencesOfString:@"</head>" withString:stringForReplace options:NSLiteralSearch range:range];
    //    NSLog(@"%@",str);
    return str;
}

//height for web
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        return self.introWebViewHeight;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

//cell for labels
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        UITableViewCell *cell = [UITableViewCell new];
        for (int i = 0; i < [self.dataDict[@"labels"] count]; i++) {
            NSDictionary *labelDict = self.dataDict[@"labels"][i];
            UIButton *labelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
            //frame
            labelButton.frame = CGRectMake(10 + 90 * i, 10, 80, 20);
            //font
            labelButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
            //color
            [labelButton setTitleColor:MAIN_COLOR forState:(UIControlStateNormal)];
            //border
            labelButton.layer.cornerRadius = 10.0;
            labelButton.layer.borderColor = [MAIN_COLOR CGColor];
            labelButton.layer.borderWidth = 1.0;
            [labelButton setTitle:labelDict[@"labelName"] forState:(UIControlStateNormal)];
            labelButton.tag = i;
            [labelButton addTarget:self action:@selector(searchByLabelId:) forControlEvents:(UIControlEventTouchUpInside)];
            [cell.contentView addSubview:labelButton];
        }
        
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

//标签点击事件
- (void)searchByLabelId:(UIButton *)sender {
    NSString *labelId = self.dataDict[@"labels"][sender.tag][@"id"];
    
    
    BookSearchByTitleOrOthersTableViewController *vc = [[BookSearchByTitleOrOthersTableViewController alloc] init];
    vc.keyWords = labelId;
    vc.type = @"SEQ_labelId";
    vc.specialCode = self.dataDict[@"specialCode"];
    [self.navigationController pushViewController:vc animated:YES];
}

///导航栏下拉菜单
- (void)addRightItem
{
    __weak typeof(self) weakSelf = self;
    _item0 = [DTKDropdownItem itemWithTitle:@"查看热评" iconName:@"app_comment" callBack:^(NSUInteger index, id info) {
        if ([[User getInstance] isLogin]) {
            CommentTableViewController *commentVC = [self.storyboard instantiateViewControllerWithIdentifier:@"comment"];
            commentVC.bookId = self.bookId;
            [weakSelf.navigationController pushViewController:commentVC animated:YES];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
            [alertView show];
        }
        
    }];
    _item1 = [DTKDropdownItem itemWithTitle:@"写评论" iconName:@"menu_add_comment" callBack:^(NSUInteger index, id info) {
        if ([[User getInstance] isLogin]) {
            [EYInputPopupView popViewWithTitle:@"评论帖子" contentText:@"请填写评论内容(1-500字)"
                                          type:EYInputPopupView_Type_multi_line
                                   cancelBlock:^{
                                       
                                   } confirmBlock:^(UIView *view, NSString *text) {
                                       if (![VerifyUtil isValidStringLengthRange:text between:1 and:200]) {
                                           [SVProgressHUD showErrorWithStatus:@"请评论回复内容(1-500字)"];
                                           return ;
                                       }
                                       NSDictionary *param = @{
                                                               @"BookComment":[StringUtil dictToJson:@{
                                                                                                       @"bookId":self.bookId,
                                                                                                       @"userId":[User getInstance].uid,
                                                                                                       @"comment":text,
                                                                                                       }]
                                                               };
                                       [self.service POST:@"book/comment/addComment" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           [SVProgressHUD showSuccessWithStatus:@"评论成功"];
                                       } noResult:nil];
                                   } dismissBlock:^{
                                       
                                   }
             ];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
            [alertView show];
        }
       
    }];
    
    //点击收藏
    _item2 = [DTKDropdownItem itemWithTitle:@"收藏" iconName:@"app_collect" callBack:^(NSUInteger index, id info) {
        if ([[User getInstance] isLogin]) {
            
            
            
            
            //        访问网络
            NSDictionary *param = @{
                                    @"Collect":[StringUtil dictToJson:@{
                                                                        @"bookId":self.bookId,
                                                                        @"userId":[User getInstance].uid,
                                                                        @"specialType":self.dataDict[@"specialCode"],
                                                                        @"bookType":self.dataDict[@"bookType"],
                                                                        @"isAttention":@1
                                                                        }]
                                    };
            [self.service GET:@"personal/collect/collectBook" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
                //收藏后及时更新数据
                NSString *collectNum = self.collectNumLabel.text;
                int num = [collectNum intValue] + 1;
                self.collectNumLabel.text = [NSString stringWithFormat:@"%d", num];
                
            } noResult:nil];
        } else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"为方便您管理相关信息，请登录后再进行相关操作哦" delegate:self cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即登录", nil];
                [alertView show];
        }

        
    }];
    _item3 = [DTKDropdownItem itemWithTitle:@"分享" iconName:@"menu_share" callBack:^(NSUInteger index, id info) {
//        请求网络获取副标题摘要
        NSDictionary *param = @{
                                @"type":@"4"
                                };
        [self.service POST:@"standard/getStandard" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            ShareUtil *share = [ShareUtil getInstance];
            share.shareTitle = [NSString stringWithFormat:@"[%@]%@",BOOK_TYPE_TEXT[self.dataDict[@"bookType"]],self.dataDict[@"title"]];
            share.shareText = responseObject[@"content"];
            share.shareUrl = [NSString stringWithFormat:@"%@/%@",SHARE_BOOK_URL,self.dataDict[@"bookId"]];
            share.vc = self;
            [share shareWithUrl];
        } noResult:nil];
    }];
    DTKDropdownItem *item4 = [DTKDropdownItem itemWithTitle:@"文献发布" iconName:@"menu_pub" callBack:^(NSUInteger index, id info) {
        if ([[User getInstance] isLogin]) {
            NSDictionary *param = @{
                                    @"bookId":self.bookId
                                    };
            [self.service POST:@"book/appPublish" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            } noResult:nil];        }else{
            LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
            [self.navigationController presentViewController:vc animated:YES completion:nil];
        }

        
    }];
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:_item0];
    [array addObject:_item1];
    [array addObject:_item2];
    [array addObject:_item3];
    if (self.dataDict != nil) {
        //说明已经网络加载过了
        if ([[User getInstance].isAdmin boolValue] && [self.dataDict[@"status"] integerValue] != 1) {
            [array addObject:item4];
        }
    }
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
}

@end

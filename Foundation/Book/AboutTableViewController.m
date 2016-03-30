//
//  AboutTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/3/27.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "AboutTableViewController.h"
#import "SubTabBarController.h"

@interface AboutTableViewController ()
@property (nonatomic,strong) IBOutlet UITextView *specialIdeaTextView;
@property (nonatomic,strong) IBOutlet UITextView *specialPostionTextView;
@property (nonatomic,strong) IBOutlet UITextView *specialDescTextView;
@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = ((SubTabBarController *)self.tabBarController).specialName;
    NSDictionary *param = @{
                            @"specialCode":((SubTabBarController *)self.tabBarController).specialCode,
                            };
    [self.service POST:@"/book/special/getSpecialType" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.specialIdeaTextView.attributedText = [[NSAttributedString alloc] initWithString:responseObject[@"specialIdea"] attributes:[StringUtil textViewAttribute]];
        self.specialPostionTextView.attributedText = [[NSAttributedString alloc] initWithString:responseObject[@"specialPostion"] attributes:[StringUtil textViewAttribute]];
        self.specialDescTextView.attributedText = [[NSAttributedString alloc] initWithString:responseObject[@"specialDesc"] attributes:[StringUtil textViewAttribute]];
        
        [self.specialIdeaTextView sizeToFit];
        [self.specialPostionTextView sizeToFit];
        [self.specialDescTextView sizeToFit];
        [self.tableView reloadData];
    } noResult:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

//回到主页
- (IBAction)goBack:(id)sender {
    [self.tabBarController.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.specialIdeaTextView.frame.size.height + 60.0;
    } else if (indexPath.row == 1) {
        return self.specialPostionTextView.frame.size.height + 60.0;
    } else if (indexPath.row == 2) {
        return self.specialDescTextView.frame.size.height + 60.0;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

@end

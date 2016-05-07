//
//  TeamEditTableViewController.m
//  Foundation
//
//  Created by Dotton on 16/5/7.
//  Copyright © 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "TeamEditTableViewController.h"

@interface TeamEditTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UITextField *dutyTextField;

@end

@implementation TeamEditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//delete
- (IBAction)deleteButtonPress:(id)sender {
    
    [[PXAlertView showAlertWithTitle:@"确定要删除吗？" message:nil cancelTitle:@"取消" otherTitle:@"确定" completion:^(BOOL cancelled, NSInteger buttonIndex) {
        if (!cancelled) {
            
            for (NSDictionary *dict in [self.parentVC.dataArray copy]) {
                if (dict[@"parterId"] == self.parterId) {
                    [self.parentVC.dataArray removeObject:dict];
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                }
            }
        }
    }] useDefaultIOS7Style];
}

//modity
- (IBAction)submitButtonPress:(id)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

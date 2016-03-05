//
//  UserService.m
//  MobileSheild
//
//  Created by HuangXiuJie on 15/3/28.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "HttpService.h"
#import "SVProgressHUD.h"
@implementation HttpService
- (instancetype)init {
    self.manager = [AFHTTPRequestOperationManager manager];
    return self;
}
+ (instancetype)getInstance {
    static HttpService *instance;
    if (instance == nil) {
        instance = [[self alloc]init];
    }
    return instance;
}

- (void)GET:(NSString *)actionStr parameters:(NSDictionary *)parameters success:(success)success{
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",@"http://120.25.231.152:8080/ttc_web",actionStr];
    [self.manager GET:urlstr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
    }];
}

- (void)POST:(NSString *)actionStr parameters:(NSDictionary *)parameters success:(success)success{
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",@"http://120.25.231.152:8080/ttc_web",actionStr];
    [self.manager POST:urlstr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"success"] integerValue] == YES) {
            success(operation,responseObject);
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:responseObject[@"msg"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
    }];
    
}
@end

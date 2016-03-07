//
//  UserService.m
//  MobileSheild
//
//  Created by HuangXiuJie on 15/3/28.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "HttpService.h"
#import "SVProgressHUD.h"
#define HOST_URL @"http://120.25.231.152:8080/ttc_web"
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
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setObject:@"MOBILE" forKey:@"clientType"];
    NSLog(@"param:%@",dict);
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",HOST_URL,actionStr];
    [self.manager GET:urlstr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"success"] integerValue] == YES) {
            success(operation,responseObject[@"data"]);
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:responseObject[@"msg"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
    }];
}

- (void)POST:(NSString *)actionStr parameters:(NSDictionary *)parameters success:(success)success{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setObject:@"MOBILE" forKey:@"clientType"];
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",HOST_URL,actionStr];
    [self.manager POST:urlstr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([responseObject[@"success"] integerValue] == YES) {
            success(operation,responseObject[@"data"]);
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:responseObject[@"msg"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
    }];
    
}
@end

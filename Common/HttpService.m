//
//  UserService.m
//  MobileSheild
//
//  Created by HuangXiuJie on 15/3/28.
//  Copyright (c) 2015年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "LoginViewController.h"
#import "SingletonObject.h"

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

- (void)GET:(NSString *)actionStr parameters:(NSDictionary *)parameters success:(success)success noResult:(noResultBlock)noResult{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setObject:@"MOBILE" forKey:@"clientType"];
//    NSLog(@"param:%@",dict);
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",HOST_URL,actionStr];
    [self.manager GET:urlstr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"origin response:\n%@",responseObject);
        if ([responseObject[@"success"] boolValue] == YES) {
            success(operation,responseObject[@"data"]);
//            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
        } else {
            if ([responseObject[@"errorCode"] integerValue] == 520) {
                //未登录
                [SingletonObject getInstance].isMaticLogout = YES;
                LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
                [[[UIApplication sharedApplication].windows firstObject] setRootViewController:vc];
            } else if ([responseObject[@"errorCode"] integerValue] == 521){
//                无结果
                [SVProgressHUD showSuccessWithStatus:@"加载完毕"];
                noResult();
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:responseObject[@"msg"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
        [[[UIApplication sharedApplication].windows firstObject] setRootViewController:vc];
    }];
}

- (void)POST:(NSString *)actionStr parameters:(NSDictionary *)parameters success:(success)success noResult:(noResultBlock)noResult{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [dict setObject:@"MOBILE" forKey:@"clientType"];
    //    NSLog(@"param:%@",dict);
    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",HOST_URL,actionStr];
    [self.manager POST:urlstr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"origin response:\n%@",responseObject);
        if ([responseObject[@"success"] boolValue] == YES) {
            success(operation,responseObject[@"data"]);
//            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
        } else {
            if ([responseObject[@"errorCode"] integerValue] == 520) {
                //未登录
                [SingletonObject getInstance].isMaticLogout = YES;
                LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
                [[[UIApplication sharedApplication].windows firstObject] setRootViewController:vc];
            } else if ([responseObject[@"errorCode"] integerValue] == 521){
                //                无结果
                if (noResult) {
                    noResult();
                }
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:responseObject[@"msg"] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",operation.responseString);
        LoginViewController *vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateInitialViewController];
        [[[UIApplication sharedApplication].windows firstObject] setRootViewController:vc];
    }];
}

//- (void)POST:(NSString *)actionStr parameters:(NSDictionary *)parameters success:(success)success {
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
//    [dict setObject:@"MOBILE" forKey:@"clientType"];
//    NSString *urlstr = [NSString stringWithFormat:@"%@/%@",HOST_URL,actionStr];
//    [self.manager POST:urlstr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:UIImageJPEGRepresentation(self.picker.imageOriginal,0.8) name:@"headPictUrl" fileName:@"something.jpg" mimeType:@"image/jpeg"];
//        //            NSLog(@"urlstr:%@ param:%@",urlstr,param);
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //            NSLog(@"responseObject:%@",responseObject);
//        if ([responseObject[@"success"] boolValue]) {
//            [SVProgressHUD showSuccessWithStatus:responseObject[@"msg"]];
//            [self goBack];
//        } else {
//            [SVProgressHUD showErrorWithStatus:responseObject[@"msg"]];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//        [[[UIAlertView alloc]initWithTitle:@"上传失败" message:@"网络故障，请稍后重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
//    }];
//}
@end

//
//  LocationUtil.m
//  Commune
//
//  Created by Dotton on 16/3/12.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import "LocationUtil.h"

@implementation LocationUtil
#pragma mark - location service
+ (instancetype)getInstance {
    static LocationUtil *instance;
    if (instance == nil) {
        instance = [[self alloc]init];
    }
    return instance;
}

//请求地理位置
- (void)fetchLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    if([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 500;
        self.locationManager.delegate = self;
        if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 8.0)
        {
            //设置定位权限 仅ios8有意义
            [self.locationManager requestWhenInUseAuthorization];// 前台定位
        }
        [self.locationManager startUpdatingLocation];
    }else {
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"未开启定位" message:@"请打开设置-隐私-启用地理位置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alertView show];
    }
}

//成功获取地理位置
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    CLLocation *location = [locations lastObject];
    self.coordinate = location.coordinate;
    [self convertCityName];
//    坐标存在本地
    NSDictionary *locationDict = @{@"x_point":[NSString stringWithFormat:@"%f",location.coordinate.latitude],@"y_point":[NSString stringWithFormat:@"%f",location.coordinate.longitude]};
    [[NSUserDefaults standardUserDefaults] setObject:locationDict forKey:@"location"];
//    NSLog(@"%@",locationStr);
    [self.locationManager stopUpdatingLocation];
    self.isSuccess = YES;
}

//地理位置获取失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.isSuccess = NO;
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"定位失败" message:@"请检查系统设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//    [alertView show];
}

//转换成城市名
- (void)convertCityName {
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    CLLocation *location = [[CLLocation alloc]initWithLatitude:self.coordinate.latitude longitude:self.coordinate.longitude];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSString *cityNameWithoutSuffix = [[city componentsSeparatedByString:@"市"] firstObject];
//            首次运行，本地还没有存过
            if (self.locatedCityName == nil) {
                self.locatedCityName = cityNameWithoutSuffix;
            }
//            成员变量，始终赋值，供切换城市页使用
            self.cityName = cityNameWithoutSuffix;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getCityNameSuccess" object:nil];
        }
    }];
}

//重写getter setter方法，存到本地
- (NSString *)locatedCityName {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"locatedCityName"];
}

- (void)setLocatedCityName:(NSString *)locatedCityName {
    [[NSUserDefaults standardUserDefaults] setObject:locatedCityName forKey:@"locatedCityName"];
}

//取出坐标字典
- (NSDictionary *)coordinateDict {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"location"];
}

//给出默认定位地址，附近店铺接口非要传，其他接口无视
- (NSDictionary *)defaultCoordinateDict {
    return @{@"x_point":@"0",@"y_point":@"0"};
}
@end

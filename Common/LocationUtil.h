//
//  LocationUtil.h
//  Commune
//
//  Created by Dotton on 16/3/12.
//  Copyright (c) 2016年 瑞安市灵犀网络技术有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
//typedef void (^cityName)(NSString *);

@interface LocationUtil : NSObject<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
//定位到的城市
@property (nonatomic, strong) NSString *cityName;
//切换后存于本地的城市
@property (nonatomic, strong) NSString *locatedCityName;
+ (instancetype)getInstance;
- (void)fetchLocation;
//取出坐标字典
- (NSDictionary *)coordinateDict;
//给出默认定位地址
- (NSDictionary *)defaultCoordinateDict;
//是否定位成功
@property (nonatomic, assign) BOOL isSuccess;
@end

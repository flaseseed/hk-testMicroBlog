//
//  ProfileViewController.m
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "ProfileViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ProfileViewController ()<CLLocationManagerDelegate>

@end

@implementation ProfileViewController
{
    CLLocationManager *manager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //下载图片包
    //    [self.appDelegate.sinaWeibo requestWithURL:@"emotions.json" params:nil httpMethod:@"GET" finishBlock:^(SinaWeiboRequest *request, id result) {
    ////        NSLog(@"%@", result);
    //        NSArray *arr = result;
    //
    ////        if ([arr writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:@"documents/emotions.plist"] atomically:YES]) {
    ////            NSLog(@"保存成功");
    ////        }
    //        for (NSDictionary *dic in arr) {
    //
    //            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"url"]]];
    //            [data writeToFile:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"documents/%@", dic[@"value"]]] atomically:YES];
    //        }
    //        NSLog(@"%@", NSHomeDirectory());
    //
    //    } failBlock:^(SinaWeiboRequest *request, NSError *error) {
    //
    //    }];
    
    //    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //
    //    NSLog(@"%ld",manager.networkReachabilityStatus);
    //
    //    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    //        switch (status) {
    //            case AFNetworkReachabilityStatusUnknown:
    //                NSLog(@"未知网络");
    //                break;
    //            case AFNetworkReachabilityStatusNotReachable:
    //                NSLog(@"没有网络");
    //                break;
    //            case AFNetworkReachabilityStatusReachableViaWWAN:
    //                NSLog(@"蜂窝网络");
    //                break;
    //            case AFNetworkReachabilityStatusReachableViaWiFi:
    //                NSLog(@"WIFI网络");
    //                break;
    //            default:
    //                break;
    //        }
    //    }];

    //1、定位 经纬度 海拔
    
    //定位功能是否开启
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位已开");
    }
    
    manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    
//    iOS8 app想要获取定位，必须申请授权，在info.plist中添加：
//    NSLocationAlwaysUsageDescription  始终
//    NSLocationWhenInUseUsageDescription 使用应用程序期间
    
    /**
     *  
     kCLAuthorizationStatusNotDetermined = 0, 用户还没决定是否授权
     
     kCLAuthorizationStatusRestricted, 应用程序收到限制，无法授权
     
     kCLAuthorizationStatusDenied, 拒绝授权
    
     kCLAuthorizationStatusAuthorizedAlways 始终授权
     
     kCLAuthorizationStatusAuthorizedWhenInUse 使用时授权
     */
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
        //将定位服务访问设置为当使用的时候定位
        [manager requestWhenInUseAuthorization];
    }
    
    //定位的精度 double类型 精度越高越耗电 
    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    
    //定位的频率
    manager.distanceFilter = 10.0;
    
    //开始定位
    [manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"%@", locations);
    //    坐标经纬度
//    CLLocationCoordinate2D coordinate;
//    CLLocationDegrees latitude;
//    CLLocationDegrees longitude;
    NSLog(@"经纬度%f %f 海拔%f 水平，垂直精确度%f %f",locations[0].coordinate.latitude,locations[0].coordinate.longitude, locations[0].altitude, locations[0].horizontalAccuracy, locations[0].verticalAccuracy);
    
    //创建位置对象
    CLLocation *anyLocation = [[CLLocation alloc] initWithLatitude:39.92 longitude:116.18];
    //计算两个点之间的距离
    CLLocationDistance distance = [locations[0] distanceFromLocation:anyLocation];
    NSLog(@"杭州总部离北京总部的距离%f", distance);//将近1138公里
    
    //位置反编码（经纬度->具体的地点）30，120 ->杭州
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locations[0] completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
       
        for (CLPlacemark *place in placemarks) {
            NSLog(@"%@", place);
        }
    }];
    
     }
/*   
 具体的位置
 @property (nonatomic, readonly, copy, nullable) NSString *name; // eg. Apple Inc.
街道
@property (nonatomic, readonly, copy, nullable) NSString *thoroughfare; // street name, eg. Infinite Loop
 子街道
 @property (nonatomic, readonly, copy, nullable) NSString *subThoroughfare; // eg. 1
 市
 @property (nonatomic, readonly, copy, nullable) NSString *locality; // city, eg. Cupertino
 县/区
 @property (nonatomic, readonly, copy, nullable) NSString *subLocality; // neighborhood, common name, eg. Mission District
 行政区 浙江省 新疆自治区 香港特别行政区
 @property (nonatomic, readonly, copy, nullable) NSString *administrativeArea; // state, eg. CA
 子区 一般情况下，地级市 州 等
@property (nonatomic, readonly, copy, nullable) NSString *subAdministrativeArea; // county, eg. Santa Clara
 邮政编码
 @property (nonatomic, readonly, copy, nullable) NSString *postalCode; // zip code, eg. 95014
国家编码 CN US
@property (nonatomic, readonly, copy, nullable) NSString *ISOcountryCode; // eg. US
国家名
@property (nonatomic, readonly, copy, nullable) NSString *country; // eg. United States
湖
@property (nonatomic, readonly, copy, nullable) NSString *inlandWater; // eg. Lake Tahoe
 海洋
 @property (nonatomic, readonly, copy, nullable) NSString *ocean; // eg. Pacific Ocean
 名胜古迹
 @property (nonatomic, readonly, copy, nullable) NSArray<NSString *> *areasOfInterest; // eg. Golden Gate Park
    }];*/
    

@end


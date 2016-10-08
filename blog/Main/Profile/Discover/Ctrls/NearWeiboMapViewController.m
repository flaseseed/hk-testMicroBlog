//
//  NearWeiboMapViewController.m
//  84班微博
//
//  Created by wenyuan on 1/22/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "NearWeiboMapViewController.h"
#import <MapKit/MapKit.h>
#import "WeiboAnnotationView.h"

@interface NearWeiboMapViewController ()<MKMapViewDelegate>
{
    CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation NearWeiboMapViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (iOS8) {
        locationManager = [[CLLocationManager alloc] init];
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
            [locationManager requestWhenInUseAuthorization];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}
*/

//4.请求附近的微博
-(void)loadNearWeibo:(NSString *)lat longitude:(NSString *)lon
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:lon, @"long", lat, @"lat", nil];
    [self.appDelegate.sinaWeibo requestWithURL:@"place/nearby_timeline.json"
                                        params:mDic
                                    httpMethod:@"GET"
                                   finishBlock:^(SinaWeiboRequest *request, id result) {
                                       [self loadDataFinish:result];
                                   } failBlock:^(SinaWeiboRequest *request, NSError *error) {
                                       [self showFailHUD:@"请求网络失败" withDelayHideTime:2 withView:self.view];
                                   }];
}

//5.解析成model
-(void)loadDataFinish:(NSDictionary *)result
{
    NSArray *status = result[@"statuses"];
    for (int i=0; i<status.count; i++) {
        WeiboModel *model = [[WeiboModel alloc] initWithDictionary:status[i] error:NULL];
        
        //6.把WeiboModel和WeiboAnnotation建立联系
        WeiboAnnotation *wbAtt = [[WeiboAnnotation alloc] init];
        wbAtt.weiboModel = model;
        
        //7.把WeiboAnnotation添加到地图上面
        [self.mapView addAnnotation:wbAtt];
    }
}


#pragma mark - MKMapViewDelegate
//1.定位, 用户的位置已经更新
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D coor2D = userLocation.location.coordinate;

    //显示的跨度
    MKCoordinateSpan span = {0.05, 0.05};
    MKCoordinateRegion region = MKCoordinateRegionMake(coor2D, span);
    //2.设置地图显示的区域
    [self.mapView setRegion:region animated:YES];

    //3.拿到经纬度
    NSString *lon = [NSString stringWithFormat:@"%f", coor2D.longitude];
    NSString *lat = [NSString stringWithFormat:@"%f", coor2D.latitude];

    [self loadNearWeibo:lat longitude:lon];
    //NSLog(@"%@--%@", lon, lat);
}

//8.绘制MKAnnotationView
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //如果是自己的annotation,就不需要MKAnnotationView
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    static NSString *strID = @"kWeoboMKAnnotationViewID";
    //9.定制WeiboAnnotationView
    WeiboAnnotationView *anntView = (WeiboAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:strID];
    if (!anntView) {
        anntView = [[WeiboAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:strID];
    }
    
    return anntView;
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

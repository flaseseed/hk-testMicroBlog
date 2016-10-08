//
//  LocationSelfTableViewController.m
//  blog
//
//  Created by hk-seed on 1/21/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "LocationSelfTableViewController.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"

@interface LocationSelfTableViewController ()
{
    CLLocationManager *locationManager;
}

@property(nonatomic, strong)NSArray *dataArr;

@end

@implementation LocationSelfTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我在这里";
    //返回
    ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    button.backImgName = @"titlebar_button_back_9@2x.png";
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //1.定位，拿到经纬度
    //2.从新浪服务器获取地标信息，当成数据源
    //3.用户选择地标信息
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
        
        //如果程序定位设置不是 使用应用程序期间，则设置为 使用应用程序期间
        if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse) {
            [locationManager requestWhenInUseAuthorization];
        }
    
    //设置精确度，精度越高越耗电
    [locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    [locationManager startUpdatingLocation];
    
    //定位频率，每隔10米定位一次
    CLLocationDistance distance = 10.0;
    locationManager.distanceFilter = distance;
    
    self.tableView.rowHeight = 60;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    
    for (CLLocation *newLocation in locations) {
        //拿到经纬度
        float latitude = newLocation.coordinate.latitude;
        float longitude = newLocation.coordinate.longitude;
        //停止定位
        [manager stopUpdatingLocation];
        
        
        NSMutableDictionary *mDic = [[NSMutableDictionary alloc] init];
        [mDic setObject:[NSString stringWithFormat:@"%f", latitude] forKey:@"lat"];
        [mDic setObject:[NSString stringWithFormat:@"%f", longitude] forKey:@"long"];
        //访问接口 拿到反编码的位置信息
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate.sinaWeibo requestWithURL:@"place/nearby/pois.json"
                                       params:mDic
                                   httpMethod:@"GET"
                                  finishBlock:^(SinaWeiboRequest *request, id result) {
                                      
                                      NSArray *poisArr = result[@"pois"];
                                      self.dataArr = poisArr;
                                      [self.tableView reloadData];
                                      
                                  } failBlock:NULL];
    }
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kLocationCellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"kLocationCellID"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [[ThemeManager shareManager] loadColorWithKeyName:@"More_Item_Text_color"];
        cell.detailTextLabel.textColor = [[ThemeManager shareManager] loadColorWithKeyName:@"More_Item_Text_color"];
    }
    
    NSDictionary *dic = self.dataArr[indexPath.row];
    NSString *title = [dic objectForKey:@"title"];
    NSString *address = [dic objectForKey:@"address"];
    NSString *icon = [dic objectForKey:@"icon"];
    
    if (![icon isKindOfClass:[NSNull class]]) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:[UIImage imageNamed:@"page_image_loading"]];
        
        //固定cell.imageView的大小（第二种方法：子类化cell，重写layoutSubview方法给imageView的frame赋值）
        CGSize itemSize = CGSizeMake(44, 44);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    if (![title isKindOfClass:[NSNull class]]) {
        cell.textLabel.text = title;
    }
    
    if (![address isKindOfClass:[NSNull class]]) {
        cell.detailTextLabel.text = address;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectLocation) {
        _selectLocation(self.dataArr[indexPath.row]);
    }
    
    [self backAction];
}

@end

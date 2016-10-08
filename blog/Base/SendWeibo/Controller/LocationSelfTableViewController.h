//
//  LocationSelfTableViewController.h
//  blog
//
//  Created by hk-seed on 1/21/16.
//  Copyright © 2016 george. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^SelectedLocationDone)(NSDictionary *);

@interface LocationSelfTableViewController : UITableViewController<CLLocationManagerDelegate>

@property(nonatomic, copy)SelectedLocationDone selectLocation;

@end

//
//  WeiboAnnotation.h
//  84班微博
//
//  Created by wenyuan on 1/22/16.
//  Copyright © 2016 george. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "WeiboModel.h"

@interface WeiboAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic, strong)WeiboModel *weiboModel;

@end

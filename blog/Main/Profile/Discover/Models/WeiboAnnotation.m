//
//  WeiboAnnotation.m
//  84班微博
//
//  Created by wenyuan on 1/22/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation

-(void)setWeiboModel:(WeiboModel *)weiboModel
{
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        
        //把WeiboModel里面的经纬度赋值给WeiboAnnotation对象
        NSArray *coordinateArr = weiboModel.geo[@"coordinates"];
        if (coordinateArr.count == 2) {
            float lat = [coordinateArr[0] floatValue];
            float lon = [coordinateArr[1] floatValue];
            
            self.coordinate = CLLocationCoordinate2DMake(lat, lon);
        }
        
    }
}

@end

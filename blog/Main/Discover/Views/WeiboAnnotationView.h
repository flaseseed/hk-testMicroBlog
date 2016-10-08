//
//  WeiboAnnotationView.h
//  84班微博
//
//  Created by wenyuan on 1/22/16.
//  Copyright © 2016 george. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "WeiboAnnotation.h"

@interface WeiboAnnotationView : MKAnnotationView
{
    UIImageView *userImgView;       //头像
    UIImageView *weiboImgView;      //微博图片
    UILabel *textLabel;             //微博内容
}

@end

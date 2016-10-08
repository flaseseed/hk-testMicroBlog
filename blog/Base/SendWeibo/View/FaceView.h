//
//  FaceView.h
//  blog
//
//  Created by hk-seed on 1/21/16.
//  Copyright © 2016 george. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImgFaceView.h"

@interface FaceView : UIView <UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UIPageControl *pgCtrl;
}

@property (nonatomic, weak) ImgFaceView *imgFaceView;

@end

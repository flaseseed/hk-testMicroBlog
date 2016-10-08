//
//  ImgFaceView.h
//  blog
//
//  Created by hk-seed on 1/21/16.
//  Copyright © 2016 george. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImgFaceView : UIView
{
    NSMutableArray *faceItemArr;
    
    UIImageView *magnifierView;
    
    NSInteger lastTouchIndex;
}

@property (nonatomic, assign) NSInteger pageCount;

//传值kvo监听对象
@property(nonatomic, copy)NSString *faceName_kvo;

@end

//
//  ThemeImgView.h
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImgView : UIImageView

@property(nonatomic, copy)NSString *imgName;

//处理图片拉伸
@property(nonatomic, assign)UIEdgeInsets edgeInset;

@end

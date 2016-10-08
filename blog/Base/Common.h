//
//  Common.h
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#ifndef Common_h
#define Common_h

#import "ThemeManager.h"
#import "ThemeLabel.h"
#import "ThemeButton.h"
#import "ThemeImgView.h"

#import "UIViewExt.h"

//新浪认证信息
#define kAppKey             @"4016462547"
#define kAppSecret          @"718b5b1ec06e4baf850e90b86759b6f8"
//#define kAppRedirectURI     @"http://www.hongkung.com"


//#define kAppKey @"828444077"
//#define kAppSecret @"f01c2a4000728636bc01facafa5264d0"
#define kAppRedirectURI @"http://www.hongkung.com"

//屏幕宽高
#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight       [UIScreen mainScreen].bounds.size.height

#define iOS8 ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)

#endif

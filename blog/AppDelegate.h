//
//  AppDelegate.h
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMDrawerController.h"
#import "SinaWeibo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong)MMDrawerController *drawerCtrl;
@property(nonatomic, strong)SinaWeibo *sinaWeibo;


- (void)storeAuthData;
- (void)removeAuthData;

@end


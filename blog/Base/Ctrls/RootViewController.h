//
//  RootViewController.h
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface RootViewController : UIViewController

-(AppDelegate *)appDelegate;

#pragma mark - HUD
-(void)showSuccessHUD:(NSString *)title withDelayHideTime:(NSTimeInterval)delay;
-(void)showFailHUD:(NSString *)title withDelayHideTime:(NSTimeInterval)delay withView:(UIView *)view;

@end

//
//  DiscoverViewController.h
//  84班微博
//
//  Created by wenyuan on 1/22/16.
//  Copyright © 2016 george. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"

@interface DiscoverViewController : RootViewController

@property (weak, nonatomic) IBOutlet UIButton *nearWeiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *nearUserBtn;
@property (weak, nonatomic) IBOutlet ThemeLabel *nearWeiboLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *nearUserLabel;

@end

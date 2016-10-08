//
//  RightViewController.h
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightViewController : UIViewController
@property (weak, nonatomic) IBOutlet ThemeButton *writeBtn;
@property (weak, nonatomic) IBOutlet ThemeButton *camaraBtn;
@property (weak, nonatomic) IBOutlet ThemeButton *photoBtn;
@property (weak, nonatomic) IBOutlet ThemeButton *videoBtn;
@property (weak, nonatomic) IBOutlet ThemeButton *multBtn;
@property (weak, nonatomic) IBOutlet ThemeButton *locationBtn;

- (IBAction)btnAction:(id)sender;

@end

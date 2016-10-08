//
//  RightViewController.m
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "RightViewController.h"
#import "SendViewController.h"
#import "RootNavigationController.h"

@interface RightViewController ()

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _writeBtn.imgName = @"newbar_icon_1@2x.png";
    _camaraBtn.imgName = @"newbar_icon_2@2x.png";
    _photoBtn.imgName = @"newbar_icon_3@2x.png";
    _videoBtn.imgName = @"newbar_icon_2@2x.png";
    _multBtn.imgName = @"newbar_icon_4@2x.png";
    _locationBtn.imgName = @"newbar_icon_5@2x.png";
}

- (IBAction)btnAction:(id)sender {
    //
    UIButton *button = sender;
    switch (button.tag) {
        case 200:
                {
            SendViewController *sendVC = [[SendViewController alloc] init];
                    RootNavigationController *root = [[RootNavigationController alloc] initWithRootViewController:sendVC];
            [self presentViewController:root animated:YES completion:NULL];
                }
            
            break;
            
        default:
            break;
    }
    
    
}
@end

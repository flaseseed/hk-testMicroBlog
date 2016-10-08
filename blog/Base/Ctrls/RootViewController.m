//
//  RootViewController.m
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "RootViewController.h"
#import "MBProgressHUD.h"

@interface RootViewController () 

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createBackButton];
}

-(void)createBackButton
{
    //返回
    NSUInteger count = self.navigationController.viewControllers.count;
    if (count > 1) {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        button.backImgName = @"titlebar_button_back_9@2x.png";
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUInteger count = self.navigationController.viewControllers.count;
    if (count > 1) {
        //禁止滑动
        [[self appDelegate].drawerCtrl setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    }else{
        [[self appDelegate].drawerCtrl setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    }
}

-(AppDelegate *)appDelegate
{
    return [[UIApplication sharedApplication] delegate];
}

#pragma mark - HUD
-(void)showSuccessHUD:(NSString *)title withDelayHideTime:(NSTimeInterval)delay
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    HUD.labelText = title;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    [HUD hide:YES afterDelay:delay];
}

-(void)showFailHUD:(NSString *)title withDelayHideTime:(NSTimeInterval)delay withView:(UIView *)view
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.labelText = title;
    HUD.mode = MBProgressHUDModeText;
    [HUD hide:YES afterDelay:delay];
}


@end

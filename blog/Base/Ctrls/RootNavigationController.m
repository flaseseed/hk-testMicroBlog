//
//  RootNavigationController.m
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "RootNavigationController.h"

@interface RootNavigationController ()

@end

@implementation RootNavigationController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

-(void)themeDidChange
{
    //设置背景，因为img高度小于64，所以需要自己生成高度64的图片
    UIImage *bgImg = [[ThemeManager shareManager] loadImageWithImgName:@"mask_titlebar@2x.png"];
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(bgImg.CGImage, CGRectMake(0, 0, kScreenWidth, 64));
    
    [self.navigationBar setBackgroundImage:[UIImage imageWithCGImage:imageRef] forBarMetrics:UIBarMetricsDefault];
    
    CGImageRelease(imageRef);
    
    //标题的字体颜色
    UIColor *titleColor = [[ThemeManager shareManager] loadColorWithKeyName:@"Mask_Title_color"];
    NSDictionary *textAttr = @{
                               NSForegroundColorAttributeName : titleColor,
                               NSFontAttributeName : [UIFont boldSystemFontOfSize:20]
                               };
    self.navigationBar.titleTextAttributes = textAttr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self themeDidChange];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

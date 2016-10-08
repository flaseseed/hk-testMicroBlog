//
//  MoreTableViewController.m
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "MoreTableViewController.h"
#import "AppDelegate.h"

@interface MoreTableViewController ()
{
    __weak IBOutlet ThemeLabel *themeNameLabel;
    __weak IBOutlet ThemeLabel *row1Label;
    __weak IBOutlet ThemeLabel *row2Label;
    __weak IBOutlet ThemeLabel *row3Label;
    __weak IBOutlet ThemeLabel *row4Label;
    
    __weak IBOutlet ThemeImgView *row1ImgView;
    __weak IBOutlet ThemeImgView *row2ImgView;
    __weak IBOutlet ThemeImgView *row3ImgView;
}
@end

@implementation MoreTableViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

-(void)themeDidChange
{
    self.tableView.backgroundColor = [[ThemeManager shareManager] loadColorWithKeyName:@"More_Item_color"];
    self.tableView.separatorColor = [[ThemeManager shareManager] loadColorWithKeyName:@"More_Item_Line_color"];
  
    themeNameLabel.text = [ThemeManager shareManager].themeName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self themeDidChange];
    
    themeNameLabel.colorKeyName = @"More_Item_Text_color";
    row1Label.colorKeyName = @"More_Item_Text_color";
    row2Label.colorKeyName = @"More_Item_Text_color";
    row3Label.colorKeyName = @"More_Item_Text_color";
    row4Label.colorKeyName = @"More_Item_Text_color";
    
    row1ImgView.imgName = @"more_icon_theme@2x.png";
    row2ImgView.imgName = @"more_icon_account@2x.png";
    row3ImgView.imgName = @"more_icon_feedback@2x.png";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        [appDelegate.sinaWeibo logOut];
    }
}


@end

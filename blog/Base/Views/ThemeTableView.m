//
//  ThemeTableView.m
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "ThemeTableView.h"

@implementation ThemeTableView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)themeDidChange
{
    self.backgroundColor = [[ThemeManager shareManager] loadColorWithKeyName:@"More_Item_color"];
    self.separatorColor = [[ThemeManager shareManager] loadColorWithKeyName:@"More_Item_Line_color"];
}

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setupConfig];
    }
    
    return self;
}

-(void)awakeFromNib
{
    [self setupConfig];
}

-(void)setupConfig
{
    [self themeDidChange];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:kThemeDidChangeNotification object:nil];
}

@end

//
//  ThemeButton.m
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "ThemeButton.h"

@implementation ThemeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupConfig];
    }
    return self;
}

-(void)awakeFromNib
{
    [self setupConfig];
}

-(void)setImgName:(NSString *)imgName
{
    if (_imgName != imgName) {
        _imgName = [imgName copy];
        
        [self themeDidChange];
    }
}

-(void)setHighLightImgName:(NSString *)highLightImgName
{
    if (_highLightImgName != highLightImgName) {
        _highLightImgName = [highLightImgName copy];
        
        [self themeDidChange];
    }
}

-(void)setBackImgName:(NSString *)backImgName
{
    if (_backImgName != backImgName) {
        _backImgName = [backImgName copy];
        
        [self themeDidChange];
    }
}

-(void)setBackHighLightImgName:(NSString *)backHighLightImgName
{
    if (_backHighLightImgName != backHighLightImgName) {
        _backHighLightImgName = [backHighLightImgName copy];
        
        [self themeDidChange];
    }
}

-(void)setupConfig
{
    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeDidChange) name:kThemeDidChangeNotification object:nil];
}



-(void)themeDidChange
{
    UIImage *img = [[ThemeManager shareManager] loadImageWithImgName:_imgName];
    UIImage *hImg = [[ThemeManager shareManager] loadImageWithImgName:_highLightImgName];
    UIImage *backImg = [[ThemeManager shareManager] loadImageWithImgName:_backImgName];
    UIImage *backHighImg = [[ThemeManager shareManager] loadImageWithImgName:_backHighLightImgName];
    
    [self setImage:img forState:UIControlStateNormal];
    [self setImage:hImg forState:UIControlStateHighlighted];
    [self setBackgroundImage:backImg forState:UIControlStateNormal];
    [self setBackgroundImage:backHighImg forState:UIControlStateHighlighted];
}


@end

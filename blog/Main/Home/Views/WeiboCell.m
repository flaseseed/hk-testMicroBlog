//
//  WeiboCell.m
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+TimeAgo.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "ZoomImageView.h"
#import "UIView+ViewController.h"
#import "CommentViewController.h"

@implementation WeiboCell

- (void)awakeFromNib {
    //设置头像的圆角、边框
    userHeadImg.layer.cornerRadius = 10;
    userHeadImg.layer.borderWidth = 0.5;
    userHeadImg.layer.borderColor = [UIColor grayColor].CGColor;
    userHeadImg.layer.masksToBounds = YES;
    
    nickNameLabel.colorKeyName = @"Timeline_Name_color";
    timeLabel.colorKeyName = @"Timeline_TimeNew_color";
    sourceLabel.colorKeyName = @"Timeline_Retweet_color";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setLayout:(WeiboCellLayout *)layout
{
    if (_layout != layout) {
        _layout = layout;
        
        //头像、昵称赋值
        [userHeadImg sd_setImageWithURL:[NSURL URLWithString:_layout.weiboModel.user.profile_image_url]];
        nickNameLabel.text = _layout.weiboModel.user.screen_name;
        timeLabel.text = [self parseDateStr:_layout.weiboModel.created_at];
        sourceLabel.text = [self parseWeoboSource:_layout.weiboModel.source];
        [rePostButton setTitle:[NSString stringWithFormat:@"转发%d",_layout.weiboModel.reposts_count] forState:UIControlStateNormal];
        [commentButton setTitle:[NSString stringWithFormat:@"评论%d",_layout.weiboModel.comments_count] forState:UIControlStateNormal];
        [commentButton addTarget:self action:@selector(cmmtVCshow) forControlEvents:UIControlEventTouchUpInside];
        [likeButton setTitle:[NSString stringWithFormat:@"赞%d",_layout.weiboModel.attitudes_count] forState:UIControlStateNormal];
        
        [likeButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        //微博正文赋值
        self.weiboTextLabel.text = _layout.weiboModel.text;
        
        /*
        //微博图片赋值
        if (_layout.weiboModel.thumbnail_pic) {
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:_layout.weiboModel.thumbnail_pic]];
        }
        */
#warning 修改
        //微博多图赋值
        for (int i=0; i<self.layout.weiboModel.pic_urls.count; i++) {
            ZoomImageView *imgView = self.imgViewArr[i];
            NSString *imgUrlStr = self.layout.weiboModel.pic_urls[i][@"thumbnail_pic"];
            [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
            
            NSMutableString *url = [NSMutableString stringWithString:imgUrlStr];
            
            NSRange range = [imgUrlStr rangeOfString:@"thumbnail"];
            
            [url replaceCharactersInRange:range withString:@"large"];
            
            imgView.urlString = url;
            
            //拿到拓展名 判断拓展名是否为gif
            NSString *str = [imgUrlStr pathExtension];
            if ([str isEqualToString:@"gif"]) {
                imgView.isGif = YES;
            }else
            {
                imgView.isGif = NO;
            }
            
        }
        
        if (_layout.weiboModel.retweeted_status) {
            //转发微博背景赋值
            self.retweetBgImgView.edgeInset = UIEdgeInsetsMake(10, 30, 10, 10);
            self.retweetBgImgView.imgName = @"timeline_rt_border_9@2x.png";

            //转发微博的文字赋值
            self.retweetTextLabel.text = _layout.weiboModel.retweeted_status.text;
            
            /*
            //转发微博的图片赋值
            if (_layout.weiboModel.retweeted_status.thumbnail_pic) {
                [self.retweetImgView sd_setImageWithURL:[NSURL URLWithString:_layout.weiboModel.retweeted_status.thumbnail_pic]];
            }
            */

            //转发微博多图赋值
            for (int i=0; i<self.layout.weiboModel.retweeted_status.pic_urls.count; i++) {
                ZoomImageView *retweetImgView = self.retweetImgViewArr[i];
                NSString *imgUrlStr = self.layout.weiboModel.retweeted_status.pic_urls[i][@"thumbnail_pic"];
                [retweetImgView sd_setImageWithURL:[NSURL URLWithString:imgUrlStr]];
                
                NSMutableString *url = [NSMutableString stringWithString:imgUrlStr];
                
                NSRange range = [imgUrlStr rangeOfString:@"thumbnail"];
                
                [url replaceCharactersInRange:range withString:@"large"];
                
                retweetImgView.urlString = url;
                
                NSString *str = [imgUrlStr pathExtension];
                if ([str isEqualToString:@"gif"]) {
                    retweetImgView.isGif = YES;
                }else
                {
                    retweetImgView.isGif = NO;
                }
            }
        }
        
        //所有cell的subview赋值frame
        [self setCellSubviewFrame];
    }
}

//不管微博 有没有图片或者转发微博，cell的重用需要给subview重新赋值frame
-(void)setCellSubviewFrame
{
    self.weiboTextLabel.frame = _layout.textFrame;
    //self.imgView.frame = _layout.imgFrame;
    self.retweetBgImgView.frame = _layout.retweetBgFrame;
    self.retweetTextLabel.frame = _layout.retweetTextFrame;
    //self.retweetImgView.frame = _layout.retweetImgFrame;
    
    for (int i=0; i<self.imgViewArr.count; i++) {
        ZoomImageView *imgView = self.imgViewArr[i];
        imgView.frame = [self.layout.imgFrameArr[i] CGRectValue];
        
        ZoomImageView *retweetImgView = self.retweetImgViewArr[i];
        retweetImgView.frame = [self.layout.retweetImgFrameArr[i] CGRectValue];
    }
}

#pragma mark - utils
//Sat Oct 24 14:40:05 +0800 2015
//
-(NSString *)parseDateStr:(NSString *)dateStr
{
    //创建格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //日期的格式
    NSString *format = @"E M d HH:mm:ss Z yyyy";
    [formatter setDateFormat:format];
    
    //设置本地化时间
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:locale];
    
    NSDate *date = [formatter dateFromString:dateStr];
    return [date timeAgo];
}

//<a href="http://app.weibo.com/t/feed/21gIP7" rel="nofollow">华为 Ascend Mate</a>
-(NSString *)parseWeoboSource:(NSString *)sourceStr
{
    NSUInteger start = [sourceStr rangeOfString:@">"].location;
    NSUInteger end = [sourceStr rangeOfString:@"<" options:NSBackwardsSearch].location;
    
    if (start != NSNotFound && end != NSNotFound) {
        return [sourceStr substringWithRange:NSMakeRange(start+1, end-start-1)];
    }else{
        return sourceStr;
    }
}


#pragma mark - 懒加载
@synthesize weiboTextLabel = _weiboTextLabel;
//@synthesize imgView = _imgView;
@synthesize retweetBgImgView = _retweetBgImgView;
@synthesize retweetTextLabel = _retweetTextLabel;
//@synthesize retweetImgView = _retweetImgView;

@synthesize imgViewArr = _imgViewArr;
@synthesize retweetImgViewArr = _retweetImgViewArr;

-(UILabel *)weiboTextLabel
{
    if (!_weiboTextLabel) {
        _weiboTextLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
        _weiboTextLabel.wxLabelDelegate = self;
        _weiboTextLabel.linespace = kTextLineSpace;
        _weiboTextLabel.numberOfLines = 0;
        _weiboTextLabel.font = [UIFont systemFontOfSize:kTextSize];
        [self.contentView addSubview:_weiboTextLabel];
    }
    
    return _weiboTextLabel;
}

/*
-(UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imgView];
    }
    
    return _imgView;
}
*/

-(ThemeImgView *)retweetBgImgView
{
    if (!_retweetBgImgView) {
        _retweetBgImgView = [[ThemeImgView alloc] init];
        [self.contentView insertSubview:_retweetBgImgView atIndex:0];
    }
    
    return _retweetBgImgView;
}

-(UILabel *)retweetTextLabel
{
    if (!_retweetTextLabel) {
        _retweetTextLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
        _retweetTextLabel.wxLabelDelegate = self;
        _retweetTextLabel.linespace = kRetweetTextLineSpace;
        _retweetTextLabel.numberOfLines = 0;
        _retweetTextLabel.font = [UIFont systemFontOfSize:kRetweetTextSize];
        [self.contentView addSubview:_retweetTextLabel];
    }
    
    return _retweetTextLabel;
}

/*
-(UIImageView *)retweetImgView
{
    if (!_retweetImgView) {
        _retweetImgView = [[UIImageView alloc] init];
        _retweetImgView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_retweetImgView];
    }
    
    return _retweetImgView;
}
*/

-(NSMutableArray *)imgViewArr
{
    if (!_imgViewArr) {
        _imgViewArr = [[NSMutableArray alloc] init];
        
        for (int i=0; i<9; i++) {
            ZoomImageView *imgView = [[ZoomImageView alloc] init];
            [self.contentView addSubview:imgView];

            [_imgViewArr addObject:imgView];
        }
    }
    
    return _imgViewArr;

}

-(NSMutableArray *)retweetImgViewArr
{
    if (!_retweetImgViewArr) {
        _retweetImgViewArr = [[NSMutableArray alloc] init];
        
        for (int i=0; i<9; i++) {
            ZoomImageView *rtImgView = [[ZoomImageView alloc] init];
            [self.contentView addSubview:rtImgView];
            
            [_retweetImgViewArr addObject:rtImgView];
        }
    }
    
    return _retweetImgViewArr;
}


#pragma mark - WXLabel Delegate
//返回正则表达式匹配的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel {
    
    NSString *regEx1 = @"http://([a-zA-Z0-9_.-]+(/)?)+";
    NSString *regEx2 = @"@[\\w.-]{2,30}";
    NSString *regEx3 = @"#[^#]+#";
    
    NSString *regEx =
    [NSString stringWithFormat:@"(%@)|(%@)|(%@)", regEx1, regEx2, regEx3];
    
    return regEx;
}

- (NSString *)imagesOfRegexStringWithWXLabel:(WXLabel *)wxLabel
{
    return @"\\[\\w+\\]";
}

- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context
{
    NSLog(@"%@", context);
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:context]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:context]];
    }
}

//设置链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
    
    return [[ThemeManager shareManager] loadColorWithKeyName:@"Link_color"];
}

- (void)likeAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        sender.backgroundColor = [UIColor clearColor];
        [sender setTitle:@"👍" forState:UIControlStateSelected];
//        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        
//        [delegate.sinaWeibo requestWithURL:@"interest/like_count.json" params:nil httpMethod:@"GET" finishBlock:^(SinaWeiboRequest *request, id result) {
//            NSLog(@"请求成功%@", result);
//        } failBlock:^(SinaWeiboRequest *request, NSError *error) {
//            NSLog(@"%@", error);
//        }];
        
    }
    
}

- (void)cmmtVCshow
{
    UIStoryboard *stbd = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    CommentViewController *cmmtCtrl = [stbd instantiateViewControllerWithIdentifier:@"kCommentViewControllerID"];
    cmmtCtrl.weiboLayout = self.layout;
    [self.viewController.navigationController pushViewController:cmmtCtrl animated:YES];
}

//1、配置微博内容的frame
//2、处理时间和来源
//3、超链接的查找（正则表达式）
//4、超链接的打开

@end

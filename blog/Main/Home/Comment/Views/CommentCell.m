//
//  CommentCell.m
//  blog
//
//  Created by hk-seed on 1/19/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+TimeAgo.h"

@implementation CommentCell

- (void)awakeFromNib {
    
    _nickNameLabel.colorKeyName = @"Timeline_Name_color";
    _timeLabel.colorKeyName = @"Timeline_TimeNew_color";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLayout:(CommentLayout *)layout
{
    if (_layout != layout) {
        _layout = layout;
        
        [_userImageView sd_setImageWithURL:[NSURL URLWithString:_layout.cmmtModel.user.profile_image_url]];
        _nickNameLabel.text = _layout.cmmtModel.user.screen_name;
        _timeLabel.text = [self parseDateStr:_layout.cmmtModel.created_at];
        self.commentLabel.text = _layout.cmmtModel.text;
        
        self.commentLabel.frame = _layout.textFrame;

    }
}

@synthesize commentLabel = _commentLabel;
-(WXLabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [[WXLabel alloc] initWithFrame:CGRectZero];
        _commentLabel.wxLabelDelegate = self;
        _commentLabel.linespace = kCmmtTextLinespace;
        _commentLabel.numberOfLines = 0;
        _commentLabel.font = [UIFont systemFontOfSize:kCmmtFontSize];
        [self.contentView addSubview:_commentLabel];
    }
    
    return _commentLabel;
}

#pragma mark - utils
//Sat Oct 24 14:40:05 +0800 2015
-(NSString *)parseDateStr:(NSString *)dateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *format = @"E M d HH:mm:ss Z yyyy";
    [formatter setDateFormat:format];
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [formatter setLocale:locale];
    
    NSDate *date = [formatter dateFromString:dateStr];
    return [date timeAgo];
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
    return @"\\[\\w+\\]{1,30}";
}

- (void)toucheEndWXLabel:(WXLabel *)wxLabel withContext:(NSString *)context
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:context]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:context]];
    }
}

//设置链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel {
    
    return [[ThemeManager shareManager] loadColorWithKeyName:@"Link_color"];
}
@end

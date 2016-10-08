//
//  WeiboCellLayout.m
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "WeiboCellLayout.h"
#import "WXLabel.h"

@implementation WeiboCellLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _imgFrameArr = [[NSMutableArray alloc] init];
        _retweetImgFrameArr = [[NSMutableArray alloc] init];
        
        for (int i=0; i<9; i++) {
            [_imgFrameArr addObject:[NSValue valueWithCGRect:CGRectZero]];
            [_retweetImgFrameArr addObject:[NSValue valueWithCGRect:CGRectZero]];
        }
    }
    return self;
}

-(void)setWeiboModel:(WeiboModel *)weiboModel
{
    if (_weiboModel != weiboModel) {
        _weiboModel = weiboModel;
        
        [self layoutFrame];
    }
}

-(void)layoutFrame
{
    CGFloat cellHeight = kCellHeadHeight;
    
    //1.微博正文的frame（固定宽度与字体大小）
    CGFloat textWidth = kScreenWidth-kSpaceSize*2;
    
    /*
    NSDictionary *attributeDic = @{
                                   NSFontAttributeName : [UIFont systemFontOfSize:kTextSize],
                                   NSForegroundColorAttributeName : [UIColor blackColor]
                                   };
    CGRect frame = [_weiboModel.text boundingRectWithSize:CGSizeMake(textWidth, 999)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributeDic
                                                  context:nil];
    */
    CGFloat textHeight = [WXLabel getTextHeight:kTextSize width:textWidth text:_weiboModel.text linespace:kTextLineSpace];
    self.textFrame = CGRectMake(kSpaceSize, kCellHeadHeight+kSpaceSize, textWidth, textHeight);
    cellHeight += CGRectGetHeight(self.textFrame)+kSpaceSize*2;
    
    /*
    //2.图片的frame
    if (_weiboModel.thumbnail_pic) {
        CGFloat imgX = CGRectGetMinX(self.textFrame);
        CGFloat imgY = CGRectGetMaxY(self.textFrame)+kSpaceSize;
        
        self.imgFrame = CGRectMake(imgX, imgY, kWeiboImgWidth, kWeiboImgHeight);
        cellHeight += CGRectGetHeight(self.imgFrame)+kSpaceSize;
    }
    */
    
    
    //2.微博多图的frame（0-9张数量不定）
    int row = 0, column = 0;
    
    CGFloat imgX = CGRectGetMinX(self.textFrame);
    CGFloat imgY = CGRectGetMaxY(self.textFrame)+kSpaceSize;
    CGFloat imgSize = (textWidth - kMultipleImgSpace*2)/3;      //一张图片的大小
    CGRect imgFrame = CGRectZero;
    for (int i=0; i<_weiboModel.pic_urls.count; i++) {
        //计算每张图片的frame
        row = i/3;
        column = i%3;
        imgFrame = CGRectMake(imgX+column*(imgSize+kMultipleImgSpace), imgY+row*(imgSize+kMultipleImgSpace), imgSize, imgSize);
        [self.imgFrameArr replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:imgFrame]];
    }
    /*
     计算多图所占用的行高（0-9）
         1、如果count为0，则cellHeight加0；
         2、如果count大于0，文字下面与图片之间的上下间隔只有1个kSpaceSize，kSpaceSize取值范围（0-1）
         3、图片与图片之间的间隔kMultipleImgSpace为 line-1，2行才有1个上下间隔，取值范围为（0-2）
     */
    NSInteger line = (_weiboModel.pic_urls.count+2)/3;  //+2 是区分 count>0 的小技巧
    cellHeight += line*imgSize + kMultipleImgSpace*(MAX(0, line-1)) + kSpaceSize*(MAX(0, MIN(line, 1)));
    
    
    //如果有转发微博
    if (_weiboModel.retweeted_status) {
        
        //3.转发微博背景 初始frame
        CGFloat retweetBgX = CGRectGetMinX(self.textFrame);
        CGFloat retweetBgY = CGRectGetMaxY(self.textFrame)+kRetweetBgAlignY;
        CGFloat retweetBgWidth = CGRectGetWidth(self.textFrame);
        CGFloat retweetBgHeight = kSpaceSize;
        
        //4.转发微博的文字frame
        CGFloat retweetTextX = retweetBgX+kSpaceSize;
        CGFloat retweetTextY = retweetBgY+kSpaceSize;
        CGFloat retweetTextWidth = retweetBgWidth-kSpaceSize*2;
        
        /*
        NSDictionary *attributeDic = @{
                                       NSFontAttributeName : [UIFont systemFontOfSize:kRetweetTextSize],
                                       NSForegroundColorAttributeName : [UIColor blackColor]
                                       };
        CGRect retweetTextFrame = [_weiboModel.retweeted_status.text
                        boundingRectWithSize:CGSizeMake(retweetTextWidth, 999)
                        options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:attributeDic
                        context:nil];
        */
        CGFloat retweetTextHeight = [WXLabel getTextHeight:kRetweetTextSize width:retweetTextWidth text:_weiboModel.retweeted_status.text linespace:kRetweetTextLineSpace];
        self.retweetTextFrame = CGRectMake(retweetTextX, retweetTextY, retweetTextWidth, retweetTextHeight);
        retweetBgHeight += CGRectGetHeight(self.retweetTextFrame)+kSpaceSize;
        
        /*
        //5.转发微博的图片frame
        if (_weiboModel.retweeted_status.thumbnail_pic) {
            self.retweetImgFrame = CGRectMake(retweetTextX, CGRectGetMaxY(self.retweetTextFrame)+kSpaceSize, kWeiboImgWidth, kWeiboImgHeight);
            retweetBgHeight += CGRectGetHeight(self.retweetImgFrame)+kSpaceSize;
        }
        */
        
        //5.转发微博多图frame
        CGFloat retweetImgX = CGRectGetMinX(self.retweetTextFrame);
        CGFloat retweetImgY = CGRectGetMaxY(self.retweetTextFrame)+kSpaceSize;
        CGFloat retweetImgSize = (retweetTextWidth - kMultipleImgSpace*2)/3;
        CGRect retweetImgFrame = CGRectZero;
        for (int i=0; i<_weiboModel.retweeted_status.pic_urls.count; i++) {
            row = i/3;
            column = i%3;
            retweetImgFrame = CGRectMake(retweetImgX+column*(retweetImgSize+kMultipleImgSpace), retweetImgY+row*(retweetImgSize+kMultipleImgSpace), retweetImgSize, retweetImgSize);
            [self.retweetImgFrameArr replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:retweetImgFrame]];
        }
        NSInteger line = (_weiboModel.retweeted_status.pic_urls.count+2)/3;
        retweetBgHeight += line*retweetImgSize + (MAX(0, line-1))*kMultipleImgSpace + kSpaceSize*(MAX(0, MIN(line, 1)));
        
        //6.转发微博背景 最终frame
        self.retweetBgFrame = CGRectMake(retweetBgX, retweetBgY, retweetBgWidth, retweetBgHeight);
        cellHeight += CGRectGetHeight(self.retweetBgFrame)+kRetweetBgAlignY;
        
    }
    
    //cell的高度
    self.cellHeight = cellHeight + kBottomHeight;
}

@end

//
//  WeiboCell.h
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboCellLayout.h"
#import "WXLabel.h"

@interface WeiboCell : UITableViewCell <WXLabelDelegate>
{
    __weak IBOutlet UIImageView *userHeadImg;
    __weak IBOutlet ThemeLabel *nickNameLabel;
    __weak IBOutlet ThemeLabel *timeLabel;
    __weak IBOutlet ThemeLabel *sourceLabel;
    __weak IBOutlet UIButton *rePostButton;
    __weak IBOutlet UIButton *commentButton;
    __weak IBOutlet UIButton *likeButton;
    
}

@property(nonatomic, strong)WeiboCellLayout *layout;

@property(nonatomic, strong, readonly)WXLabel *weiboTextLabel;          //微博正文
//@property(nonatomic, strong, readonly)UIImageView *imgView;             //微博图片
@property(nonatomic, strong, readonly)ThemeImgView *retweetBgImgView;   //转发微博背景
@property(nonatomic, strong, readonly)WXLabel *retweetTextLabel;        //转发微博正文
//@property(nonatomic, strong, readonly)UIImageView *retweetImgView;      //转发微博图片


@property(nonatomic, strong, readonly)NSMutableArray *imgViewArr;       //微博多图数组
@property(nonatomic, strong, readonly)NSMutableArray *retweetImgViewArr;//转发微博多图数组

@end

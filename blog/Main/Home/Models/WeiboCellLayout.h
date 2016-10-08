//
//  WeiboCellLayout.h
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiboModel.h"

#define kCellHeadHeight     65      //cell头视图的高度
#define kSpaceSize          15      //间距
#define kTextSize           16      //微博字体大小
#define kRetweetTextSize    15      //转发微博字体大小
#define kRetweetBgAlignY    5       //转发微博背景起始Y坐标离微博文字底部的距离（调整美观度）

#define kTextLineSpace  6           //微博正文行间距
#define kRetweetTextLineSpace  4    //转发微博正文行间距
#define kBottomHeight  25

//微博图片的宽高（一张图片）
//#define kWeiboImgWidth  100
//#define kWeiboImgHeight 100

#define kMultipleImgSpace 5     //多图之间的间隔


/**
 *  WeiboCellLayout 包含 WeiboModel 以及 cell里面所有ui的frame
 */
@interface WeiboCellLayout : NSObject


@property(nonatomic, strong)WeiboModel *weiboModel;

//cell的高度
@property(nonatomic, assign)CGFloat cellHeight;

//微博正文的frame
@property(nonatomic, assign)CGRect textFrame;

//微博图片的frame
//@property(nonatomic, assign)CGRect imgFrame;

//转发微博背景图片的frame
@property(nonatomic, assign)CGRect retweetBgFrame;

//转发微博正文的frame
@property(nonatomic, assign)CGRect retweetTextFrame;

//转发微博图片的frame
//@property(nonatomic, assign)CGRect retweetImgFrame;

//微博多图每张图片的frame
@property(nonatomic, strong)NSMutableArray *imgFrameArr;

//转发微博多图每张图片的frame
@property(nonatomic, strong)NSMutableArray *retweetImgFrameArr;

@end

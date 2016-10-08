//
//  FaceView.m
//  blog
//
//  Created by hk-seed on 1/21/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "FaceView.h"

@implementation FaceView

- (void)drawRect:(CGRect)rect
{
    UIImage *img = [UIImage imageNamed:@"emoticon_keyboard_background"];
    [img drawInRect:rect];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _createView];
    }
    return self;
}

- (void)_createView
{
    ImgFaceView *imgFaceView = [[ImgFaceView alloc] initWithFrame:CGRectZero];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(imgFaceView.frame))];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.clipsToBounds = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(imgFaceView.width, scrollView.height);
    [self addSubview:scrollView];
    [scrollView addSubview:imgFaceView];
    self.imgFaceView = imgFaceView;
    
    //页码
    pgCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollView.frame), kScreenWidth, 36)];
    pgCtrl.numberOfPages = imgFaceView.pageCount;
    pgCtrl.currentPage = 0;
    [pgCtrl addTarget:self action:@selector(changePageAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pgCtrl];
    
    //重新赋值自己frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, CGRectGetMaxY(pgCtrl.frame));
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / kScreenWidth;
    pgCtrl.currentPage = page;
    
}

- (void)changePageAction
{
    [scrollView setContentOffset:CGPointMake(pgCtrl.currentPage * kScreenWidth, scrollView.contentOffset.y) animated:YES];
}

@end

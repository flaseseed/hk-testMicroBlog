//
//  ZoomImageView.m
//  blog
//
//  Created by hk-seed on 1/19/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "ZoomImageView.h"
#import "SDPieProgressView.h"
#import "MBProgressHUD.h"
#import "UIImage+GIF.h"
#import <ImageIO/ImageIO.h>

@interface ZoomImageView ()<NSURLSessionDataDelegate>

@end

@implementation ZoomImageView
{
    UIScrollView *_scrollView;
    UIImageView *_fullImageView;
    SDPieProgressView *_progressView;
    //加载的图片 加载的网络请求
    NSMutableData *_data;
    NSURLSession *_session;
    NSURLSessionDataTask *_dataTask;
    UIImage *saveImage;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
        [self addGestureRecognizer:tap];
        
        self.userInteractionEnabled = YES;
        
        //UIViewContentModeScaleAspectFit等比例适配
        self.contentMode = UIViewContentModeScaleAspectFit;
//        self.clipsToBounds = YES;

    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomIn)];
        [self addGestureRecognizer:tap];
        
        self.userInteractionEnabled = YES;
        
        //UIViewContentModeScaleAspectFit等比例适配
        self.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (void)_createView
{
    if (!_scrollView) {
        //创建弹出的滑动视图
        _scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        //添加到window上
        [self.window addSubview:_scrollView];
        
        //创建整个图片视图
        _fullImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        _fullImageView.image = self.image;
        [_scrollView addSubview:_fullImageView];
        
        _progressView = [SDPieProgressView progressView];
        _progressView.frame = CGRectMake(0, 0, 100, 100);
        _progressView.center = self.window.center;
        _progressView.hidden = YES;
        [_scrollView addSubview:_progressView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomOut)];
        [_scrollView addGestureRecognizer:tap];
        
        //长按手势，保存图片
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveImage:)];
        [_scrollView addGestureRecognizer:longPress];
        
    }
}

- (void)zoomIn
{
    //创建视图
    [self _createView];
    
    //加载的动画
    //转换坐标的方式
    CGRect rect = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = rect;
    
    [UIView animateWithDuration:0.5 animations:^{
        _fullImageView.frame = _scrollView.bounds;
        
    } completion:^(BOOL finished) {
        _progressView.hidden = NO;
        _scrollView.backgroundColor = [UIColor blackColor];
        
        if (self.urlString.length > 0) {
            NSURL *url = [NSURL URLWithString:_urlString];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration ephemeralSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
            
            _dataTask = [_session dataTaskWithRequest:request];
            
            [_dataTask resume];
        }
    }];
    _data = [[NSMutableData alloc] init];
    //网络请求

}

- (void)zoomOut
{
    //取消网络请求
    [_dataTask cancel];
    //缩小动画
    _scrollView.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = [self convertRect:self.bounds toView:self.window];
        _fullImageView.frame = rect;
    } completion:^(BOOL finished) {
        [_scrollView removeFromSuperview];
        _scrollView = nil;
        _fullImageView = nil;
        _progressView = nil;
    }];
    
}

#pragma - mark nsurl session data delegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [_data appendData:data];
    
    _progressView.progress = (double)dataTask.countOfBytesReceived / dataTask.countOfBytesExpectedToReceive;
    NSLog(@"%f",_progressView.progress);
    if (dataTask.countOfBytesExpectedToReceive == dataTask.countOfBytesReceived) {
        UIImage *image = [UIImage imageWithData:_data];
//        saveImage = [UIImage imageWithData:_data];
        if (saveImage != image) {
            saveImage = image;
        }
        
        _fullImageView.image = saveImage;
        
        //如果是长图，应该根据图片的高度配置contentsize
        CGFloat height = image.size.height / image.size.width * kScreenWidth;
        if (height < kScreenHeight) {
            _fullImageView.top = (kScreenHeight - height) / 2;
        }
        _fullImageView.height = height;
        _scrollView.contentSize = CGSizeMake(kScreenWidth, height);
        
        //1、webView 2、imageIO 3、sdwebimage
        if (self.isGif) {
            //SDWEBIMAGE播放
//            _fullImageView.image = [UIImage sd_animatedGIFWithData:_data];
            
            //1、创建图片源
            CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)(_data), NULL);
            
            //2、拿到图片的count
            size_t count = CGImageSourceGetCount(source);
            
            //3、创建需要播放的数组
            NSMutableArray *images = [NSMutableArray array];
            
            //4、持续时间
            NSTimeInterval duration = 0.0;
            
            for (size_t i = 0; i < count; i++) {
                CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
                UIImage *imageUI = [UIImage imageWithCGImage:image];
                [images addObject:imageUI];
                
                duration += 0.1;
                
                CGImageRelease(image);
            }
            //5、播放
            UIImage *image = [UIImage animatedImageWithImages:images duration:duration];
            
            _fullImageView.image = image;
            
            CFRelease(source);
            
            //webView
            //1、webview 创建 2、
//            UIWebView *webView = [[UIWebView alloc] init];
//            
//            [webView loadData:_data MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
            
        }
        
    }
    
}

#pragma - mark 保存图片
- (void)saveImage:(UIGestureRecognizer *)longPress
{
    //检测长按状态
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIImage *img = [UIImage imageWithData:_data];
        
        if (img) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
            
            hud.labelText = @"正在保存";
            hud.dimBackground = YES;
            
            UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void*)(hud));
        }
        
    }
}

//保存到相册成功之后的方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    MBProgressHUD *hud = (__bridge MBProgressHUD *)(contextInfo);
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = @"保存成功";
    
    [hud hide:YES afterDelay:1.5];
}

@end

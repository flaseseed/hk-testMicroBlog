//
//  ImgFaceView.m
//  blog
//
//  Created by hk-seed on 1/21/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "ImgFaceView.h"

#define kRowCount 4
#define kColumnCount 7

#define kFaceSize 30

#define kRowSpace 12

#define kColumnSpace ((kScreenWidth - kColumnCount * kFaceSize) / (kColumnCount + 1))

@implementation ImgFaceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        lastTouchIndex = -1;
        
        //数据加载
        [self parseFaceArr];
        //界面创建
        [self _createUI];
        
    }
    return self;
}

- (void)parseFaceArr
{
    faceItemArr = [[NSMutableArray alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emotions" ofType:@"plist"];
    NSArray *faceArr = [NSArray arrayWithContentsOfFile:path];
    
    int pageCount = kRowCount * kColumnCount;
    NSMutableArray *pageFaceArr = nil;
    
    for (int i = 0; i < faceArr.count; i++) {
        if (i % pageCount == 0) {
            //每一页显示表情的array
            pageFaceArr = [[NSMutableArray alloc] initWithCapacity:pageCount];
            [faceItemArr addObject:pageFaceArr];
        }
        
        //添加表情到array当中
        [pageFaceArr addObject:faceArr[i]];
    }
    
    self.pageCount = faceItemArr.count;
    self.frame = CGRectMake(self.origin.x, self.origin.y, kScreenWidth * faceItemArr.count, kFaceSize * kRowCount + kRowSpace * (kRowCount + 1));
}

- (void)_createUI
{
    magnifierView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"emoticon_keyboard_magnifier"]];
    magnifierView.frame = CGRectMake(0, 0, magnifierView.width, magnifierView.height);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((magnifierView.image.size.width - 40) / 2, 12, 40, 40)];
    imageView.tag = 300;
    [magnifierView addSubview:imageView];
    
    [self addSubview:magnifierView];
    magnifierView.hidden = YES;
}

- (void)drawRect:(CGRect)rect
{
    int row = 0;
    int column = 0;
    for (int i = 0; i < faceItemArr.count; i++) {
        //拿到每一页的face
        NSMutableArray *pageFace = faceItemArr[i];
        for (int j = 0; j < pageFace.count; j++) {
//            获取每一个表情图片
            NSDictionary *dic = pageFace[j];
            UIImage *img = [UIImage imageNamed:dic[@"png"]];
            
            [img drawInRect:CGRectMake(kFaceSize * column + kColumnSpace * (column + 1) + kScreenWidth * i, kFaceSize * row + kRowSpace *(row + 1), kFaceSize, kFaceSize) ];
            
            //换列
            column++;
            
            //如果本列排满换行 并重新排列
            if (column % kColumnCount == 0) {
                row++;
                column = 0;
            }
            
            //换页
            if (row % kRowCount == 0) {
                row = 0;
            }
            
        }
    }
}
//触摸事件
- (void)touchFace:(CGPoint)point
{
    //1.确定页码
    int page = point.x / kScreenWidth;
    
    //2.确定行与列
    float faceItemWidth = kFaceSize + kColumnSpace;
    float faceItemHeight = kFaceSize + kRowSpace;
    
    int row = (point.y - kRowSpace / 2) / faceItemHeight;
    int column = ((point.x - kScreenWidth * page) - kColumnSpace / 2) / faceItemWidth;
    //3.边界值确定
    row = MAX(0, MIN(3, row));
    column = MAX(0, MIN(column, 6));
    
    //一页表情
    NSArray *pageArr = faceItemArr[page];
    int index = row * kColumnCount + column;
    if (index > pageArr.count - 1) {
        lastTouchIndex = -1;
        return ;
    }
    
    if (lastTouchIndex != index) {
        NSDictionary *dic = pageArr[index];
#warning KVO记录值，但是不要传过去，传值在touchend
        NSString *faceName = dic[@"chs"];
        _faceName_kvo = faceName;
        
        //获取当前点击的图片并放大
        UIImageView *imgView = (UIImageView *)[magnifierView viewWithTag:300];
        imgView.image = [UIImage imageNamed:dic[@"png"]];
        //重新配置放大镜的frame
        float x = kColumnSpace * (column + 1) + kFaceSize / 2 + kFaceSize * column + kScreenWidth * page - magnifierView.bounds.size.width / 2;
        float y = kRowSpace * (row + 1) + kFaceSize * row - magnifierView.frame.size.height;
        
        magnifierView.frame = CGRectMake(x, y, CGRectGetWidth(magnifierView.frame), CGRectGetHeight(magnifierView.frame));
    }
    
    magnifierView.hidden = NO;
    
    lastTouchIndex = index;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self touchFace:point];
//    禁止scrollView滑动
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = NO;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [self touchFace:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    magnifierView.hidden = YES;
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
#warning kvoc传值
    //如果_faceName_kvo有值，就响应kvo
    if (_faceName_kvo) {
        self.faceName_kvo = _faceName_kvo;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    magnifierView.hidden = YES;
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        scrollView.scrollEnabled = YES;
    }
}

@end

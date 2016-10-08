//
//  MessageViewController.m
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "MessageViewController.h"
#import "WXRefresh.h"
#import "WeiboTableView.h"

#define kATme @"statuses/mentions.json"
#define kCommentSendByMe @"comments/by_me.json"
#define kCommentSendToMe @"comments/to_me.json"
#define kCommentATme @"comments/mentions.json";
/**
 *  结构：导航栏上四个button，主体结构是tableView 微博表视图
    流程：建立表视图，导航栏上得button设置，加载数据
    技术：接口访问
    实现：
    测试：
 */
@interface MessageViewController ()
{
    NSString *urlString;
}
@property (weak, nonatomic) IBOutlet WeiboTableView *tableView;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//关闭半透明效果， 让所又的subviews起点坐标从导航栏的下方开始计算
    self.navigationController.navigationBar.translucent = NO;
    urlString = kATme;
    //创建view
    [self _createView];
    //下拉刷新
    [_tableView addPullDownRefreshBlock:^{
        [self loadData];
    }];
    
    //上拉加载
    [_tableView addInfiniteScrollingWithActionHandler:^{
        [self loadOldData];
    }];
    
    [self loadData];
}

//view创建
- (void)_createView
{
    NSArray *messageButtons = @[[UIImage imageNamed:@"navigationbar_mentions"],[UIImage imageNamed:@"navigationbar_comments"],[UIImage imageNamed:@"navigationbar_messages"],[UIImage imageNamed:@"navigationbar_notice"]];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    for (int i = 0; i < messageButtons.count; i++) {
        UIButton *button = [[UIButton alloc] init];
        [button setImage:messageButtons[i] forState:UIControlStateNormal];
        button.showsTouchWhenHighlighted = YES;
        button.frame = CGRectMake(50 * i + 10, 5, 30, 30);
        [button addTarget:self action:@selector(messageButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 3000 + i;
        
        [titleView addSubview:button];
    }
   
    self.navigationItem.titleView = titleView;
}

//数据加载请求
- (void)loadData
{
    long since_id = 0;
    //判断数据个数是否大于0 配置since_id;
    if (_tableView.dataArr.count > 0) {
       WeiboCellLayout *layout = _tableView.dataArr[0];
        
        since_id = layout.weiboModel.id;
    }
        //请求数据
    NSDictionary *dic = @{
                          @"since_id" : [NSString stringWithFormat:@"%ld",since_id]
                          };
    
    [self.appDelegate.sinaWeibo requestWithURL:urlString params:[dic mutableCopy] httpMethod:@"GET" finishBlock:^(SinaWeiboRequest *request, id result) {
           //加载数据
        [self loadDataFinish:result isSinceID:YES];
    } failBlock:^(SinaWeiboRequest *request, NSError *error) {
        [self loadDataFail];
    }];

//    刷新
}
//加载旧的数据
- (void)loadOldData
{
    long max_id = 0;
    //判断数据个数是否大于0 配置since_id;
    if (_tableView.dataArr.count > 0) {
        WeiboCellLayout *layout = [_tableView.dataArr lastObject];
        
        max_id = layout.weiboModel.id;
    }
    //请求数据
    NSDictionary *dic = @{
                          @"max_id" : [NSString stringWithFormat:@"%ld",max_id]
                          };
    
    [self.appDelegate.sinaWeibo requestWithURL:urlString params:[dic mutableCopy] httpMethod:@"GET" finishBlock:^(SinaWeiboRequest *request, id result) {
        //加载数据
        [self loadDataFinish:result isSinceID:NO];
    } failBlock:^(SinaWeiboRequest *request, NSError *error) {
        [self loadDataFail];
    }];
}
//数据请求成功
- (void)loadDataFinish:(id)result isSinceID:(BOOL)sinceID
{
    //适配数据格式
    NSMutableArray *dataArray = [NSMutableArray array];
    
    NSArray *array = result[@"statuses"];
    for (NSDictionary *dic in array) {
        WeiboModel *model = [[WeiboModel alloc] initWithDictionary:dic error:NULL];
        
        WeiboCellLayout *layout = [[WeiboCellLayout alloc] init];
        layout.weiboModel = model;
        
        [dataArray addObject:layout];
    }
    //判断sinceID
    if (dataArray.count > 0) {
        if (sinceID) {
            //把原先的数据添加到当前的数组后面
            [dataArray addObjectsFromArray:_tableView.dataArr];
            
            _tableView.dataArr = dataArray;
        }else
        {
            WeiboCellLayout *last = [_tableView.dataArr lastObject];
            WeiboCellLayout *first = dataArray[0];
            if (last.weiboModel.id == first.weiboModel.id) {
                [dataArray removeObject:first];
            }
            
            [_tableView.dataArr addObjectsFromArray:dataArray];
        }
            //刷新数据
        [_tableView reloadData];
    }

    //停止下拉刷新
    [self stopRefresh];
}

//数据加载失败
- (void)loadDataFail
{
    NSLog(@"请求数据失败");
    [self stopRefresh];
}

//停止刷新
- (void)stopRefresh
{
    [_tableView.pullToRefreshView stopAnimating];
    [_tableView.infiniteScrollingView stopAnimating];
}

//附加：button点击方法实现
- (void)messageButtonAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 3000:
            //@我得
            urlString = kATme;
            break;
        case 3001:
            //评论
            urlString = kCommentSendByMe;
            break;
        case 3002:
            //消息
            urlString = kCommentSendToMe;
            break;
        case 3003:
            //通知
            urlString = kCommentATme;
            break;
        default:
            break;
    }
    
    [self loadData];
}

@end

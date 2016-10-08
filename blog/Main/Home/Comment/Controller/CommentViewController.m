//
//  CommentViewController.m
//  blog
//
//  Created by hk-seed on 1/19/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentTableView.h"
#import "WXRefresh.h"

@interface CommentViewController ()<UITextFieldDelegate>
{
    UILabel *_cmmtLabel;
}
@property (weak, nonatomic) IBOutlet CommentTableView *commentTableView;
@property (weak, nonatomic) IBOutlet UITextField *cmmtTextField;

@end

//访问接口comments/show.json，获取数据 配置信息，下拉刷新

@implementation CommentViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popKeyBoard:) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"微博正文";
    
    [self configUI];
    [self loadCommentData];
    [self _createCmmt];
    
    [_commentTableView addPullDownRefreshBlock:^{
        [self loadCommentData];
        [_commentTableView.pullToRefreshView stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configUI
{
    //header
    WeiboCell *cmmtHeaderView = [[[NSBundle mainBundle] loadNibNamed:@"WeiboCell" owner:self options:nil] firstObject];
    cmmtHeaderView.layout = self.weiboLayout;
    cmmtHeaderView.frame = CGRectMake(CGRectGetMinX(_commentTableView.frame), CGRectGetMinY(_commentTableView.frame), CGRectGetWidth(_commentTableView.frame), self.weiboLayout.cellHeight - kBottomHeight);
    
    for (int i = 1000; i < 1003; i++) {
        [[cmmtHeaderView viewWithTag:i] removeFromSuperview];
    }
    
    self.commentTableView.tableHeaderView = cmmtHeaderView;
}

- (void)_createCmmt
{
    _cmmtTextField.delegate = self;
    _cmmtTextField.returnKeyType = UIReturnKeySend;
    /**
     *  如果觉得系统的不好的话，可以添加搜狗输入法
     *
     *  @return
     */
}

- (void)popKeyBoard:(NSNotification *)notification
{
    //    (2) 获取键盘的高度
    NSValue *value = notification.userInfo[@"UIKeyboardBoundsUserInfoKey"];
    CGRect rect = [value CGRectValue];
    CGFloat height = rect.size.height;
    
    //   （3）调整View的高度和tableView的高度
    [UIView animateWithDuration:0.25 animations:^{
        
        _cmmtTextField.transform = CGAffineTransformMakeTranslation(0, -height);
    }];
    _cmmtLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 88, 200, 100)];
    _cmmtLabel.numberOfLines = 0;
    _cmmtLabel.tag = 2016;
    _cmmtLabel.backgroundColor = [UIColor lightGrayColor];
    _cmmtLabel.alpha = 0.6;
    [self.view.window addSubview:_cmmtLabel];
//    [self.view.window bringSubviewToFront:label];
}


-(void)loadCommentData
{
    NSString *weiboID = [NSString stringWithFormat:@"%ld", self.weiboLayout.weiboModel.id];
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithObject:weiboID forKey:@"id"];
    [self.appDelegate.sinaWeibo requestWithURL:@"comments/show.json"
                                        params:mDic
                                    httpMethod:@"GET"
                                   finishBlock:^(SinaWeiboRequest *request, id result) {
                                       [self loadDataFinished:result];
                                   } failBlock:NULL];
    
}

-(void)loadDataFinished:(NSDictionary *)result
{
    NSArray *arr = [result objectForKey:@"comments"];
    NSMutableArray *comments = [[NSMutableArray alloc] initWithCapacity:arr.count];
    for (NSDictionary *dic in arr) {
        CommentModel *cmmtModel = [[CommentModel alloc] initWithDictionary:dic error:NULL];
        CommentLayout *layout = [[CommentLayout alloc] init];
        layout.cmmtModel = cmmtModel;
        [comments addObject:layout];
    }
    
    self.commentTableView.dataArr = comments;
    [self.commentTableView reloadData];
    
}

#pragma - mark uitexeFiled delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _cmmtLabel.text = textField.text;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.appDelegate.sinaWeibo requestWithURL:@"comments/create.json" params:[NSMutableDictionary dictionaryWithDictionary:@{@"comment" : _cmmtTextField.text,@"id" : [NSString stringWithFormat:@"%ld",_weiboLayout.weiboModel.id]
                                                                                                                             }] httpMethod:@"POST" finishBlock:^(SinaWeiboRequest *request, id result) {
        
    } failBlock:^(SinaWeiboRequest *request, NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        _cmmtTextField.transform = CGAffineTransformIdentity;
    }];
    [self performSelector:@selector(loadCommentData) withObject:nil afterDelay:0.5];

    //    （2）键盘掉下来
    [textField resignFirstResponder];
    textField.text = nil;
    [_cmmtLabel removeFromSuperview];
    
    return YES;
}

@end

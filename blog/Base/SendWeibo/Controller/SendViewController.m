//
//  SendViewController.m
//  blog
//
//  Created by hk-seed on 1/21/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "SendViewController.h"
#import "FaceView.h"
#import "LocationSelfTableViewController.h"
#import "RootNavigationController.h"

//界面配置 导航栏 返回和发送按钮 textView 工具栏
//文本输入 表情 发送微博
@interface SendViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) FaceView *faceView;

@property (nonatomic, strong) UIView *locationView;

@property (nonatomic, strong) NSDictionary *locationGeoDic;

@end

@implementation SendViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self keyboardEvent];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self keyboardEvent];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_faceView.imgFaceView removeObserver:self forKeyPath:@"faceName_kvo"];
}

- (void)keyboardEvent
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"发微博";
    self.view.backgroundColor = [[ThemeManager shareManager] loadColorWithKeyName:@"More_Item_color"];
    
    //界面配置
    [self _createView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.appDelegate.drawerCtrl closeDrawerAnimated:YES completion:NULL];
}

- (void)_createView
{
    //button textView 下面的配置
    ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    button.backImgName = @"titlebar_button_back_9@2x";
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
    
    ThemeButton *sendButton = [[ThemeButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    sendButton.tag = 3000;
//    sendButton.enabled = NO;
    sendButton.backImgName = @"titlebar_button_9@2x";
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc] initWithCustomView:sendButton];
    sendItem.enabled = NO;
    self.navigationItem.rightBarButtonItem = sendItem;
    
    //textView
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64)];
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.textColor = [[ThemeManager shareManager] loadColorWithKeyName:@"More_Item_Text_color"];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.delegate = self;
//    辅助的工具栏
    UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    NSArray *buttonNames = @[@"compose_toolbar_1@2x.png",
                             @"compose_toolbar_3@2x.png",
                             @"compose_toolbar_4@2x.png",
                             @"compose_toolbar_5@2x.png",
                             @"compose_toolbar_6@2x.png"];
    
    float itemWidth = kScreenWidth / 5;
    for (int i = 0; i < buttonNames.count; i++) {
        ThemeButton *button = [[ThemeButton alloc] initWithFrame:CGRectMake(itemWidth * i, 0, itemWidth, 50)];
        button.imgName = buttonNames[i];
        button.tag = 300 + i;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [accessoryView addSubview:button];
    }
    
    _textView.inputAccessoryView = accessoryView;
    [self.view addSubview:_textView];
//    显示地点信息的view
    _locationView = [[UIView alloc] initWithFrame:CGRectMake(0, _textView.inputAccessoryView.frame.origin.y - 50, kScreenWidth, 50)];
    ThemeImgView *imageView = [[ThemeImgView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    imageView.imgName = @"compose_toolbar_5@2x.png";
//    imageView.backgroundColor = [UIColor blueColor];
    [_locationView addSubview:imageView];
    
    ThemeLabel *label = [[ThemeLabel alloc] initWithFrame:CGRectMake(60, 5, kScreenWidth - 70, 40)];
    label.colorKeyName = @"More_Item_Text_color";
    label.tag = 400;
    [_locationView addSubview:label];
    _locationView.hidden = YES;
//    _locationView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_locationView];
}

- (void)backAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)sendAction:(UIButton *)sender
{
    //去掉换行符和空白字符
    NSString *textStr = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (textStr.length > 140) {
        [self showFailHUD:@"微博内容不能超过140个汉字" withDelayHideTime:1.5 withView:_textView];
        return ;
    }
    
    //发送微博
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:textStr,@"status", nil];
    //如果有地理信息，发送地理信息
#warning 地理信息
    if (self.locationGeoDic) {
        
        [params setObject:_locationGeoDic[@"lat"] forKey:@"lat"];
        [params setObject:_locationGeoDic[@"lon"] forKey:@"long"];
    }
    
    [self.appDelegate.sinaWeibo requestWithURL:@"statuses/update.json" params:params httpMethod:@"POST" finishBlock:^(SinaWeiboRequest *request, id result) {
        [self showSuccessHUD:@"发送成功" withDelayHideTime:1.5];
        [self backAction:nil];
    } failBlock:^(SinaWeiboRequest *request, NSError *error) {
        [self showFailHUD:@"发送失败" withDelayHideTime:1.5 withView:_textView];
    }];
    
}

- (void)buttonAction:(UIButton *)button
{
    switch (button.tag) {
        case 300:
            NSLog(@"拍照");
            break;
        case 301:
            NSLog(@"@");
            break;
        case 302:
            NSLog(@"话题");
            break;
        case 303:
            NSLog(@"定位");
        {
            [_textView resignFirstResponder];
            
            LocationSelfTableViewController *locationSelf = [[LocationSelfTableViewController alloc] init];
            locationSelf.selectLocation = ^(NSDictionary *result){
                self.locationGeoDic = result;
                
                _locationView.hidden = NO;
                NSString *address = [result objectForKey:@"title"];
                if ([address isKindOfClass:[NSNull class]]) {
                    address = [result objectForKey:@"address"];
                }
                UILabel *label = [_locationView viewWithTag:400];
                label.text = address;
            };
            
            RootNavigationController *navCtrl = [[RootNavigationController alloc] initWithRootViewController:locationSelf];
            [self presentViewController:navCtrl animated:YES completion:NULL];
        }
            break;
        case 304:
        {
            if (!_faceView) {
                _faceView = [[FaceView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
                //添加观察者
                [_faceView.imgFaceView addObserver:self forKeyPath:@"faceName_kvo" options:NSKeyValueObservingOptionNew context:NULL];
            }
            
            [self.textView resignFirstResponder];
            if (self.textView.inputView) {
                self.textView.inputView = nil;
            }else{
                self.textView.inputView = _faceView;
            }
            [self.textView becomeFirstResponder];
        }
        
            break;
        default:
            break;
    }
}

#warning 观察者方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
   
    NSString *face = [change objectForKey:NSKeyValueChangeNewKey];
    //如果拿到的值是空，记住，在容器类当中 nil是容器的结尾，实际控制[NSNull null]
    if (!face || [face isKindOfClass:[NSNull class]]) {
        return;
    }
     self.navigationItem.rightBarButtonItem.enabled = YES;
    //在光标的位置插入表情, 如果选中, 将会被替换
    NSMutableString *mStr = [NSMutableString stringWithString:_textView.text];
    
    //获取光标的位置
    NSRange rg = _textView.selectedRange;
    if (rg.location == NSNotFound) {
        //如果没有找到光标,就把光标定位到文字结尾
        rg.location = _textView.text.length;
    }
    
    //替换选中的文字
    [mStr replaceCharactersInRange:rg withString:face];
    
    _textView.text = mStr;
    
    //最后再定位光标
    _textView.selectedRange = NSMakeRange(rg.location+face.length, 0);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)keyboardWillShowNotification:(NSNotification *)noti
{
    //配置高度
    NSValue *keyboardValue = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect frame = [keyboardValue CGRectValue];
    _locationView.frame = CGRectMake(0, kScreenHeight - frame.size.height - 100, kScreenWidth, 50);
}

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    if (textView.text.length > 0) {
//        self.navigationItem.rightBarButtonItem.enabled = YES;
//    }
//}
//
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    
    NSLog(@"%@",textView);
}

@end

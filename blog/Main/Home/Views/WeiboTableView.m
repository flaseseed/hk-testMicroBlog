//
//  WeiboTableView.m
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "WeiboTableView.h"
#import "UIView+ViewController.h"
#import "CommentViewController.h"

static NSString *kCellID = @"kWeiboTableViewCellID";

@implementation WeiboTableView

-(void)setupConfig
{
    [super setupConfig];
    
    _dataArr = [[NSMutableArray alloc] init];
    
    self.delegate = self;
    self.dataSource = self;
    
    [self registerNib:[UINib nibWithNibName:@"WeiboCell" bundle:nil] forCellReuseIdentifier:kCellID];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboCellLayout *layout = self.dataArr[indexPath.row];
    return layout.cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    cell.layout = self.dataArr[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *stbd = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    CommentViewController *cmmtCtrl = [stbd instantiateViewControllerWithIdentifier:@"kCommentViewControllerID"];
    cmmtCtrl.weiboLayout = self.dataArr[indexPath.row];
    [self.viewController.navigationController pushViewController:cmmtCtrl animated:YES];
    [self deselectRowAtIndexPath:indexPath animated:YES];
}

@end

//
//  CommentTableView.m
//  blog
//
//  Created by hk-seed on 1/19/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "CommentTableView.h"

#define kCommentCellID @"kCommentCellID"

@interface CommentTableView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CommentTableView

- (void)setupConfig
{
    [super setupConfig];
    
    _dataArr = [[NSMutableArray alloc] init];
    
    self.delegate = self;
    self.dataSource = self;
    
    [self registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:kCommentCellID];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCommentCellID forIndexPath:indexPath];
    cell.layout = self.dataArr[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentLayout *layout = _dataArr[indexPath.row];
    
    return layout.cellHeight;
}


@end

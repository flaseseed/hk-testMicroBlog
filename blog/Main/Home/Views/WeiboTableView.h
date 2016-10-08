//
//  WeiboTableView.h
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiboCell.h"
#import "ThemeTableView.h"

@interface WeiboTableView : ThemeTableView <UITableViewDelegate, UITableViewDataSource>
    
@property(nonatomic, strong)NSMutableArray *dataArr;

@end

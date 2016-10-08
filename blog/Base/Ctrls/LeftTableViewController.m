//
//  LeftTableViewController.m
//  blog
//
//  Created by hk-seed on 1/13/16.
//  Copyright © 2016 george. All rights reserved.
//

#import "LeftTableViewController.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "ThemeCell.h"

@interface LeftTableViewController ()

@property(nonatomic, retain)NSMutableDictionary *dataDic;

@end

@implementation LeftTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _dataDic = [[NSMutableDictionary alloc] init];
        
        NSArray *arr = @[
                         @"无",
                         @"滑动",
                         @"滑动&缩放",
                         @"飘移门",
                         @"视差滑动"
                         ];
        [_dataDic setObject:arr forKey:@"界面切换动画"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ThemeCell" bundle:nil] forCellReuseIdentifier:kThemeViewCtrlID];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return _dataDic.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *key = [_dataDic allKeys][section];
    NSArray *arr = [_dataDic objectForKey:key];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *kHeaderViewID = @"kHeaderViewID";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderViewID];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:kHeaderViewID];
        ThemeLabel *themeLabel = [[ThemeLabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
        themeLabel.tag = 2015;
        themeLabel.textAlignment = NSTextAlignmentCenter;
        themeLabel.font = [UIFont boldSystemFontOfSize:18];
        themeLabel.colorKeyName = @"More_Item_Text_color";
        [headerView.contentView addSubview:themeLabel];
    }
    
    ThemeLabel *label = (ThemeLabel *)[headerView.contentView viewWithTag:2015];
    label.text = [_dataDic allKeys][section];
    
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:kThemeViewCtrlID forIndexPath:indexPath];
    
    NSString *key = [_dataDic allKeys][indexPath.section];
    NSArray *arr = [_dataDic objectForKey:key];
    
    NSString *imgName = [NSString stringWithFormat:@"00%ld@2x.png", indexPath.row+1];
    cell.headImgView.image = [UIImage imageNamed:imgName];
    cell.themeNameLabel.text = arr[indexPath.row];
    
    if (indexPath.section == 0) {
        MMDrawerAnimationType drawerType = [MMExampleDrawerVisualStateManager sharedManager].leftDrawerAnimationType;
        if (drawerType == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [MMExampleDrawerVisualStateManager sharedManager].leftDrawerAnimationType = indexPath.row;
        [MMExampleDrawerVisualStateManager sharedManager].rightDrawerAnimationType = indexPath.row;
        
        //写个方法保存到user default
        //[[MMExampleDrawerVisualStateManager sharedManager] saveConfig];
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
    }
}

@end

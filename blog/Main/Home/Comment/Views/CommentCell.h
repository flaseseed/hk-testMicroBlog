//
//  CommentCell.h
//  blog
//
//  Created by hk-seed on 1/19/16.
//  Copyright © 2016 george. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXLabel.h"
#import "CommentLayout.h"

@interface CommentCell : UITableViewCell<WXLabelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet ThemeLabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet ThemeLabel *timeLabel;

@property (nonatomic, strong)WXLabel *commentLabel;
@property (nonatomic, strong)CommentLayout *layout;

@end

//
//  UITableViewCell+Extend.m
//  LGVideo
//
//  Created by 孙卫亮 on 2018/10/23.
//  Copyright © 2018 孙卫亮. All rights reserved.
//

#import "UITableViewCell+Extend.h"

@implementation UITableViewCell (Extend)

#pragma mark--
#pragma mark--设置tableviewcell  Seperator

/// tableView cell的分割线正常
- (void)setTableViewCellSeperatorLineToNormal
{
    [self setTableViewCellSeperatorLineToNormalWithUIEdgeInsets:UIEdgeInsetsZero];
}

/// tableView cell无分割线
- (void)setTableViewCellNoneSeperatorLine
{
    self.preservesSuperviewLayoutMargins = NO;
    [self setTableViewCellSeperatorLineToNormalWithUIEdgeInsets:UIEdgeInsetsMake(self.separatorInset.top, 0, self.separatorInset.bottom, [UIScreen mainScreen].bounds.size.width)];
}

/// tableView cell的分割线 自定义
- (void)setTableViewCellSeperatorLineToNormalWithUIEdgeInsets:(UIEdgeInsets)separatorInset
{
    if ([self respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self setSeparatorInset:separatorInset];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self setLayoutMargins:separatorInset];
    }
}


@end

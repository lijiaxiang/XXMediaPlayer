//
//  UITableViewCell+Extend.h
//  LGVideo
//
//  Created by 孙卫亮 on 2018/10/23.
//  Copyright © 2018 孙卫亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Extend)

/// tableView cell的分割线正常
- (void)setTableViewCellSeperatorLineToNormal;
/// tableView cell无分割线
- (void)setTableViewCellNoneSeperatorLine;
/// tableView cell的分割线 自定义
- (void)setTableViewCellSeperatorLineToNormalWithUIEdgeInsets:(UIEdgeInsets)separatorInset;

@end

//
//  UIView+GetCell.h
//  MiaoPai
//
//  Created by macRong on 16/6/15.
//  Copyright © 2016年 Jeakin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GetCell)

// 获取cell
- (UITableViewCell *)cellInSupView;

// 获得indexpath
- (NSIndexPath *)indextPathInSupView:(UITableView *)tableView;

@end

//
//  UIView+GetCell.m
//  MiaoPai
//
//  Created by macRong on 16/6/15.
//  Copyright © 2016年 Jeakin. All rights reserved.
//

#import "UIView+GetCell.h"

@implementation UIView (GetCell)

- (UITableViewCell *)cellInSupView
{
    UIView *superView = self.superview;
    UITableViewCell *tableviewCell = nil;
    
    while (nil != superView && nil == tableviewCell)
    {    
        if ([superView isKindOfClass:[UITableViewCell class]])
        {
            tableviewCell = (UITableViewCell *)superView;
        }
        else
        {
            superView = superView.superview;
        }
    }
    
    return tableviewCell;
}

- (NSIndexPath *)indextPathInSupView:(UITableView *)tableView
{
    UITableViewCell *cell = [self cellInSupView];
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    
    return indexPath;
}


@end

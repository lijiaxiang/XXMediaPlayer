//
//  UITableView+ChangeView.m
//  LGVideo
//
//  Created by 孙卫亮 on 2019/1/11.
//  Copyright © 2019 孙卫亮. All rights reserved.
//

#import "UITableView+ChangeView.h"

@implementation UITableView (ChangeView)


#pragma mark - 设置tableview

- (void)setTableViewLineHidden
{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor=[UIColor clearColor];
    [self setTableFooterView:footerView];
    
    footerView = nil;
}

@end

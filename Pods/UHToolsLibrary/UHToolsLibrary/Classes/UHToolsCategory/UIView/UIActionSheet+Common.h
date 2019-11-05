//
//  UIActionSheet+Common.h
//  Inspender
//
//  Created by air on 16/6/12.
//  Copyright © 2016年 weiliang.soon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (Common)<UIActionSheetDelegate>

//UIActionSheet
- (void)showInView:(UIView *)view withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

- (void)showFromToolbar:(UIToolbar *)view withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

- (void)showFromTabBar:(UITabBar *)view withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

- (void)showFromRect:(CGRect)rect
             inView:(UIView *)view
           animated:(BOOL)animated
withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

- (void)showFromBarButtonItem:(UIBarButtonItem *)item
                    animated:(BOOL)animated
       withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler;

@end

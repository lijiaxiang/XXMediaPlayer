//
//  UIActionSheet+Common.m
//  Inspender
//
//  Created by air on 16/6/12.
//  Copyright © 2016年 weiliang.soon. All rights reserved.
//

#import "UIActionSheet+Common.h"
#import <objc/runtime.h>

const char actionSheetOldDelegateKey;
const char actionSheetCompletionHandlerKey;

@implementation UIActionSheet (Common)


#pragma -mark UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    void (^theCompletionHandler)(NSInteger buttonIndex) = objc_getAssociatedObject(self, &actionSheetCompletionHandlerKey);
    
    if (theCompletionHandler == nil)
        return;
    
    theCompletionHandler(buttonIndex);
    UIActionSheet *sheet = (UIActionSheet *)self;
    
    sheet.delegate = objc_getAssociatedObject(self, &actionSheetOldDelegateKey);
}

- (void)config:(void(^)(NSInteger buttonIndex))completionHandler
{
    if(completionHandler != nil)
    {
        id oldDelegate = objc_getAssociatedObject(self, &actionSheetOldDelegateKey);
        if(oldDelegate == nil)
        {
            objc_setAssociatedObject(self, &actionSheetOldDelegateKey, oldDelegate, OBJC_ASSOCIATION_ASSIGN);
        }
        
        UIActionSheet *sheet = (UIActionSheet *)self;
        oldDelegate = sheet.delegate;
        sheet.delegate = self;
        objc_setAssociatedObject(self, &actionSheetCompletionHandlerKey, completionHandler, OBJC_ASSOCIATION_COPY);
    }
}

- (void)showInView:(UIView *)view
withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self config:completionHandler];
    [sheet showInView:view];
}

- (void)showFromToolbar:(UIToolbar *)view
 withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self config:completionHandler];
    [sheet showFromToolbar:view];
}

- (void)showFromTabBar:(UITabBar *)view
withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self config:completionHandler];
    [sheet showFromTabBar:view];
}

- (void)showFromRect:(CGRect)rect
             inView:(UIView *)view
           animated:(BOOL)animated
withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self config:completionHandler];
    [sheet showFromRect:rect inView:view animated:animated];
}

- (void)showFromBarButtonItem:(UIBarButtonItem *)item
                    animated:(BOOL)animated
       withCompletionHandler:(void (^)(NSInteger buttonIndex))completionHandler
{
    UIActionSheet *sheet = (UIActionSheet *)self;
    [self config:completionHandler];
    [sheet showFromBarButtonItem:item animated:animated];
}

@end

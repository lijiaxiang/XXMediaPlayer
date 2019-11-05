//
//  UIViewController+UHCurrentController.m
//  LGVideo
//
//  Created by Viper on 2018/10/31.
//  Copyright © 2018年 孙卫亮. All rights reserved.
//

#import "UIViewController+UHCurrentController.h"

@implementation UIViewController (UHCurrentController)

+ (UIViewController *)UH_currentViewController
{
    // 寻找 顶层 控制器
    UIViewController *viewController = [[UIApplication sharedApplication] delegate].window.rootViewController;
    
    return [self findBestViewController:viewController];
}

+ (UIViewController *)findBestViewController:(UIViewController *)vc
{
    if (vc.presentedViewController)
    {
        // 返回 模态 控制器
        return [self findBestViewController:vc.presentedViewController];
    }
    else if ([vc isKindOfClass:[UISplitViewController class]])
    {
        // 返回 splitVC 栈顶 控制器
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0)
        {
            return [self findBestViewController:svc.viewControllers.lastObject];
        }
        else
        {
            return vc;
        }
    }
    else if ([vc isKindOfClass:[UINavigationController class]])
    {
        // 返回 naviVC 栈顶 控制器
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0)
        {
            return [self findBestViewController:svc.topViewController];
        }
        else
        {
            return vc;
        }
    }
    else if ([vc isKindOfClass:[UITabBarController class]])
    {
        // 返回 visibleVC 选中控制器
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0)
        {
            return [self findBestViewController:svc.selectedViewController];
        }
        else
        {
            return vc;
        }
    }
    else
    {
        // 为寻找到类型，直接返回
        return vc;
    }
}

@end

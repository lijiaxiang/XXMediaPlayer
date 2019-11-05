//
//  NSObject+AlertViewController.m
//  LGVideo
//
//  Created by 孙卫亮 on 2018/9/28.
//  Copyright © 2018 孙卫亮. All rights reserved.
//

#import "UIViewController+AlertViewController.h"

@implementation UIViewController (AlertViewController)

- (void)showAlertViewControllerWithTitle:(NSString*)title
                                             msg:(NSString*)message
                                          cancel:(NSString*)cancel
                                         otherTitle:(NSString*)otherTitle
                                      completion:(void(^)(NSInteger index))completion
{
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //cancel
    UIAlertAction *action = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (completion)
        {
            completion(0);
        }
    }];
    [alertController addAction:action];

    //ok
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        if (completion)
        {
            completion(1);
        }
        
    }];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end

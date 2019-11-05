//
//  UIViewController+AlertViewController.h
//  LGVideo
//
//  Created by 孙卫亮 on 2018/9/28.
//  Copyright © 2018 孙卫亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController(AlertViewController)

- (void)showAlertViewControllerWithTitle:(NSString*)title
                                     msg:(NSString*)message
                                  cancel:(NSString*)cancel
                              otherTitle:(NSString*)otherTitle
                              completion:(void(^)(NSInteger index))completion;

@end

//
//  UITextView+UHPlaceholder.h
//  LGVideo
//
//  Created by coderyi on 2019/7/6.
//  Copyright © 2019 右划科技. All rights reserved.
//

@import UIKit;

FOUNDATION_EXPORT double UITextView_PlaceholderVersionNumber;
FOUNDATION_EXPORT const unsigned char UITextView_PlaceholderVersionString[];

@interface UITextView (UHPlaceholder)

@property (nonatomic, readonly) UITextView *placeholderTextView;

@property (nonatomic, strong) IBInspectable NSString *placeholder;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;

@end

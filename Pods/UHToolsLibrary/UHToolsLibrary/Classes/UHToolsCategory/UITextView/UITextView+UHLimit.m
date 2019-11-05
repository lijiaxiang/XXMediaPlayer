//
//  UITextView+UHLimit.m
//  LGVideo
//
//  Created by 郭继超 on 2019/4/8.
//  Copyright © 2019 右划科技. All rights reserved.
//

#import "UITextView+UHLimit.h"
#import <objc/runtime.h>

@interface NL_PrivateUITextViewMaxLengthHelper : NSObject
@property (nonatomic, assign) NSUInteger maxLength;
@property (nonatomic, weak)   UITextView *textView;
- (instancetype)initWithTextView:(UITextView *)textView maxLength:(NSUInteger)maxLength;
@end
@interface UITextView (NL_PrivateMaxLengthHelper)
@property (nonatomic, strong) NL_PrivateUITextViewMaxLengthHelper *nl_maxLengthHelper;
@end
@implementation UITextView (UHLimit)
static void *nlUITextViewLimitMaxLengthKey = &nlUITextViewLimitMaxLengthKey;

- (void)setNl_maxLength:(NSUInteger)nl_maxLength {
    objc_setAssociatedObject(self, nlUITextViewLimitMaxLengthKey, @(nl_maxLength), OBJC_ASSOCIATION_COPY);
    self.nl_maxLengthHelper.maxLength = nl_maxLength;
}

- (NSUInteger)nl_maxLength {
    return [objc_getAssociatedObject(self, nlUITextViewLimitMaxLengthKey) unsignedIntegerValue];
}

@end

@implementation UITextView (NL_PrivateMaxLengthHelper)

static void *nlNl_maxLengthHelper = &nlNl_maxLengthHelper;
- (void)setNl_maxLengthHelper:(NL_PrivateUITextViewMaxLengthHelper *)nl_maxLengthHelper {
    objc_setAssociatedObject(self, nlNl_maxLengthHelper, nl_maxLengthHelper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NL_PrivateUITextViewMaxLengthHelper *)nl_maxLengthHelper {
    NL_PrivateUITextViewMaxLengthHelper *helper = objc_getAssociatedObject(self, nlNl_maxLengthHelper);
    if (!helper) {
        helper = [[NL_PrivateUITextViewMaxLengthHelper alloc] initWithTextView:self maxLength:self.nl_maxLength];
        [self setNl_maxLengthHelper:helper];
    }
    
    return helper;
}

@end
@implementation NL_PrivateUITextViewMaxLengthHelper

- (instancetype)initWithTextView:(UITextView *)textView maxLength:(NSUInteger)maxLength {
    if (self = [super init]) {
        _textView = textView;
        _maxLength = maxLength;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_nl_valueChanged:) name:UITextViewTextDidBeginEditingNotification object:textView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_nl_valueChanged:) name:UITextViewTextDidChangeNotification object:textView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_nl_valueChanged:) name:UITextViewTextDidEndEditingNotification object:textView];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - private
- (void)_nl_valueChanged:(NSNotification *)notification {
    UITextView *textView = [notification object];
    if (textView != self.textView) {
        return;
    }
    
    if (self.maxLength == 0) {
        return;
    }
    
    NSUInteger currentLength = [textView.text length];
    if (currentLength <= self.maxLength) {
        return;
    }
    
//    NSRange range = [textView.text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
//    NSString *subString = [textView.text substringWithRange:range];
////    NSString *subString = [textView.text substringToIndex:self.maxLength];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.textView.text = subString;
//        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
//    });
    
    @try {
        NSRange rangeIndex = [textView.text rangeOfComposedCharacterSequenceAtIndex:self.maxLength];
        
        NSRange rangeRange = [textView.text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.maxLength)];
        NSInteger tmpLength;
        if (rangeRange.length > self.maxLength) {
            tmpLength = rangeRange.length - rangeIndex.length;
        }else{
            tmpLength = rangeRange.length;
        }
        
        NSString *subString = [textView.text substringWithRange:NSMakeRange(0, tmpLength)];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.textView.text = subString;
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
        });
    } @catch (NSException *exception) {
    }

}
@end

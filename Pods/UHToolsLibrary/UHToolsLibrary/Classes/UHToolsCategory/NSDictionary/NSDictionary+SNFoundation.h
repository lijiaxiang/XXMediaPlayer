//
//  NSDictionary+SNFoundation.h
//  SNFoundation
//
//  Created by liukun on 14-3-2.
//  Copyright (c) 2014年 liukun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SNFoundation)

///直接转换的，没有重新这只属性，
- (NSString*)toJsonString;

- (id)safeValueForKeyPath:(NSString *)keyPath placeholder:(id)placeholder;
- (id)safeValueForKeyPath:(NSString *)keyPath valueClass:(Class)valueClass placeholder:(id)placeholder;

//NSString
- (NSString *)safeStringForKeyPath:(NSString *)keyPath;
- (NSString *)safeStringForKeyPath:(NSString *)keyPath placeholder:(id)placeholder;

//NSInteger
- (NSInteger)safeIntegerForKeyPath:(NSString *)keyPath;
- (NSInteger)safeIntegerForKeyPath:(NSString *)keyPath placeholder:(NSInteger)placeholder;

//float
- (float)safeFloatForKeyPath:(NSString *)keyPath;
- (float)safeFloatForKeyPath:(NSString *)keyPath placeholder:(float)placeholder;

//NSArray
- (NSArray *)safeArrayForKeyPath:(NSString *)keyPath;

//NSDictionary
- (NSDictionary *)safeDictionaryForKeyPath:(NSString *)keyPath;

- (BOOL)hasKeyPath:(NSString *)keyPath;

@end

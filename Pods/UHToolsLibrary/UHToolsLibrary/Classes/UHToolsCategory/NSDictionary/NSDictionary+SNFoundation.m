//
//  NSDictionary+SNFoundation.m
//  SNFoundation
//
//  Created by liukun on 14-3-2.
//  Copyright (c) 2014年 liukun. All rights reserved.
//

#import "NSDictionary+SNFoundation.h"

@implementation NSDictionary (SNFoundation)

- (NSString*)toJsonString
{
    NSError *error = nil;
    NSData *jsonData = nil;
    if (!self)
    {
        return nil;
    }
    
    ///服务器需要number类型
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        NSString *keyString = nil;
//        NSString *valueString = nil;
//        if ([key isKindOfClass:[NSString class]]) {
//            keyString = key;
//        }else{
//            keyString = [NSString stringWithFormat:@"%@",key];
//        }
//
//        if ([obj isKindOfClass:[NSString class]]) {
//            valueString = obj;
//        }else{
//            valueString = [NSString stringWithFormat:@"%@",obj];
//        }
//
//        [dict setObject:valueString forKey:keyString];
//    }];
    
    jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    if ([jsonData length] == 0 ||
        error != nil)
    {
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

- (id)safeValueForKeyPath:(NSString *)keyPath placeholder:(id)placeholder
{
    id value = nil;
    @try {
        value = [self valueForKeyPath:keyPath];
        value = value ? : placeholder;
    }
    @catch (NSException *exception) {
        value = placeholder;
    }
    @finally {
        return value;
    }
}

- (id)safeValueForKeyPath:(NSString *)keyPath valueClass:(Class)valueClass placeholder:(id)placeholder
{
    id value = nil;
    @try {
        value = [self valueForKeyPath:keyPath];
    }
    @catch (NSException *exception) {
        value = placeholder;
    }
    @finally {
        if ([value isKindOfClass:valueClass] == NO) {
            if (value && [value isKindOfClass:[NSNull class]] == NO && [NSStringFromClass(valueClass) isEqualToString:@"NSString"]) {
                return [NSString stringWithFormat:@"%@", value];
            }
        }
        return value;
    }
}

- (NSString *)safeStringForKeyPath:(NSString *)keyPath
{
    return [self safeValueForKeyPath:keyPath valueClass:[NSString class] placeholder:nil];
}

- (NSString *)safeStringForKeyPath:(NSString *)keyPath placeholder:(id)placeholder
{
    return [self safeValueForKeyPath:keyPath valueClass:[NSString class] placeholder:placeholder];
}

- (NSInteger)safeIntegerForKeyPath:(NSString *)keyPath
{
    return [[self safeValueForKeyPath:keyPath placeholder:@(0)] integerValue];
}

- (NSInteger)safeIntegerForKeyPath:(NSString *)keyPath placeholder:(NSInteger)placeholder
{
    return [[self safeValueForKeyPath:keyPath placeholder:@(placeholder)] integerValue];
}

- (float)safeFloatForKeyPath:(NSString *)keyPath
{
    return [[self safeValueForKeyPath:keyPath placeholder:@(0)] floatValue];
}

- (float)safeFloatForKeyPath:(NSString *)keyPath placeholder:(float)placeholder
{
    return [[self safeValueForKeyPath:keyPath placeholder:@(placeholder)] floatValue];
}

//NSArray
- (NSArray *)safeArrayForKeyPath:(NSString *)keyPath
{
    return [self safeValueForKeyPath:keyPath valueClass:[NSArray class] placeholder:nil];
}

//NSDictionary
- (NSDictionary *)safeDictionaryForKeyPath:(NSString *)keyPath
{
    return [self safeValueForKeyPath:keyPath valueClass:[NSDictionary class] placeholder:nil];
}

- (BOOL)hasKeyPath:(NSString *)keyPath
{
    if (keyPath.length == 0)
    {
        return NO;
    }
    NSArray *allKeys = self.allKeys;
    NSArray *paths = [keyPath componentsSeparatedByString:@"."];
    NSString *path = paths[0];
    if ([allKeys containsObject:path])
    {
        if (paths.count == 1)
        {
            return YES;
        }
        else
        {
            id obj = [self safeValueForKeyPath:path placeholder:nil];
            if ([obj isKindOfClass:[NSNull class]])
            {
                return NO;
            }
            NSArray *newPaths = [paths subarrayWithRange:NSMakeRange(1, paths.count - 1)];
            NSString *newKeyPath = [newPaths componentsJoinedByString:@"."];
            
            return [obj hasKeyPath:newKeyPath];
        }
    }
    else
    {
        return NO;
    }
}

@end

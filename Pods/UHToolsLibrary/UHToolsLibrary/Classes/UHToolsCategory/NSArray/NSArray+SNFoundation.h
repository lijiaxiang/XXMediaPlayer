//
//  NSArray+SNFoundation.h
//  SNFoundation
//
//  Created by liukun on 14-3-2.
//  Copyright (c) 2014年 liukun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SNFoundation)

- (id)safeObjectAtIndex:(NSUInteger)index;

- (id)deepCopy;
- (id)mutableDeepCopy;

- (id)trueDeepCopy;
- (id)trueDeepMutableCopy;

@end

#pragma mark -

@interface NSMutableArray (SNFoundation)

+ (id)noRetainingArray;
+ (id)noRetainingArrayWithCapacity:(NSUInteger)capacity;

#pragma 增加或删除对象
- (void)insertObject:(id)object atIndexIfNotNil:(NSUInteger)index;
- (void)moveObjectAtIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex;
- (void)moveObject:(id)object toIndex:(NSUInteger)toIndex;

#pragma mark - 排序
- (void)shuffle;
- (void)reverse;
- (void)unique;
- (void)sorting:(NSString *)parameters ascending:(BOOL)ascending;

#pragma - mark 安全操作
-(void)addObj:(id)i;
-(void)addString:(NSString*)i;
-(void)addBool:(BOOL)i;
-(void)addInt:(int)i;
-(void)addInteger:(NSInteger)i;
-(void)addUnsignedInteger:(NSUInteger)i;
-(void)addCGFloat:(CGFloat)f;
-(void)addChar:(char)c;
-(void)addFloat:(float)i;
-(void)addPoint:(CGPoint)o;
-(void)addSize:(CGSize)o;
-(void)addRect:(CGRect)o;

@end

#pragma mark -

@interface NSMutableDictionary (SNFoundation)

+ (id)noRetainingDictionary;
+ (id)noRetainingDictionaryWithCapacity:(NSUInteger)capacity;

@end

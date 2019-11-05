//
//  NSArray+SNFoundation.m
//  SNFoundation
//
//  Created by liukun on 14-3-2.
//  Copyright (c) 2014年 liukun. All rights reserved.
//

#import "NSArray+SNFoundation.h"

@implementation NSArray (SNFoundation)

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (self.count > index)
    {
        return [self objectAtIndex:index];
    }
    
    return nil;
}

- (id)deepCopy
{
    return [[NSArray alloc] initWithArray:self copyItems:YES];
}

- (id)mutableDeepCopy
{
    return [[NSMutableArray alloc] initWithArray:self copyItems:YES];
}

- (id)trueDeepCopy
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
}

- (id)trueDeepMutableCopy
{
    return [[NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]] mutableCopy];
}

@end

#pragma mark -

// No-ops for non-retaining objects.
static const void *	__TTRetainNoOp( CFAllocatorRef allocator, const void * value ) { return value; }
static void			__TTReleaseNoOp( CFAllocatorRef allocator, const void * value ) { }


@implementation NSMutableArray (SNFoundation)

+ (id)noRetainingArray
{
    return [self noRetainingArrayWithCapacity:0];
}

+ (id)noRetainingArrayWithCapacity:(NSUInteger)capacity
{
    CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
    callbacks.retain = __TTRetainNoOp;
    callbacks.release = __TTReleaseNoOp;
    return (__bridge_transfer NSMutableArray*)CFArrayCreateMutable(nil, capacity, &callbacks);
}


#pragma 增加或删除对象

/**
 *  插入一个元素到指定位置
 *
 *  @param object 需要插入的元素
 *  @param index  位置
 */
- (void)insertObject:(id)object atIndexIfNotNil:(NSUInteger)index
{
    if (self.count > index && object)
    {
        [self insertObject:object atIndex:index];
    }
}

/**
 *  移动对象 从一个位置到另一个位置
 *
 *  @param index   原位置
 *  @param toIndex 目标位置
 */
- (void)moveObjectAtIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex
{
    if (self.count > index && self.count > toIndex)
    {
        id object = [self objectAtIndex:index];
        if (index > toIndex)
        {
            [self removeObjectAtIndex:index];
            [self insertObject:object atIndex:toIndex];
        }
        else if (index < toIndex)
        {
            [self removeObjectAtIndex:index];
            [self insertObject:object atIndex:toIndex - 1];
        }
    }
}

/**
 移动对象 从一个位置到另一个位置

 @param object  原obj
 @param toIndex 目标位置
 */
- (void)moveObject:(id)object toIndex:(NSUInteger)toIndex
{
    [self moveObjectAtIndex:[self indexOfObject:object] toIndex:toIndex];
}

- (void)removeFirstObject
{
    if (self.count > 0)
    {
        [self removeObjectAtIndex:0];
    }
}


#pragma mark - 排序
/**
 *  重组数组(打乱顺序)
 *
 */
- (void)shuffle
{
    NSMutableArray *copy = [self mutableCopy];
    [self removeAllObjects];
    while ([copy count] > 0)
    {
        int index = arc4random() % [copy count];
        id objectToMove = [copy objectAtIndex:index];
        [self addObject:objectToMove];
        [copy removeObjectAtIndex:index];
    }
}

/**
 *  数组倒序
 *
 */
- (void)reverse
{
    NSArray *reversedArray = [[self reverseObjectEnumerator] allObjects];
    [self removeAllObjects];
    [self addObjectsFromArray:reversedArray];
}

/**
 *  数组去除相同的元素
 */
- (void)unique
{
    NSSet *set = [NSSet setWithArray:self];
    NSArray *array = [[NSArray alloc] initWithArray:[set allObjects]];
    [self removeAllObjects];
    [self addObjectsFromArray:array];
}

/**
 *  根据关键词 对本数组的内容进行排序
 *
 *  @param parameters 关键词
 *  @param ascending  YES 升序 NO 降序
 *
 */
- (void)sorting:(NSString *)parameters ascending:(BOOL)ascending
{
    NSSortDescriptor*sorter=[[NSSortDescriptor alloc]initWithKey:parameters ascending:ascending];
    NSMutableArray *sortDescriptors=[[NSMutableArray alloc]initWithObjects:&sorter count:1];
    NSArray *sortArray=[self sortedArrayUsingDescriptors:sortDescriptors];
    [self removeAllObjects];
    [self addObjectsFromArray:sortArray];
}


#pragma - mark 安全操作
/**
 *  添加新对象
 *
 *  添加的对象
 */
- (void)addObj:(id)i
{
    if (i!=nil)
    {
        [self addObject:i];
    }
}

/**
 *  添加字符串
 *
 *  添加的字符串
 */
- (void)addString:(NSString*)i
{
    if (i!=nil)
    {
        [self addObject:i];
    }
}

/**
 *  添加Bool
 *
 *  添加的Bool
 */
- (void)addBool:(BOOL)i
{
    [self addObject:@(i)];
}

/**
 *  添加Int
 *
 *  添加的Int
 */
- (void)addInt:(int)i
{
    [self addObject:@(i)];
}

/**
 *  添加Integer
 *
 *   添加的Integer
 */
- (void)addInteger:(NSInteger)i
{
    [self addObject:@(i)];
}

/**
 *  添加UnsignedInteger
 *
 *  添加的UnsignedInteger
 */
- (void)addUnsignedInteger:(NSUInteger)i
{
    [self addObject:@(i)];
}

/**
 *  添加CGFloat
 *
 *  添加的CGFloat
 */
- (void)addCGFloat:(CGFloat)f
{
    [self addObject:@(f)];
}

/**
 *  添加Char
 *
 *  添加的Char
 */
- (void)addChar:(char)c
{
    [self addObject:@(c)];
}

/**
 *  添加Float
 *
 *  添加的Float
 */
- (void)addFloat:(float)i
{
    [self addObject:@(i)];
}

/**
 *  添加Point
 *
 *  添加的Point
 */
- (void)addPoint:(CGPoint)o
{
    [self addObject:NSStringFromCGPoint(o)];
}

/**
 *  添加Size
 *
 *  添加的Size
 */
- (void)addSize:(CGSize)o
{
    [self addObject:NSStringFromCGSize(o)];
}

/**
 *  添加Rect
 *
 *  添加的Rect
 */
- (void)addRect:(CGRect)o
{
    [self addObject:NSStringFromCGRect(o)];
}

@end


#pragma mark -

@implementation NSMutableDictionary (SNFoundation)

+ (id)noRetainingDictionary
{
    return [self noRetainingDictionaryWithCapacity:0];
}

+ (id)noRetainingDictionaryWithCapacity:(NSUInteger)capacity
{
    CFDictionaryKeyCallBacks keyCallbacks = kCFTypeDictionaryKeyCallBacks;
    CFDictionaryValueCallBacks callbacks = kCFTypeDictionaryValueCallBacks;
    callbacks.retain = __TTRetainNoOp;
    callbacks.release = __TTReleaseNoOp;
    return (__bridge_transfer NSMutableDictionary*)CFDictionaryCreateMutable(nil, 0, &keyCallbacks, &callbacks);
}

@end

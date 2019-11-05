//
//  UHMutableDictionary.m
//  LGVideo
//
//  Created by macRong on 2018/11/28.
//  Copyright © 2018年 孙卫亮. All rights reserved.
//


#import "UHMutableDictionary.h"

@interface UHMutableDictionary()

@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) NSMutableDictionary *dict;

@end

@implementation UHMutableDictionary

- (instancetype)initCommon
{
    self = [super init];
    
    if (self)
    {
        NSString *uuid = [NSString stringWithFormat:@"com.melon.safeThread.dictionary_%p",self];
        _queue = dispatch_queue_create([uuid UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

- (instancetype)init
{
    self = [self initCommon];
    if (self)
    {
        _dict = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems
{
    self = [self initCommon];
    if (self)
    {
        _dict = [NSMutableDictionary dictionaryWithCapacity:numItems];
    }
    
    return self;
}

- (NSDictionary *)initWithContentsOfFile:(NSString *)path
{
    self = [self initCommon];
    if (self)
    {
        _dict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [self initCommon];
    if (self)
    {
        _dict = [[NSMutableDictionary alloc] initWithCoder:aDecoder];
    }
    
    return self;
}

- (instancetype)initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt
{
    self = [self initCommon];
    if (self)
    {
        _dict = [NSMutableDictionary dictionary];
        for (NSUInteger i = 0; i < cnt; ++i)
        {
            _dict[keys[i]] = objects[i];
        }
    }
    
    return self;
}

- (NSUInteger)count
{
    __block NSUInteger count;
    dispatch_sync(_queue, ^{
        count = self->_dict.count;
    });
    
    return count;
}

- (id)objectForKey:(id)aKey
{
    __block id obj;
    dispatch_sync(_queue, ^{
        obj = self->_dict[aKey];
    });
    
    return obj;
}

- (NSEnumerator *)keyEnumerator
{
    __block NSEnumerator *enu;
    dispatch_sync(_queue, ^{
        enu = [self->_dict keyEnumerator];
    });
    
    return enu;
}

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey
{
    aKey = [aKey copyWithZone:NULL];
    
    dispatch_barrier_async(_queue, ^{
        self->_dict[aKey] = anObject;
    });
}

- (void)removeObjectForKey:(id)aKey
{
    dispatch_barrier_async(_queue, ^{
        [self->_dict removeObjectForKey:aKey];
    });
}

- (void)removeAllObjects
{
    dispatch_barrier_async(_queue, ^{
        [self->_dict removeAllObjects];
    });
}

- (NSArray *)allKeys
{
    __block NSArray *arr;
    dispatch_sync(_queue, ^{
        arr = self->_dict.allKeys;
    });
    
    return arr;
}

- (id)copy
{
    __block id copyInstance;
    
    dispatch_sync(_queue, ^{
        copyInstance = [self->_dict copy];
    });
    
    return copyInstance;
}

@end

//
//  NSObject+UHObserverHelper.m
//  LGVideo
//
//  Created by 郭继超 on 2019/1/17.
//  Copyright © 2019 孙卫亮. All rights reserved.
//

#import "NSObject+UHObserverHelper.h"

#import <objc/message.h>

@interface UHObserverHelper : NSObject
@property (nonatomic ,readonly) const char *key;
@property (nonatomic ,unsafe_unretained) id target;
@property (nonatomic ,unsafe_unretained) id observer;
@property (nonatomic ,strong) NSString *keyPath;
@property (nonatomic ,weak) UHObserverHelper *factor;

@end

@implementation UHObserverHelper {
    char *_key;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _key = NULL;
    return self;
}

- (const char *)key {
    if (_key) {
        return _key;
    }
    NSString *keyStr = [NSString stringWithFormat:@"uhuh:%lu", (unsigned long)[self hash]];
    _key = malloc((keyStr.length + 1) * sizeof(char));
    strcpy(_key, keyStr.UTF8String);
    return _key;
}

- (void)dealloc {
    if ( _key ) free(_key);
    if ( _factor ) {
        [_target removeObserver:_observer forKeyPath:_keyPath];
    }
}
@end

@implementation NSObject (UHObserverHelper)

- (void)uh_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:( void *)context {
    NSParameterAssert(observer);
    NSParameterAssert(keyPath);
    if ( !observer || !keyPath ) return;
    NSString *hashStr = [NSString stringWithFormat:@"%lu-%@",(unsigned long)[observer hash],keyPath];
    if ([[self uh_observerHashset] containsObject:hashStr]) {
        return;
    }else {
        [[self uh_observerHashset] addObject:hashStr];
    }
    [self addObserver:observer forKeyPath:keyPath options:options context:context];
    UHObserverHelper *helper = [UHObserverHelper new];
    UHObserverHelper *sub = [UHObserverHelper new];
    
    sub.target = helper.target = self;
    sub.observer = helper.observer = observer;
    sub.keyPath = helper.keyPath = keyPath;
    
    helper.factor = sub;
    sub.factor = helper;
    
    objc_setAssociatedObject(self, helper.key, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(observer, sub.key, sub, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSMutableSet<NSString *> *)uh_observerHashset {
    NSMutableSet<NSString *> *set = objc_getAssociatedObject(self, _cmd);
    if( set ) return set;
    set = [[NSMutableSet alloc] initWithCapacity:10];
    objc_setAssociatedObject(self, _cmd, set, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return set;
}
@end

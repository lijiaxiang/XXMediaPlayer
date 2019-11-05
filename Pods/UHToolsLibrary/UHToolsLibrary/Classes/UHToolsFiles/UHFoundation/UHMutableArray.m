//
//  UHMutableArray.m
//  Pods
//
//  Created by 郭继超 on 2019/1/21.
//

#import "UHMutableArray.h"

@interface UHMutableArray()
{
    CFMutableArrayRef _array;
}
@end

@implementation UHMutableArray

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return [self initWithCapacity:10];
}


- (id)initWithCapacity:(NSUInteger)numItems
{
    self = [super init];
    if (self)
    {
        _array = CFArrayCreateMutable(kCFAllocatorDefault, numItems,  &kCFTypeArrayCallBacks);
    }
    return self;
}
- (NSUInteger)count {
    
    __block NSUInteger result;
    dispatch_sync(self.syncQueue, ^{
        result = CFArrayGetCount(self->_array);
    });
    return result;
}

- (id)objectAtIndex:(NSUInteger)index {
    
    __block id result;
    dispatch_sync(self.syncQueue, ^{
        NSUInteger count = CFArrayGetCount(self->_array);
        result = index<count ? CFArrayGetValueAtIndex(self->_array, index) : nil;
    });
    
    return result;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    __block NSUInteger blockindex = index;
    dispatch_barrier_async(self.syncQueue, ^{
        
        if (!anObject)
        return;
        
        NSUInteger count = CFArrayGetCount(self->_array);
        if (blockindex > count) {
            blockindex = count;
        }
        CFArrayInsertValueAtIndex(self->_array, index, (__bridge const void *)anObject);
        
    });
    
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    dispatch_barrier_async(self.syncQueue, ^{
        
        NSUInteger count = CFArrayGetCount(self->_array);
//        NSLog(@"count:%lu,index:%lu",(unsigned long)count,(unsigned long)index);
        if (index < count) {
            CFArrayRemoveValueAtIndex(self->_array, index);
        }
    });
}

- (void)removeObject:(id)anObject
{
    if (!anObject) return;
    dispatch_barrier_async(self.syncQueue, ^{
        NSUInteger count = CFArrayGetCount(self->_array);
        NSUInteger index = CFArrayGetFirstIndexOfValue(self->_array, CFRangeMake(0, count), (__bridge const void *)(anObject));
        if (index < count) {
            CFArrayRemoveValueAtIndex(self->_array, index);
        }
    });
}

- (void)addObject:(id)anObject
{
    dispatch_barrier_async(self.syncQueue, ^{
        
        if (!anObject)
        return;
        
        CFArrayAppendValue(self->_array, (__bridge const void *)anObject);
        
    });
}

- (void)removeLastObject {
    dispatch_barrier_async(self.syncQueue, ^{
        
        NSUInteger count = CFArrayGetCount(self->_array);
        if (count > 0) {
            CFArrayRemoveValueAtIndex(self->_array, count-1);
        }
        
    });
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    
    
    dispatch_barrier_async(self.syncQueue, ^{
        
        if (!anObject)
        return;
        
        NSUInteger count = CFArrayGetCount(self->_array);
        CFArraySetValueAtIndex(self->_array, index, (__bridge const void*)anObject);
    });
}

#pragma mark Optional
- (void)removeAllObjects
{
    
    dispatch_barrier_async(self.syncQueue, ^{
        CFArrayRemoveAllValues(self->_array);
    });
}

- (NSUInteger)indexOfObject:(id)anObject{
    
    if (!anObject)
    return NSNotFound;
    
    __block NSUInteger result;
    dispatch_sync(self.syncQueue, ^{
        NSUInteger count = CFArrayGetCount(self->_array);
        result = CFArrayGetFirstIndexOfValue(self->_array, CFRangeMake(0, count), (__bridge const void *)(anObject));
    });
    return result;
}

-(BOOL)containsObject:(id)anObject
{
    if (!anObject)
        return NO;
    
    __block NSUInteger result = NO;
    dispatch_sync(self.syncQueue, ^
                  {
                      NSUInteger count = CFArrayGetCount(self->_array);
                      result = CFArrayContainsValue(self->_array, CFRangeMake(0, count), (__bridge const void *)(anObject));
                  });
    return result;
}

#pragma mark - Private
- (dispatch_queue_t)syncQueue {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *uuid = [NSString stringWithFormat:@"com.melon.safeThread.dictionary_%p",self];
        queue = dispatch_queue_create([uuid UTF8String], DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}
- (void)dealloc {
    if (_array) {
        CFRelease(_array);
    }
}
@end


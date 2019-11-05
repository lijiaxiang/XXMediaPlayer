//
//  NSObject+UHObserverHelper.h
//  LGVideo
//
//  Created by 郭继超 on 2019/1/17.
//  Copyright © 2019 孙卫亮. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (UHObserverHelper)

/**
  添加观察者无需使用者自己移除

 @param observer 观察
 @param keyPath g观察对象
 @param options new | old
 @param context 上下文
 */
- (void)uh_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context;
@end

NS_ASSUME_NONNULL_END

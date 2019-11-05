//
//  UHMutableDictionary.h
//  LGVideo
//
//  Created by macRong on 2018/11/28.
//  Copyright © 2018年 孙卫亮. All rights reserved.
//

/**
  线程安全 NSMutableDictionary
 */
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface UHMutableDictionary <KeyType, ObjectType>: NSMutableDictionary<KeyType, ObjectType>

@end

NS_ASSUME_NONNULL_END

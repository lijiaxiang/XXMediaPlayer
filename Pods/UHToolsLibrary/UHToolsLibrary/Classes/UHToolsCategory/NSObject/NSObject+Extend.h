//
//  NSObject+Extend.h
//  LGVideo
//
//  Created by 程宏愿 on 2018/8/14.
//  Copyright © 2018年 程宏愿. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extend)

/**
 *  返回任意对象的字符串式的内存地址
 */
- (NSString *)address;

/**
 *  调用方法
 */
- (void)callSelectorWithSelString:(NSString *)selString paramObj:(id)paramObj;

@end

//
//  NSURL+UHParam.h
//  UHToolsLibrary
//
//  Created by coderyi on 2019/7/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (UHParam)
/**
 *  @brief  url参数转字典
 *
 *  @return 参数转字典结果
 */
- (NSDictionary *)uh_parameters;
/**
 *  @brief  根据参数名 取参数值
 *
 *  @param parameterKey 参数名的key
 *
 *  @return 参数值
 */
- (NSString *)uh_valueForParameter:(NSString *)parameterKey;

@end

NS_ASSUME_NONNULL_END

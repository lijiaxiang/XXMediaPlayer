//
//  NSURL+UHParam.m
//  UHToolsLibrary
//
//  Created by coderyi on 2019/7/22.
//

#import "NSURL+UHParam.h"

@implementation NSURL (UHParam)
/**
 *  @brief  url参数转字典
 *
 *  @return 参数转字典结果
 */
- (NSDictionary *)uh_parameters
{
    NSMutableDictionary * parametersDictionary = [NSMutableDictionary dictionary];
    NSArray * queryComponents = [self.query componentsSeparatedByString:@"&"];
    for (NSString * queryComponent in queryComponents) {
        NSString * key = [queryComponent componentsSeparatedByString:@"="].firstObject;
        NSString * value = [queryComponent substringFromIndex:(key.length + 1)];
        [parametersDictionary setObject:value forKey:key];
    }
    return parametersDictionary;
}
/**
 *  @brief  根据参数名 取参数值
 *
 *  @param parameterKey 参数名的key
 *
 *  @return 参数值
 */
- (NSString *)uh_valueForParameter:(NSString *)parameterKey
{
    return [[self uh_parameters] objectForKey:parameterKey];
}

@end

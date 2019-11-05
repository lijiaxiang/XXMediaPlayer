//
//  NSString+SNFoundation.h
//  SNFoundation
//
//  Created by liukun on 14-3-3.
//  Copyright (c) 2014年 liukun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SNFoundation)

- (NSString *)urlByAppendingDict:(NSDictionary *)params;
- (NSString *)urlByAppendingDictNoEncode:(NSDictionary *)params;

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict addingPercentEscapes:(BOOL)add;
- (NSDictionary *)queryDictionaryUsingEncoding:(NSStringEncoding)encoding;

#pragma mark--URL编码
/// URL编码
- (NSString *)URLEncoding;
#pragma mark--URL解码
/// URL解码
- (NSString *)URLDecoding;

- (NSString *)trim;
- (BOOL)isEmpty;
- (BOOL)eq:(NSString *)other;

- (BOOL)isValueOf:(NSArray *)array;
- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens;

- (NSString *)getterToSetter;
- (NSString *)setterToGetter;

- (NSString *)formatJSON;
+ (NSString *)GUIDString;
- (NSString *)removeHtmlTags;

- (BOOL)has4ByteChar;
- (BOOL)isAsciiString;

///NSString >> NSDictionary
-(NSDictionary *)toDictionary;

- (NSComparisonResult)asciiCompareToString:(NSString *)anotherString;

@end

#pragma mark -

@interface NSString (SNEncryption)

- (NSString *)MD5Hex;
- (NSData *)hexStringToData;    //从16进制的字符串格式转换为NSData

/// Base64普通加密
- (NSString *)base64NormalEncrpt;
/// Base64普通解密
- (NSString *)base64NormalDecrypt;

@end


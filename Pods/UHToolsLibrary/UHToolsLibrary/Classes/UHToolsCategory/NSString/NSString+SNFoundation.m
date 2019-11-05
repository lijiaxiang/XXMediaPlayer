//
//  NSString+SNFoundation.m
//  SNFoundation
//
//  Created by liukun on 14-3-3.
//  Copyright (c) 2014年 liukun. All rights reserved.
//

#import "NSString+SNFoundation.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

@implementation NSString (SNFoundation)

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict addingPercentEscapes:(BOOL)add
{
    NSMutableArray * pairs = [NSMutableArray array];
    for ( NSString * key in [dict keyEnumerator] )
    {
        id value = [dict valueForKey:key];
        if ([value isKindOfClass:[NSNumber class]])
        {
            value = [value stringValue];
        }
        else if ([value isKindOfClass:[NSString class]])
        {
            
        }
        else
        {
            continue;
        }
        
        [pairs addObject:[NSString stringWithFormat:@"%@=%@",
                          add?[key URLEncoding]:key,
                          add?[value URLEncoding]:value]];
    }
    
    return [pairs componentsJoinedByString:@"&"];
}

- (NSDictionary*)queryDictionaryUsingEncoding:(NSStringEncoding)encoding
{
    NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    NSScanner* scanner = [[NSScanner alloc] initWithString:self];
    while (![scanner isAtEnd])
    {
        NSString* pairString = nil;
        [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
        [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
        NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
        if (kvPair.count == 2)
        {
            NSString* key = [[[kvPair objectAtIndex:0]
                              stringByReplacingPercentEscapesUsingEncoding:encoding] trim];
            NSString* value = [[[kvPair objectAtIndex:1]
                                stringByReplacingPercentEscapesUsingEncoding:encoding] trim];
            [pairs setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:pairs];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)params
{
    NSURL *parsedURL = [NSURL URLWithString:self];
    NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
    NSString *query = [NSString queryStringFromDictionary:params addingPercentEscapes:YES];
    
    return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];
}

- (NSString *)urlByAppendingDictNoEncode:(NSDictionary *)params
{
    NSURL *parsedURL = [NSURL URLWithString:self];
    NSString *queryPrefix = parsedURL.query ? @"&" : @"?";
    NSString *query = [NSString queryStringFromDictionary:params addingPercentEscapes:NO];
    
    return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];
}


#pragma mark --URL编码
/// URL编码
- (NSString *)URLEncoding
{
    return   CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
}


#pragma mark--URL解码
/// URL解码
- (NSString *)URLDecoding
{
    NSMutableString *outputStr = [NSMutableString stringWithString:self];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isEmpty
{
    return [self length] > 0 ? NO : YES;
}

- (BOOL)eq:(NSString *)other
{
    return [self isEqualToString:other];
}

- (BOOL)isValueOf:(NSArray *)array
{
    return [self isValueOf:array caseInsens:NO];
}

- (BOOL)isValueOf:(NSArray *)array caseInsens:(BOOL)caseInsens
{
    NSStringCompareOptions option = caseInsens ? NSCaseInsensitiveSearch : 0;
    
    for ( NSObject * obj in array )
    {
        if ( NO == [obj isKindOfClass:[NSString class]] )
            continue;
        
        if ( [(NSString *)obj compare:self options:option] == NSOrderedSame )
            return YES;
    }
    
    return NO;
}

- (NSString *)getterToSetter
{
    NSRange firstChar, rest;
    firstChar.location  = 0;
    firstChar.length    = 1;
    rest.location       = 1;
    rest.length         = self.length - 1;
    
    return [NSString stringWithFormat:@"set%@%@:",
            [[self substringWithRange:firstChar] uppercaseString],
            [self substringWithRange:rest]];
}


- (NSString *)setterToGetter
{
    NSRange firstChar, rest;
    firstChar.location  = 3;
    firstChar.length    = 1;
    rest.location       = 4;
    rest.length         = self.length - 5;
    
    return [NSString stringWithFormat:@"%@%@",
            [[self substringWithRange:firstChar] lowercaseString],
            [self substringWithRange:rest]];
}

- (NSString *)formatJSON
{
    int indentLevel = 0;
    BOOL inString    = NO;
    char currentChar = '\0';
    char *tab = "    ";
    
    NSUInteger len = [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    const char *utf8 = [self UTF8String];
    NSMutableData *buf = [NSMutableData dataWithCapacity:(NSUInteger)(len * 1.1f)];
    
    for (int i = 0; i < len; i++)
    {
        currentChar = utf8[i];
        switch (currentChar)
        {
            case '{':
            case '[':
                if (!inString)
                {
                    [buf appendBytes:&currentChar length:1];
                    [buf appendBytes:"\n" length:1];
                    
                    for (int j = 0; j < indentLevel+1; j++)
                    {
                        [buf appendBytes:tab length:strlen(tab)];
                    }
                    
                    indentLevel += 1;
                }
                else
                {
                    [buf appendBytes:&currentChar length:1];
                }
                break;
            case '}':
            case ']':
                if (!inString)
                {
                    indentLevel -= 1;
                    [buf appendBytes:"\n" length:1];
                    for (int j = 0; j < indentLevel; j++)
                    {
                        [buf appendBytes:tab length:strlen(tab)];
                    }
                    [buf appendBytes:&currentChar length:1];
                }
                else
                {
                    [buf appendBytes:&currentChar length:1];
                }
                break;
            case ',':
                if (!inString)
                {
                    [buf appendBytes:",\n" length:2];
                    for (int j = 0; j < indentLevel; j++)
                    {
                        [buf appendBytes:tab length:strlen(tab)];
                    }
                }
                else
                {
                    [buf appendBytes:&currentChar length:1];
                }
                break;
            case ':':
                if (!inString)
                {
                    [buf appendBytes:":" length:1];
                }
                else
                {
                    [buf appendBytes:&currentChar length:1];
                }
                break;
            case ' ':
            case '\n':
            case '\t':
            case '\r':
                if (inString)
                {
                    [buf appendBytes:&currentChar length:1];
                }
                break;
            case '"':
                
                if (i > 0 && utf8[i-1] != '\\')
                {
                    inString = !inString;
                }
                
                [buf appendBytes:&currentChar length:1];
                break;
            default:
                [buf appendBytes:&currentChar length:1];
                break;
        }
    }
    
    return [[NSString alloc] initWithData:buf encoding:NSUTF8StringEncoding];
}

+ (NSString *)GUIDString
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    
    return (__bridge_transfer NSString *)string;
}

- (NSString *)removeHtmlTags
{
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"<[^>]+>" options:0 error:NULL];
    
    return [regex stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length) withTemplate:@""];
}

- (BOOL)has4ByteChar
{
    __block BOOL has4Byte = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              
                              if ([substring lengthOfBytesUsingEncoding:NSUTF8StringEncoding] >= 4)
                              {
                                  has4Byte = YES;
                                  *stop = YES;
                              }
                          }];
    return has4Byte;
}

- (BOOL)isAsciiString
{
    return [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == [self length];
}

///NSString >> NSDictionary
- (NSDictionary *)toDictionary
{
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    
    return dic;
}

- (NSComparisonResult)asciiCompareToString:(NSString *)anotherString
{
    NSUInteger len1 = [self length];
    NSUInteger len2 = [anotherString length];
    
    if (len1 < len2)
    {
        int i = 0;
        
        while ( i < len1 && [self characterAtIndex:i] == [anotherString characterAtIndex:i]  )
        {
            i++;
        }
        
        if (i == len1)
        {
            return NSOrderedAscending;
        }
        else if ([self characterAtIndex:i] < [anotherString characterAtIndex:i])
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedDescending;
        }
    }
    else
    { // str1 >= str2 len
        int i = 0;
        
        while ( i<len2 && [self characterAtIndex:i] == [anotherString characterAtIndex:i])
        {
            i++;
        }
        
        if (i == len2 && i == len1)
        {
            return NSOrderedSame;
        }
        else if (i == len2)
        {
            return NSOrderedDescending;
        }
        else if ([self characterAtIndex:i] < [anotherString characterAtIndex:i])
        {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedDescending;
        }
    }
    
    return NSOrderedSame;
}

@end


#pragma mark -----------------------------

@implementation NSString (SNEncryption)

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";


- (NSString *)MD5Hex
{
    const char *str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++)
    {
        [ret appendFormat:@"%02x",result[i]];
    }
    
    return ret;
}

- (NSData *)hexStringToData
{
    if (!self.length)
    {
        return nil;
    }
    
    const char *ch = [[self lowercaseString] cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableData* data = [[NSMutableData alloc] initWithCapacity:strlen(ch)/2];
    while (*ch)
    {
        char byte = 0;
        if ('0' <= *ch && *ch <= '9')
        {
            byte = *ch - '0';
        }
        else if ('a' <= *ch && *ch <= 'f')
        {
            byte = *ch - 'a' + 10;
        }
        ch++;
        byte = byte << 4;
        if (*ch)
        {
            if ('0' <= *ch && *ch <= '9')
            {
                byte += *ch - '0';
            } else if ('a' <= *ch && *ch <= 'f')
            {
                byte += *ch - 'a' + 10;
            }
            ch++;
        }
        
        [data appendBytes:&byte length:1];
    }
    
    return data;
}


#pragma mark -- Base64 加密
#pragma mark -- Base64普通加密

- (NSString *)base64NormalEncrpt
{
    NSData *nsdata = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    return base64Encoded;
   
}

#pragma Mark -- Base64普通解密

- (NSString *)base64NormalDecrypt
{
    NSData *nsdataFromBase64String = [[NSData alloc]
                                      initWithBase64EncodedString:self options:0];
    NSString *base64Decoded = [[NSString alloc]
                               initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    return base64Decoded;
}


/************************************************************
 函数名称 : + (NSData *)dataWithBase64EncodedString:(NSString *)string
 函数描述 : base64格式字符串转换为文本数据
 输入参数 : (NSString *)string
 输出参数 : N/A
 返回参数 : (NSData *)
 备注信息 :
 **********************************************************/
- (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:@""];
    if ([string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

@end

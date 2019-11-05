//
//  APPTools.h
//  
//
//  Created by mac on 14-12-31.
//  Copyright (c) 2014年 yusen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


///yyyyMMddHHmmssSSS
/// dingyi @"YY-MM-dd HH:mm"
#define APPToolsDateFormartMM_DD                @"MM-dd"
#define APPToolsDateFormartYY_MM_DD             @"YY-MM-dd"
#define APPToolsDateFormartYYYYMMDD1            @"YYYYMMdd"
#define APPToolsDateFormartYYMMDD_HHMM1         @"YYMMdd HH:mm"
#define APPToolsDateFormartYYMMDD_HHMM2_        @"YY-MM-dd HH:mm"
#define APPToolsDateFormartYYMMDD_HHMMSS1       @"YYMMdd HH:mm:ss"
#define APPToolsDateFormartYYMMDD_HHMMSS2_      @"YY-MM-dd HH:mm:ss"
#define APPToolsDateFormartYYYYMMDDHHMMSS       @"YYYYMMddHHmmss"
#define APPToolsDateFormartHHMM                 @"HH:mm"

@interface UHAPPTools : NSObject


#pragma mark - 验证

/// 手机号码验证
+ (BOOL)isMobileNumber:(NSString *)mobile;

///根据颜色 frame 获取image
+ (UIImage*)imageWithColorOneWidthHeight:(UIColor *)color;

///--根据时间Date 计算 时间戳
+ (NSString *)getDateIntervalSince1970:(NSDate *)date;

///--根据时间Date formart 计算字符串
+ (NSString *)getDateString:(NSDate *)date formart:(NSString *)formart;//"YYYY-MM-dd HH:ss"
//
///--根据时间戳 formart 计算字符串
+ (NSString *)getDateStringWithShiJianChuo:(NSString *)timeChuo formart:(NSString *)formart;//"YYYY-MM-dd HH:ss"

///根据高度 计算宽度
+ (CGSize)adaptiveWidthWithString:(NSString *)string font:(UIFont *)font fixedHeight:(CGFloat)height;

/** url参数转成dic
 (如：lazyrp://lazymelon.com/h5_detail?vid=123&jid=567)

 return: {vid: 123, jid: 567}
 */
+ (NSDictionary *)getURLPargramValue:(NSString *)queryString;

@end

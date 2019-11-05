//
//  SPrivacyWorking.h
//  FreeMusic
//
//  Created by air on 16/11/4.
//  Copyright © 2016年 weiliang.soon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SPrivacyWorkingType) {
    SPrivacyWorkingType_Unknow,
    SPrivacyWorkingType_Refuse,
    SPrivacyWorkingType_Allow,
};
@interface SPrivacyWorking : NSObject

#pragma mark--查看相册权限
+ (void)privacyPhotoLibrary:(void(^)(SPrivacyWorkingType type))result;

#pragma mark--查看媒体音乐库权限
+ (void)privacyMediaLibrary:(void(^)(SPrivacyWorkingType type))result;

#pragma mark--查看网络权限
+ (void)privacyNetWork:(void(^)(SPrivacyWorkingType type))result;

#pragma mark - 获取相机/麦克风权限
///相机权限
+ (void)privacyCamera_video:(void(^)(SPrivacyWorkingType type))result;
///麦克风权限
+ (void)privacyCamera_audio:(void(^)(SPrivacyWorkingType type))result;

#pragma mark--打开设置
+ (void)openSetting;

#pragma mark --  定位权限-不能够自动请求权限
///暂时关闭，apple有检测
//+ (void)privacyLocationServices:(void(^)(SPrivacyWorkingType type))result;

#pragma mark - 检查是否有通知权限
+ (void)privacyNotificationServices:(void(^)(SPrivacyWorkingType type))result;

@end

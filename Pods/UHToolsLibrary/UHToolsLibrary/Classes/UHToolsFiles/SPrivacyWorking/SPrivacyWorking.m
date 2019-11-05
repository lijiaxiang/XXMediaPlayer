//
//  SPrivacyWorking.m
//  FreeMusic
//
//  Created by air on 16/11/4.
//  Copyright © 2016年 weiliang.soon. All rights reserved.
//

#import "SPrivacyWorking.h"
#import <Photos/Photos.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CoreTelephony/CTCellularData.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>
#import "UHSystemInfo.h"

@implementation SPrivacyWorking


#pragma mark--查看相册权限
+ (void)privacyPhotoLibrary:(void(^)(SPrivacyWorkingType type))result{
    //    typedef NS_ENUM(NSInteger, PHAuthorizationStatus) {
    //        PHAuthorizationStatusNotDetermined = 0, // 未询问用户是否授权
    //        PHAuthorizationStatusRestricted, // 未授权，例如家长控制
    //        PHAuthorizationStatusDenied, // 未授权，用户拒绝造成的
    //        PHAuthorizationStatusAuthorized// 已授权}
    PHAuthorizationStatus photoAuthStatus = [PHPhotoLibrary authorizationStatus];
    if (photoAuthStatus == PHAuthorizationStatusNotDetermined) {
        //未知
        if (result) {
            result(SPrivacyWorkingType_Unknow);
        }
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                // 用户同意授权
                if (result) {
                    result(SPrivacyWorkingType_Allow);
                }
            }else {
                // 用户拒绝授权
                if (result) {
                    result(SPrivacyWorkingType_Refuse);
                }
            }
        }];
    }else if(photoAuthStatus == PHAuthorizationStatusRestricted || photoAuthStatus == PHAuthorizationStatusDenied) {
        // 未授权
        if (result) {
            result(SPrivacyWorkingType_Refuse);
        }
    }else{
        // 已授权
        if (result) {
            result(SPrivacyWorkingType_Allow);
        }
    }
}

#pragma mark--查看媒体音乐库权限
+ (void)privacyMediaLibrary:(void(^)(SPrivacyWorkingType type))result{
    
    if (@available(iOS 9.3, *)) {
        
        MPMediaLibraryAuthorizationStatus status=[MPMediaLibrary authorizationStatus];
        if (status == MPMediaLibraryAuthorizationStatusNotDetermined) {
            //未知
            if (result) {
                result(SPrivacyWorkingType_Unknow);
            }
            [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                
                if (status == MPMediaLibraryAuthorizationStatusAuthorized) {
                    // 用户同意授权
                    if (result) {
                        result(SPrivacyWorkingType_Allow);
                    }
                }else {
                    // 用户拒绝授权
                    if (result) {
                        result(SPrivacyWorkingType_Refuse);
                    }
                }
            }];
        }else if(status == MPMediaLibraryAuthorizationStatusRestricted || status == MPMediaLibraryAuthorizationStatusDenied) {
            // 未授权
            if (result) {
                result(SPrivacyWorkingType_Refuse);
            }
        }else{
            // 已授权
            if (result) {
                result(SPrivacyWorkingType_Allow);
            }
        }
        
    }else{
        [MPMediaQuery songsQuery];
    }
}

#pragma mark--查看网络权限
///应用启动后，检测应用中是否有联网权限
+ (void)privacyNetWork:(void(^)(SPrivacyWorkingType type))result{
    
    if (@available(iOS 9.0, *)) {
        
        //应用启动后，检测应用中是否有联网权限
        CTCellularData *cellularData1 = [[CTCellularData alloc] init];
        cellularData1.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
            //获取联网状态
            switch (state) {
                case kCTCellularDataRestricted:
                {
                    if (result) {
                        result(SPrivacyWorkingType_Refuse);
                    }
                }
                    break;
                case kCTCellularDataNotRestricted:
                {
                    if (result) {
                        result(SPrivacyWorkingType_Allow);
                    }
                }
                    break;
                case kCTCellularDataRestrictedStateUnknown:
                {
                    if (result) {
                        result(SPrivacyWorkingType_Unknow);
                    }
                }
                    break;
                default:
                    break;
            };
        };
    }
}

/////查询应用是否有联网功能
//+ (void)privacyNetWorkFunction:(void(^)(SPrivacyWorkingType type))result{
//    
//    if (APPSYSTEMAVAILABLE(9.0)) {
//        
//        CTCellularData *cellularData = [[CTCellularData alloc]init];
//        CTCellularDataRestrictedState state = cellularData.restrictedState;
//        switch (state) {
//            case kCTCellularDataRestricted:
//                NSLog(@"Restricrted");
//                break;
//            case kCTCellularDataNotRestricted:
//                NSLog(@"Not Restricted");
//                break;
//            case kCTCellularDataRestrictedStateUnknown:
//                NSLog(@"Unknown");
//                break;
//            default:
//                break;
//        }
//    }
//}



#pragma mark - 获取相机/麦克风权限
///相机权限
+ (void)privacyCamera_video:(void(^)(SPrivacyWorkingType type))result{
    [SPrivacyWorking privacyCamera_type:AVMediaTypeVideo result:result];
}
///麦克风权限
+ (void)privacyCamera_audio:(void(^)(SPrivacyWorkingType type))result{
    [SPrivacyWorking privacyCamera_type:AVMediaTypeAudio result:result];
}
///相机权限
+ (void)privacyCamera_type:(AVMediaType)type result:(void(^)(SPrivacyWorkingType type))result{
    
    //相机权限
    AVAuthorizationStatus videoStatus = [AVCaptureDevice authorizationStatusForMediaType:type];
    
    switch (videoStatus) {
        case AVAuthorizationStatusAuthorized:
            NSLog(@"Authorized");
            if (result) {
                result(SPrivacyWorkingType_Allow);
            }
            break;
        case AVAuthorizationStatusDenied:
            NSLog(@"Denied");
            if (result) {
                result(SPrivacyWorkingType_Refuse);
            }
            break;
        case AVAuthorizationStatusNotDetermined:
        {
            NSLog(@"not Determined");
            [self privacyCamera_video_request:type handler:^(BOOL granted) {
                if (granted) {
                    if (result) {
                        result(SPrivacyWorkingType_Allow);
                    }
                }else{
                    if (result) {
                        result(SPrivacyWorkingType_Refuse);
                    }
                }
            }];
            break;
        }
        case AVAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            if (result) {
                result(SPrivacyWorkingType_Refuse);
            }
            break;
        default:
            break;
    }
}

///请求相机权限
+(void)privacyCamera_video_request:(AVMediaType)type handler:(void (^)(BOOL granted))handler{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {//相机权限
        if (handler) {
            handler(granted);///同意是YES
        }
    }];
}


#pragma mark -  定位权限 -不能够自动请求权限
//+ (void)privacyLocationServices:(void(^)(SPrivacyWorkingType type))result{
//
//    ///检查是否有定位权限
//    BOOL isLocation = [CLLocationManager locationServicesEnabled];
//    if (!isLocation) {
//        NSLog(@"not turn on the location");
//        if (result) {
//            result(SPrivacyWorkingType_Refuse);
//        }
//    }else{
//
//        CLAuthorizationStatus CLstatus = [CLLocationManager authorizationStatus];
//        switch (CLstatus) {
//            case kCLAuthorizationStatusAuthorizedAlways:
//                NSLog(@"Always Authorized");
//                if (result) {
//                    result(SPrivacyWorkingType_Allow);
//                }
//                break;
//            case kCLAuthorizationStatusAuthorizedWhenInUse:
//                NSLog(@"AuthorizedWhenInUse");
//                if (result) {
//                    result(SPrivacyWorkingType_Allow);
//                }
//                break;
//            case kCLAuthorizationStatusDenied:
//                NSLog(@"Denied 拒绝了");
//                if (result) {
//                    result(SPrivacyWorkingType_Refuse);
//                }
//                break;
//            case kCLAuthorizationStatusNotDetermined:
//            {
//                NSLog(@"not Determined 未确定");
//                if (result) {
//                    result(SPrivacyWorkingType_Unknow);
//                }
//            }
//                break;
//            case kCLAuthorizationStatusRestricted:
//                NSLog(@"Restricted 限制");
//                if (result) {
//                    result(SPrivacyWorkingType_Refuse);
//                }
//                break;
//            default:
//                break;
//        }
//
//    }
//}


/*
 获取定位权限
 CLLocationManager *manager = [[CLLocationManager alloc] init];
 [manager requestAlwaysAuthorization];//一直获取定位信息
 [manager requestWhenInUseAuthorization];//使用的时候获取定位信息
 在代理方法中查看权限是否改变
 
 - (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{ switch (status) {
 case kCLAuthorizationStatusAuthorizedAlways:
 NSLog(@"Always Authorized");
 break;
 case kCLAuthorizationStatusAuthorizedWhenInUse:
 NSLog(@"AuthorizedWhenInUse");
 break;
 case kCLAuthorizationStatusDenied:
 NSLog(@"Denied");
 break;
 case kCLAuthorizationStatusNotDetermined:
 NSLog(@"not Determined");
 break;
 case kCLAuthorizationStatusRestricted:
 NSLog(@"Restricted");
 break;
 default:
 break;
 }
 
 }
 */


#pragma mark --  检查是否有通讯权限

/*
 UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];switch (settings.types) {
 case UIUserNotificationTypeNone:
 NSLog(@"None");
 break;
 case UIUserNotificationTypeAlert:
 NSLog(@"Alert Notification");
 break;
 case UIUserNotificationTypeBadge:
 NSLog(@"Badge Notification");
 break;
 case UIUserNotificationTypeSound:
 NSLog(@"sound Notification'");
 break;
 default:
 break;
 }
 */

#pragma mark - 检查是否有通知权限
+ (void)privacyNotificationServices:(void(^)(SPrivacyWorkingType type))result{
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
        
        if (@available(iOS 10.0, *)) {
            [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings *settings) {
                
                if (settings.authorizationStatus == UNAuthorizationStatusNotDetermined) {
                    if (result) {
                        result(SPrivacyWorkingType_Unknow);
                    }
                }else if (settings.authorizationStatus == UNAuthorizationStatusDenied){
                    if (result) {
                        result(SPrivacyWorkingType_Refuse);
                    }
                }else if (settings.authorizationStatus == UNAuthorizationStatusAuthorized){
                    if (result) {
                        result(SPrivacyWorkingType_Allow);
                    }
                }
                //                notDetermined 没有声明 用户没有选择程序是否可能发布用户通知
                //                denied 用户坚决的拒绝,应用程序不能授权和发送通知
                //                authorized 应用程序获取授权可以发送通知
                
            }];
        }
        
        
    }else if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0") && SYSTEM_VERSION_LESS_THAN(@"10.0")){
        
        ///获取通知类型
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (setting.types == 0) {
            if (result) {
                result(SPrivacyWorkingType_Refuse);
            }
        }else{
            if (result) {
                result(SPrivacyWorkingType_Allow);
            }
        }
        /*
         settings.types 有以下几种状态
         0 => none                  不允许通知 UIUserNotificationTypeNone
         1 => badge                 只允许应用图标标记 UIUserNotificationTypeBadge
         2 => sound                 只允许声音 UIUserNotificationTypeBadge
         3 => sound + badge         允许声音+应用图标标记
         4 => alert                 只允许提醒 UIUserNotificationTypeAlert
         5 => alert + badge         允许提醒+应用图标标记
         6 => alert + sound         允许提醒+声音
         7 => alert + sound + badge 三种都允许
         */
        
    }else{
        NSLog(@"8-");
        //            UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        //            if (type != UIRemoteNotificationTypeNone) {
        //                isOpen = YES;
        //            }
    }
}

#pragma mark--打开设置
+ (void)openSetting{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

@end

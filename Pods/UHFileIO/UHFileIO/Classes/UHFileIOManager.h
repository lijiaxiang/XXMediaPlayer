//
//  UHFileIOManager.h
//  UHFileIO_Example
//
//  Created by macRong on 2019/5/8.
//  Copyright © 2019 MacRong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UHFileManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface UHFileIOManager : NSObject


#pragma mark - 业务相关

/// Documents (/Documents/UHVideo)
@property (nonatomic, class, copy, readonly) NSString *uh_pathdocumentsDirectory;
/// Library (/Library/UHVideo)
@property (nonatomic, class, copy, readonly) NSString *uh_pathForLibraryDirectory;
/// Caches (/Library/Caches/UHVideo)
@property (nonatomic, class, copy, readonly) NSString *uh_pathForCachesDirectory;
/// tmp (/tmp/UHVideo)
@property (nonatomic, class, copy, readonly) NSString *uh_pathForTemporaryDirectory;



#pragma mark - ———————————————— 增  ————————————————

/// 创建目录(如果存在就不创建)
+ (BOOL)createDirectoriesForPath:(NSString *)path error:(NSError * _Nullable __autoreleasing * _Nullable)error;
/// 创建文件
+ (BOOL)createFileAtPath:(NSString *)path error:(NSError * _Nullable __autoreleasing * _Nullable)error;
/// 写入数据
+ (BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError *_Nullable __autoreleasing * _Nullable)error;


#pragma mark - ———————————————— 删  ————————————————

/// 删除整个目录
+ (BOOL)removeFilesInDirectoryAtPath:(NSString *)path error:(NSError * _Nullable __autoreleasing * _Nullable)error;
/// 删除文件
+ (BOOL)removeItemAtPath:(NSString *)path error:(NSError * _Nullable __autoreleasing * _Nullable)error;


#pragma mark - ———————————————— 改  ————————————————

/// 移动文件
+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError *_Nullable __autoreleasing * _Nullable)error;
/// 重命名
+ (BOOL)renameItemAtPath:(NSString *)path withName:(NSString *)name error:(NSError *_Nullable __autoreleasing * _Nullable)error;
/// 拷贝文件到某文件路径
+ (BOOL)copyFile:(NSString *)sourcePath toPath:(NSString *)toPath;


#pragma mark - ———————————————— 查  ————————————————

/// 路径是否存在
+ (BOOL)existsItemAtPath:(NSString *)path;

/// Document路径
+ (NSString *)pathForDocumentsDirectory;
/// 获取resourceBundle路径
+ (NSString *)pathForMainBundleDirectory;
/// 获取沙盒中的路径
+ (NSString *)pathForApplicationSupportDirectory;
/// 获取cache路径 （Library/Cache/ 用于存放应用程序专用的支持文件，保存应用程序再次启动过程中需要的信息）
+ (NSString *)pathForCachesDirectory;
/// 获取Library路径
+ (NSString *)pathForLibraryDirectory;
/// 获取Temp路径 （这个目录用于存放临时文件，保存应用程序再次启动过程中不需要的信息）
+ (NSString *)pathForTemporaryDirectory;

/// 查找指定文件路径
+ (NSNumber *)sizeOfItemAtPath:(NSString *)path error:(NSError *_Nullable __autoreleasing * _Nullable)error;
/// 获取指定目录的文件大小 返回多少M
+ (CGFloat)folderSizeAtPath:(NSString*)folderPath;
/// 获取指定文件的文件大小
+ (long long)fileSizeAtPath:(NSString*)filePath;

@end

NS_ASSUME_NONNULL_END


/**
 1. 异同步队列请根据自己需求做
 
 
 */

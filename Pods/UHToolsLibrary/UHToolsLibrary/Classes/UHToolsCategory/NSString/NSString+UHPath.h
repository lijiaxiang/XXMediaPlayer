//
//  NSString+UHPath.h
//  LGVideo
//
//  Created by 程宏愿 on 2018/12/24.
//  Copyright © 2018 孙卫亮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UHPath)

/// 程序目录，不能存任何东西
+ (NSString *)getAppPath;

/// 文档目录，需要ITUNES同步备份的数据存这里
+ (NSString *)getDocPath;

/// 配置目录，配置文件存这里
+ (NSString *)getLibPrefPath;

/// 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)getLibCachePath;

/// 缓存目录，APP退出后，系统可能会删除这里的内容
+ (NSString *)getTmpPath;

/// 创建目录   文件夹是否存在，不存在则创建对应文件夹
+ (BOOL)creatPath:(NSString *)path;

/// 是否存在某文件/目录
+ (BOOL)isDirExist:(NSString *)path;


#pragma mark - 获取文件或者文件夹大小
/// 获取指定文件的文件大小
+ (long long)fileSizeAtPath:(NSString*) filePath;

#pragma mark -- 获取指定文目录的文件
+(NSArray *)folderFilesAtPath:(NSString*) folderPath;

/// 获取指定目录的文件大小 返回多少M
+ (CGFloat)folderSizeAtPath:(NSString*) folderPath;

/// 清除path文件夹下缓存大小
+ (BOOL)clearCacheWithFilePath:(NSString *)path;

///删除文件
+ (BOOL)deleteFileWithPath:(NSString *)filePath;

/// 拷贝文件到某文件路径
+ (BOOL)copyFile:(NSString *)sourcePath toPath:(NSString *)toPath;

@end

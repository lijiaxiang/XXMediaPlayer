//
//  NSString+UHPath.m
//  LGVideo
//
//  Created by 程宏愿 on 2018/12/24.
//  Copyright © 2018 孙卫亮. All rights reserved.
//

#import "NSString+UHPath.h"

@implementation NSString (UHPath)


#pragma mark - 关于目录

/// 程序目录，不能存任何东西
+ (NSString *)getAppPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

/// 文档目录，需要ITUNES同步备份的数据存这里
+ (NSString *)getDocPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

/// 配置目录，配置文件存这里
+ (NSString *)getLibPrefPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
}

/// 缓存目录，系统永远不会删除这里的文件，ITUNES会删除
+ (NSString *)getLibCachePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

/// 缓存目录，APP退出后，系统可能会删除这里的内容
+ (NSString *)getTmpPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    return [[paths objectAtIndex:0] stringByAppendingFormat:@"/tmp"];
}

/// 创建目录   文件夹是否存在，不存在则创建对应文件夹
+ (BOOL)creatPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if (!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        return bCreateDir;
    }
    else
    {
        return YES;
    }
}

/// 是否存在某文件/目录
+ (BOOL)isDirExist:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:nil];
    
    return isDirExist;
}


#pragma mark -- 获取指定文件的文件大小

+ (long long) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}


#pragma mark -- 获取指定文目录的文件

+(NSArray *)folderFilesAtPath:(NSString*) folderPath
{
    NSArray *ary = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath error:nil];
    
    return ary;
}


#pragma mark -- 获取指定目录的文件大小 返回多少M

+ (CGFloat)folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
    {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize/(1024.0*1024.0);
}


#pragma mark -- 清除path文件夹下缓存大小

+ (BOOL)clearCacheWithFilePath:(NSString *)path
{
    //拿到path路径的下一级目录的子文件夹
    
    NSError *fileManagerError = nil;
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&fileManagerError];
    
    if (fileManagerError == nil)
    {
        NSString *filePath = nil;
        NSError *error = nil;
        for (NSString *subPath in subPathArr)
        {
            filePath = [path stringByAppendingPathComponent:subPath];
            //删除子文件夹
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
            if (error)
            {
                return NO;
            }
        }
    }
    
    return YES;
}


#pragma mark -- 删除文件

+ (BOOL)deleteFileWithPath:(NSString *)filePath
{
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    if (error)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


#pragma mark - 拷贝文件到某文件路径

+ (BOOL)copyFile:(NSString *)sourcePath toPath:(NSString *)toPath
{
    BOOL retVal = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:toPath error:NULL];
    
    return retVal;
}

@end

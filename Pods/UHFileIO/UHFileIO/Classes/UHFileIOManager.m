//
//  UHFileIOManager.m
//  UHFileIO_Example
//
//  Created by macRong on 2019/5/8.
//  Copyright © 2019 MacRong. All rights reserved.
//

#import "UHFileIOManager.h"
#import "UHFileManager.h"

@interface UHFileIOManager()

@property (nonatomic, copy) NSString *projectPath;

@end

static  NSString *const g_uhvideo_sandboxPath = @"UHVideo";
@implementation UHFileIOManager


#pragma mark - 业务相关

+ (NSString *)uh_pathdocumentsDirectory
{
    static NSString *documentsDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *documents = [self pathForDocumentsDirectory];
        documentsDirectory = [documents stringByAppendingPathComponent:g_uhvideo_sandboxPath];
    });

    return [self uh_forceCreateDirectoriesForPath:documentsDirectory];
}

+ (NSString *)uh_pathForLibraryDirectory
{
    static NSString *pathDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *libraryPath = [self pathForLibraryDirectory];
        pathDirectory = [libraryPath stringByAppendingPathComponent:g_uhvideo_sandboxPath];
    });
    
    return [self uh_forceCreateDirectoriesForPath:pathDirectory];
}

+ (NSString *)uh_pathForCachesDirectory
{
    static NSString *pathDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [self pathForCachesDirectory];
        pathDirectory = [path stringByAppendingPathComponent:g_uhvideo_sandboxPath];
    });
    
    return [self uh_forceCreateDirectoriesForPath:pathDirectory];
}

+ (NSString *)uh_pathForTemporaryDirectory
{
    static NSString *pathDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [self pathForTemporaryDirectory];
        pathDirectory = [path stringByAppendingPathComponent:g_uhvideo_sandboxPath];
    });
    
    return [self uh_forceCreateDirectoriesForPath:pathDirectory];
}

+ (NSString *)uh_forceCreateDirectoriesForPath:(NSString *)path
{
    if (![path isKindOfClass:[NSString class]])
    {
        return path;
    }
    
    BOOL creteDic = [UHFileIOManager createDirectoriesForPath:path error:nil];
    NSString *resultPath = creteDic ?  path : nil;
    return resultPath;
}


#pragma mark - ———————————————— Life cycle  ————————————————

+ (instancetype)shareInstance
{
    static dispatch_once_t _singleToken;
    static id __singleton__;
    dispatch_once(&_singleToken, ^{
        __singleton__ = [[super allocWithZone:NULL] init];
    });
    
    return __singleton__;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [[self class]  shareInstance];
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    return [[self class]  shareInstance];
}

+ (NSString *)pathForDocumentsDirectory
{
    static NSString *path = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        path = [paths lastObject];
    });
    
    return path;
}


#pragma mark - ———————————————— 增  ————————————————

/// 创建目录
+ (BOOL)createDirectoriesForPath:(NSString *)path error:(NSError * _Nullable __autoreleasing * _Nullable)error
{
    NSParameterAssert(path);
    if (!path)
    {
        return NO;
    }
    
    if ([self existsItemAtPath:path])
    {
        return YES;
    }

    return [UHFileManager createDirectoriesForPath:path error:error];
}

/// 创建文件
+ (BOOL)createFileAtPath:(NSString *)path error:(NSError * _Nullable __autoreleasing * _Nullable)error
{
    NSParameterAssert(path);
    if (!path)
    {
        return NO;
    }

    if ([self existsItemAtPath:path])
    {
        return YES;
    }
    
    return [UHFileManager createFileAtPath:path error:error];
}

/// 写入数据
+ (BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError *_Nullable __autoreleasing * _Nullable)error
{
    NSParameterAssert(path);
    if (![path isKindOfClass:[NSString class]] || !content)
    {
        return NO;
    }
    
    return [UHFileManager writeFileAtPath:path content:content error:error];
}


#pragma mark - ———————————————— 删  ————————————————

/// 删除整个目录
+ (BOOL)removeFilesInDirectoryAtPath:(NSString *)path error:(NSError * _Nullable __autoreleasing * _Nullable)error;
{
    if (!path)
    {
        return NO;
    }
    
    return [UHFileManager removeFilesInDirectoryAtPath:path error:error];
}

/// 删除文件
+ (BOOL)removeItemAtPath:(NSString *)path error:(NSError * _Nullable __autoreleasing * _Nullable)error
{
    if (!path)
    {
        return NO;
    }
    
    return [UHFileManager removeItemAtPath:path error:error];
}

+ (BOOL)copyFile:(NSString *)sourcePath toPath:(NSString *)toPath
{
    if (!sourcePath || !toPath)
    {
        return NO;
    }
    
    BOOL retVal = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:toPath error:NULL];
    
    return retVal;
}


#pragma mark - ———————————————— 改  ————————————————

/// 移动文件
+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError *_Nullable __autoreleasing * _Nullable)error
{
    if (![path isKindOfClass:[NSString class]])
    {
        return NO;
    }
    
    return [UHFileManager moveItemAtPath:path toPath:toPath error:error];
}

/// 重命名
+ (BOOL)renameItemAtPath:(NSString *)path withName:(NSString *)name error:(NSError *_Nullable __autoreleasing * _Nullable)error
{
    return [UHFileManager renameItemAtPath:path withName:name error:error];
}


#pragma mark - ———————————————— 查  ————————————————

/// 路径是否存在
+ (BOOL)existsItemAtPath:(NSString *)path
{
    if (!path)
    {
        return NO;
    }
    
    return  [UHFileManager existsItemAtPath:path];
}

/// 获取resourceBundle路径
+ (NSString *)pathForMainBundleDirectory
{
    return [UHFileManager pathForMainBundleDirectory];
}

/// 获取沙盒中的路径
+ (NSString *)pathForApplicationSupportDirectory
{
    return [UHFileManager pathForApplicationSupportDirectory];
}

/// 获取cache路径
+ (NSString *)pathForCachesDirectory
{
    return [UHFileManager pathForCachesDirectory];
}

/// 获取Library路径
+ (NSString *)pathForLibraryDirectory
{
    return [UHFileManager pathForLibraryDirectory];
}

/// 获取Temp路径
+ (NSString *)pathForTemporaryDirectory
{
    return [UHFileManager pathForTemporaryDirectory];
}

/// 查找指定文件路径
+ (NSNumber *)sizeOfItemAtPath:(NSString *)path error:(NSError *_Nullable __autoreleasing * _Nullable)error
{
    return [UHFileManager sizeOfItemAtPath:path error:error];
}

+ (CGFloat)folderSizeAtPath:(NSString*)folderPath
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

+ (long long)fileSizeAtPath:(NSString*)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}


@end

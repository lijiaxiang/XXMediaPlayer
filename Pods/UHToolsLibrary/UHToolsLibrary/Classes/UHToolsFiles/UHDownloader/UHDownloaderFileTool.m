//
//  UHDownloaderFileTool.m
//  LGVideo
//
//  Created by 程宏愿 on 2019/01/10.
//  Copyright © 2018 右划科技. All rights reserved.
//

#import "UHDownloaderFileTool.h"
#import <UHFileIO/UHFileIOManager.h>
#define kCachesPath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask , YES).firstObject
#define  kTempPath NSTemporaryDirectory()

@implementation UHDownloaderFileTool

+(BOOL)fileExists:(NSString *)filePath{
    if (filePath.length == 0) {
        return  NO;
    }
    return  [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

+(long long)sizeOfFile:(NSString *)filePath{
    if (![self fileExists:filePath]) {
        return 0;
    }
    NSDictionary *fileInfo =[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    return [fileInfo[NSFileSize] longLongValue];
}

+(void)moveFile:(NSString *)fromPath toPath:(NSString *)toPath{
    if (![self sizeOfFile:fromPath]) {
        return;
    }
    [[NSFileManager defaultManager] moveItemAtPath:fromPath toPath:toPath error:nil];
}

+(void)removeFile:(NSString *)filePath{
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

+ (BOOL)creatPath:(NSString *)filePath
{
    if (filePath.length == 0) {
        return  NO;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    if (!(isDirExist && isDir))
    {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        return bCreateDir;
    }
    else
    {
        return YES;
    }
}

+ (NSString *)downloadedDir
{
    return  [NSString stringWithFormat:@"%@/UHAudioFile",UHFileIOManager.uh_pathForCachesDirectory];
}

+ (NSString *)downlodingPathWithFileName:(NSString *)fileName
{
   return [UHFileIOManager.uh_pathForTemporaryDirectory stringByAppendingString:fileName];
}

+ (NSString *)downloadedPathWithFileName:(NSString *)fileName
{
   return  [NSString stringWithFormat:@"%@/%@",[self downloadedDir],fileName];
}

+ (void)deleteDownloadedDir
{
     NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[self downloadedDir]]) {
        NSError * error = nil;
        [fileManager removeItemAtPath:[self downloadedDir] error:&error];
        if (error) {
            
        }else{
            
        }
    }
}
@end

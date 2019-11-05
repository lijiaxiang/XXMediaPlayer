//
//  UHDownloaderFileTool.h
//  LGVideo
//
//  Created by 程宏愿 on 2019/01/10.
//  Copyright © 2018 右划科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UHDownloaderFileTool : NSObject
//查找文件如果有就返回yes
+(BOOL)fileExists:(NSString *)filePath;
//返回文件大小
+(long long)sizeOfFile:(NSString *)filePath;
//把文件送一个path  移动到另一个path
+(void)moveFile:(NSString *)fromPath toPath:(NSString *)toPath;
//删除一个文件
+(void)removeFile:(NSString *)filePath;
//新建一个路径
+ (BOOL)creatPath:(NSString *)filePath;

+ (NSString *)downloadedDir;
+ (NSString *)downlodingPathWithFileName:(NSString *)fileName;
+ (NSString *)downloadedPathWithFileName:(NSString *)fileName;
+ (void)deleteDownloadedDir;
@end

//
//  UHFileManager.h
//  UHFileIO_Example
//
//  Created by macRong on 2019/5/8.
//  Copyright © 2019 MacRong. All rights reserved.
//


/**
 ⚠️私有不要增加业务代码
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UHFileManager : NSObject

+ (id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key;
+ (id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key error:(NSError **)error;

+ (NSDictionary *)attributesOfItemAtPath:(NSString *)path;
+ (NSDictionary *)attributesOfItemAtPath:(NSString *)path error:(NSError **)error;

+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)path;
+ (BOOL)copyItemAtPath:(NSString *)path toPath:(NSString *)path error:(NSError **)error;

+ (BOOL)createDirectoriesForFileAtPath:(NSString *)path;
+ (BOOL)createDirectoriesForFileAtPath:(NSString *)path error:(NSError **)error;

+ (BOOL)createDirectoriesForPath:(NSString *)path;
+ (BOOL)createDirectoriesForPath:(NSString *)path error:(NSError **)error;

+ (BOOL)createFileAtPath:(NSString *)path;
+ (BOOL)createFileAtPath:(NSString *)path error:(NSError **)error;

+ (BOOL)createFileAtPath:(NSString *)path withContent:(NSObject *)content;
+ (BOOL)createFileAtPath:(NSString *)path withContent:(nullable NSObject *)content error:(NSError **)error;

+ (NSDate *)creationDateOfItemAtPath:(NSString *)path;
+ (NSDate *)creationDateOfItemAtPath:(NSString *)path error:(NSError **)error;

+ (BOOL)emptyCachesDirectory;
+ (BOOL)emptyTemporaryDirectory;

+ (BOOL)existsItemAtPath:(NSString *)path;

+ (BOOL)isDirectoryItemAtPath:(NSString *)path;
+ (BOOL)isDirectoryItemAtPath:(NSString *)path error:(NSError **)error;
+ (BOOL)isEmptyItemAtPath:(NSString *)path;
+ (BOOL)isEmptyItemAtPath:(NSString *)path error:(NSError **)error;
+ (BOOL)isFileItemAtPath:(NSString *)path;
+ (BOOL)isFileItemAtPath:(NSString *)path error:(NSError **)error;
+ (BOOL)isExecutableItemAtPath:(NSString *)path;
+ (BOOL)isReadableItemAtPath:(NSString *)path;
+ (BOOL)isWritableItemAtPath:(NSString *)path;

+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path;
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension;
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix;
+ (NSArray *)listFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix;
+ (NSArray *)listItemsInDirectoryAtPath:(NSString *)path deep:(BOOL)deep;

+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath;
+ (BOOL)moveItemAtPath:(NSString *)path toPath:(NSString *)toPath error:(NSError **)error;

+ (NSString *)pathForApplicationSupportDirectory;
+ (NSString *)pathForApplicationSupportDirectoryWithPath:(NSString *)path;

+ (NSString *)pathForCachesDirectory;
+ (NSString *)pathForCachesDirectoryWithPath:(NSString *)path;

+ (NSString *)pathForDocumentsDirectory;
+ (NSString *)pathForDocumentsDirectoryWithPath:(NSString *)path;

+ (NSString *)pathForLibraryDirectory;
+ (NSString *)pathForLibraryDirectoryWithPath:(NSString *)path;

+ (NSString *)pathForMainBundleDirectory;
+ (NSString *)pathForMainBundleDirectoryWithPath:(NSString *)path;

+ (NSString *)pathForPlistNamed:(NSString *)name;

+ (NSString *)pathForTemporaryDirectory;
+ (NSString *)pathForTemporaryDirectoryWithPath:(NSString *)path;

+ (NSString *)readFileAtPath:(NSString *)path;
+ (NSString *)readFileAtPath:(NSString *)path error:(NSError **)error;

+ (NSArray *)readFileAtPathAsArray:(NSString *)path;

+ (NSObject *)readFileAtPathAsCustomModel:(NSString *)path;

+ (NSData *)readFileAtPathAsData:(NSString *)path;
+ (NSData *)readFileAtPathAsData:(NSString *)path error:(NSError **)error;

+ (NSDictionary *)readFileAtPathAsDictionary:(NSString *)path;

+ (UIImage *)readFileAtPathAsImage:(NSString *)path;
+ (UIImage *)readFileAtPathAsImage:(NSString *)path error:(NSError **)error;

+ (UIImageView *)readFileAtPathAsImageView:(NSString *)path;
+ (UIImageView *)readFileAtPathAsImageView:(NSString *)path error:(NSError **)error;

+ (NSDictionary *)readFileAtPathAsJSON:(NSString *)path;
+ (NSDictionary *)readFileAtPathAsJSON:(NSString *)path error:(NSError **)error;

+ (NSMutableArray *)readFileAtPathAsMutableArray:(NSString *)path;

+ (NSMutableData *)readFileAtPathAsMutableData:(NSString *)path;
+ (NSMutableData *)readFileAtPathAsMutableData:(NSString *)path error:(NSError **)error;

+ (NSMutableDictionary *)readFileAtPathAsMutableDictionary:(NSString *)path;

+ (NSString *)readFileAtPathAsString:(NSString *)path;
+ (NSString *)readFileAtPathAsString:(NSString *)path error:(NSError **)error;

+ (BOOL)removeFilesInDirectoryAtPath:(NSString *)path;
+ (BOOL)removeFilesInDirectoryAtPath:(NSString *)path error:(NSError **)error;
+ (BOOL)removeFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension;
+ (BOOL)removeFilesInDirectoryAtPath:(NSString *)path withExtension:(NSString *)extension error:(NSError **)error;
+ (BOOL)removeFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix;
+ (BOOL)removeFilesInDirectoryAtPath:(NSString *)path withPrefix:(NSString *)prefix error:(NSError **)error;
+ (BOOL)removeFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix;
+ (BOOL)removeFilesInDirectoryAtPath:(NSString *)path withSuffix:(NSString *)suffix error:(NSError **)error;

+ (BOOL)removeItemsInDirectoryAtPath:(NSString *)path;
+ (BOOL)removeItemsInDirectoryAtPath:(NSString *)path error:(NSError **)error;

+ (BOOL)removeItemAtPath:(NSString *)path;
+ (BOOL)removeItemAtPath:(NSString *)path error:(NSError **)error;

+ (BOOL)renameItemAtPath:(NSString *)path withName:(NSString *)name;
+ (BOOL)renameItemAtPath:(NSString *)path withName:(NSString *)name error:(NSError **)error;

+ (NSNumber *)sizeOfItemAtPath:(NSString *)path;
+ (NSNumber *)sizeOfItemAtPath:(NSString *)path error:(NSError **)error;

+ (NSURL *)urlForItemAtPath:(NSString *)path;

+ (BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content;
+ (BOOL)writeFileAtPath:(NSString *)path content:(NSObject *)content error:(NSError **)error;

/**
  获取所有主文件目录

 @return 主文件目录集合
 */
+ (NSMutableArray *)absoluteDirectories;

/**
 断言验证Path

 @param path path
 */
+ (void)assertPath:(NSString *)path;

/**
  根据相对路径得到绝对路径

 @param relativePath  相对路径
 @return 绝对路径
 */
+ (NSString *) absolutePathWithRelativePath:(NSString *)relativePath;

/**
  判断文件的扩展名

 @param path 文件路径
 @param extension 扩展名
 @return YES， 文件的扩展名为extension， NO，反之
 */
+ (BOOL) isPath:(NSString *)path hasExtension:(NSString *)extension;

/**
 为某文件设置属性

 @param attributes 属性
 @param path 文件目录
 @return 设置成功与否
 */
+  (BOOL)setAttributes:(NSDictionary *)attributes ofItemAtPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END

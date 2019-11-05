//
//  UHDownLoder.h
//  LGVideo
//
//  Created by 程宏愿 on 2019/01/10.
//  Copyright © 2018 右划科技. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UHDownloaderState){
    UHDownloaderStatePause,
    UHDownloaderStateDownLoading,
    UHDownloaderStateCompleted,
    UHDownloaderStateFailed
};

typedef void(^DownloadInfoType)(NSDictionary * info);
typedef void(^ProgressBlockType)(float progress);
typedef void(^SuccessBlockType)(NSString *filePath);
typedef void(^FailedBlockType)(NSError *error);
typedef void(^StateChangeType)(UHDownloaderState state);


@interface UHDownloader : NSObject

@property (nonatomic, assign) UHDownloaderState state;

@property (nonatomic, copy) DownloadInfoType   downloadInfoBlock;
@property (nonatomic, copy) ProgressBlockType  progressBlock;
@property (nonatomic, copy) SuccessBlockType   successBlock;
@property (nonatomic, copy) FailedBlockType    failedBlock;
@property (nonatomic, copy) StateChangeType    stateChangeBlock;


/**
 根据URL地址下载资源, 如果任务已经存在, 则执行继续动作
 @param url 资源路径
 */
-(void)download:(NSURL *)url;

-(void)download:(NSURL *)url downloadInfo:(DownloadInfoType)downloadInfo progress:(ProgressBlockType)progress stateChange:(StateChangeType)state success:(SuccessBlockType)success failed:(FailedBlockType)failed;

/**
 暂停任务
 */
-(void)pauseCurrentTask;

/**
  取消任务
 */
-(void)cancelCurrentTask;

/**
 取消任务并且清理
 */
-(void)cancelAndClear;

/**
  继续当前任务
 */
-(void)resumeCurrentTask;

@end

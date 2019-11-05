//
//  UHDownLoder.m
//  LGVideo
//
//  Created by 程宏愿 on 2019/01/10.
//  Copyright © 2018 右划科技. All rights reserved.
//


#import "UHDownloader.h"
#import "UHDownloaderFileTool.h"


@interface UHDownloader()
<
NSURLSessionDataDelegate
>

{
    // 记录文件临时下载大小
    long long _tempSize;
    // 记录文件总大小
    long long _totalSize;
}
@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, copy) NSString *downloadedPath;

@property (nonatomic, copy) NSString *downlodingPath;

@property (nonatomic, strong) NSOutputStream *outputStream;

@property (nonatomic, assign) float progress;

@property (nonatomic, strong) NSError *error;
@end

@implementation UHDownloader



-(NSURLSession *)session{
    if (!_session) {
        NSURLSessionConfiguration  *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
    }
        return _session;
}
-(void)setProgress:(float)progress{
    _progress = progress;
    
    if (self.progressBlock != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
             self.progressBlock(progress);
        });
    }
}

-(void)setState:(UHDownloaderState)state{
    _state = state;
    
    if (self.stateChangeBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
              self.stateChangeBlock(state);
        });
    }
    
    if (state == UHDownloaderStateCompleted && self.successBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
                self.successBlock(self.downloadedPath);
        });
    }
    
    if (state == UHDownloaderStateFailed && self.failedBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
                  self.failedBlock(self.error);
        });
    }
}
/**
 暂停当前任务
 */
-(void)pauseCurrentTask{
    if (self.state == UHDownloaderStateDownLoading) {
        self.state = UHDownloaderStatePause;
        [self.dataTask suspend];
    }
}

/**
 取消当前任务，并删除缓存
 */
-(void)cancelAndClear{
    [self cancelCurrentTask];
    [UHDownloaderFileTool removeFile:self.downlodingPath];
}

/**
  取消当前任务
 */
-(void)cancelCurrentTask{
    self.state = UHDownloaderStatePause;
    [self.session invalidateAndCancel];
    self.session = nil;
    //删除之后，要清空，以免妨碍第二次重新下载
    self.dataTask = nil;
}

/**
 重新启动当前任务
 */
-(void)resumeCurrentTask{
    
    if (self.dataTask && self.state == UHDownloaderStatePause) {
       [self.dataTask resume];
        self.state = UHDownloaderStateDownLoading;
    }
    
}

-(void)download:(NSURL *)url downloadInfo:(DownloadInfoType)downloadInfo progress:(ProgressBlockType)progress stateChange:(StateChangeType)state success:(SuccessBlockType)success failed:(FailedBlockType)failed{
    
    self.downloadInfoBlock = downloadInfo;
    self.progressBlock     = progress;
    self.stateChangeBlock  = state;
    self.successBlock      = success;
    self.failedBlock       = failed;
    
    [self download:url];
}


-(void)download:(NSURL *)url{
    
    //如果当前有任务就继续
    if ([url isEqual: self.dataTask.originalRequest.URL] && self.state != UHDownloaderStateCompleted) {
        [self resumeCurrentTask];
        return;
    }
    //  文件的存放
    // 下载ing => temp + 名称
    // 下载完成 => cache + 名称
    NSString *fileName  =  url.lastPathComponent;
    self.downlodingPath = [UHDownloaderFileTool downloadedPathWithFileName:fileName];
    NSString *downloadedDir = [UHDownloaderFileTool downloadedDir];
    if ([UHDownloaderFileTool creatPath:downloadedDir])
    {
        self.downloadedPath = [UHDownloaderFileTool downloadedPathWithFileName:fileName];
    }
    
    NSLog(@"temp:%@",self.downlodingPath);
    NSLog(@"cache:%@",self.downloadedPath);
    
    
    if ([UHDownloaderFileTool fileExists:self.downloadedPath]) {
        self.state =  UHDownloaderStateCompleted;
        NSLog(@"下载完毕, 并且传递相关信息(本地的路径, 文件的大小)");
        return;
    }
    
    // 2. 检测临时文件是否存在
    // 2.1 不存在从0开始下载
    if (![UHDownloaderFileTool fileExists:self.downlodingPath]) {
        [self download:url offset:0];
        return;
    }
    
    // 获取本地大小
    _tempSize = [UHDownloaderFileTool sizeOfFile:self.downlodingPath];
    [self download:url offset:_tempSize];
}

#pragma mark  ---private method
-(void)download:(NSURL *)url offset:(long long)offset{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:0];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-",offset] forHTTPHeaderField:@"Range"];
    self.dataTask = [self.session dataTaskWithRequest:request];
    [self.dataTask resume];
}

#pragma mark ---NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSHTTPURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler{
   
    // 取资源总大小
    //  从  Content-Length 取出来
    //  如果 Content-Range 有, 应该从Content-Range里面获取
    NSLog(@"%@",response.allHeaderFields);
   
    // 传递给外界 : 总大小 & 本地存储的文件路径
    if (self.downloadInfoBlock != nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.downloadInfoBlock(response.allHeaderFields);
        });
        
    }
    
    // 取资源总大小
    //  从  Content-Length 取出来
    //  如果 Content-Range 有, 应该从Content-Range里面获取
    _totalSize = [response.allHeaderFields[@"Content-Length"]longLongValue];
    NSString *contentRangeStr = response.allHeaderFields[@"Content-Range"];
    if (contentRangeStr) {
        if (contentRangeStr.length != 0) {
            _totalSize = [[contentRangeStr componentsSeparatedByString:@"/"].lastObject longLongValue];
        }
    }
    
    
    //   本地大小 == 总大小  ==> 移动到下载完成的路径中
    if (_totalSize == _tempSize) {
        [UHDownloaderFileTool moveFile:self.downlodingPath toPath:self.downloadedPath];
        completionHandler(NSURLSessionResponseCancel);
        self.state =  UHDownloaderStateCompleted;
        NSLog(@"文件从临时移动到缓存");
        return;
    }
    
    //    本地大小 > 总大小  ==> 删除本地临时缓存, 从0开始下载
    if (_tempSize > _totalSize) {
        [UHDownloaderFileTool removeFile:self.downlodingPath];
        [self download:response.URL];
          completionHandler(NSURLSessionResponseCancel);
        NSLog(@"文件错误，重新下载");
        return;
    }
    self.state = UHDownloaderStateDownLoading;
    //    本地大小 < 总大小 => 从本地大小开始下载
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.downlodingPath append:YES];
    [self.outputStream open];
        completionHandler(NSURLSessionResponseAllow);
    NSLog(@"继续下载");
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    // 这就是当前已经下载的大小
    _tempSize += data.length;
    self.progress =  1.0 * _tempSize / _totalSize;
    [self.outputStream write:data.bytes maxLength:data.length];
}

-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    
    if (error == nil) {
        // 不一定是成功
        // 数据是肯定可以请求完毕
        // 判断, 本地缓存 == 文件总大小 {filename: filesize: md5:xxx}
        // 如果等于 => 验证, 是否文件完整(file md5 )
        //艹
         [UHDownloaderFileTool moveFile:self.downlodingPath toPath:self.downloadedPath];
        self.state = UHDownloaderStateCompleted;
    }else{
        self.error = error;
        if (-999 == error.code) {
            self.state = UHDownloaderStatePause;
        }else{
            self.state = UHDownloaderStateFailed;
        }
    }
    
    [self.outputStream close];
}

@end

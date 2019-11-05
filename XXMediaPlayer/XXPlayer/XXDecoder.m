//
//  XXDecoder.m
//  XXMediaPlayer
//
//  Created by viper on 2019/11/2.
//  Copyright © 2019 viper. All rights reserved.
//

#import "XXDecoder.h"
#include "libavformat/avformat.h"

@interface XXFrame ()
@end
@implementation XXFrame
@end

@interface XXVideoFrame ()
@end
@implementation XXVideoFrame
@end

@interface XXVideoFrameYUV ()
@end
@implementation XXVideoFrameYUV
@end

@interface XXDecoder ()

@property (nonatomic, strong, readwrite) NSString *path;

@property (nonatomic, assign) AVFormatContext *formatCtx;///上下文

@property (nonatomic, assign) NSInteger videoStream;///视频流

@property (nonatomic, strong) NSArray *videoStreams;///视频流数组

/**
 *  音视频数据
 *  1、data 用来存储解码后的原始数据。
 *  对于视频来说就是YUV和RGB，对于音频来说就是PCM
 *  指针数组，所以数据格式变化存储方式也变化
 *  对于packed格式的数据（比如RGB24），会存到data[0]中
 *  对于planar格式的数据（比如YUV420P），则会data[0]存Y，data[1]存U，data[2]存V，数据的大小的比例也是不同的
 *  2、linesize
 *  是data数据中‘一行’数据的大小，一般大于图像的宽度
 */
@property (nonatomic, assign) AVFrame *videoFrame;

@property (nonatomic, assign) AVCodecContext *videoCodecCtx;///存放编解码时候的参数

@property (nonatomic, assign) CGFloat videoTimeBase;///播放一帧需要的时间 默认0.04

@property (nonatomic, assign) CGFloat position;///当前帧的时间戳

@property (nonatomic, assign) XXVideoFrameFormat videoFrameFormat;

@end

@implementation XXDecoder

//static void FFLog(void* context, int level, const char* format, va_list args) {
//    @autoreleasepool {
//
//
//    }
//}

+ (void)initialize
{
//    av_log_set_callback(FFLog);
    av_register_all();
//    avformat_network_init();
}

- (NSUInteger)frameWidth
{
    return self.videoCodecCtx ? self.videoCodecCtx->width : 0;
}

- (NSUInteger)frameHeight
{
    return self.videoCodecCtx ? self.videoCodecCtx->height : 0;
}

#pragma mark -  —————————————————— Lifecycle ——————————————————

#pragma mark -  —————————————————— init and config ————————————————

#pragma mark - —————————————————— 基类方法(如重写函数) —————————————

#pragma mark - —————————————————— Net Connection Event ————————————

#pragma mark - —————————————————— 对外方法 ———————————————————

- (BOOL)openFile:(NSString *)path error:(NSError *__autoreleasing  _Nullable *)perror
{
    self.path = path;
    
    ///打开输出 源
    if (![self openInput:path])
    {
        return NO;
    }
    
    /// 打开音视频流
    if (![self openVideoStream])
    {
        return NO;
    }
    
    return YES;
}

- (NSArray *)decodeFrames:(CGFloat)minDuration
{
    if (self.videoStream == -1)
    {
        return nil;
    }
    
    NSMutableArray *result = [NSMutableArray array];
    ///1、从哪里来
    ///很重要的结构体
    ///是一个把压缩数据导入到解码器的分配器，也是用来接收编码后的数据的结构体
    AVPacket packet;
    CGFloat decodedDuration = 0;
    BOOL finished = NO;
    while (!finished)
    {
        ///2、怎么来？
        ///读取一帧视频帧或者是多帧音频帧
        ///AVPacket数据一直有效，除非读到下一帧或formatCtx数据被彻底清空，调用avformat_close_input
        if (av_read_frame(self.formatCtx, &packet) < 0)
        {
            UHAPPLog(@"读取Frame失败");
            break;
        }
        ///3、来干嘛？
        if (packet.stream_index == self.videoStream)
        {
            int pktSize = packet.size;
            while (pktSize > 0)
            {
                int gotFrame = 0;
                ///1、上下文  2、解码后的数据 3、得到的帧数 4、解码前的数据
                ///可以解读一下这个方法的源码
                int len = avcodec_decode_video2(self.videoCodecCtx, self.videoFrame, &gotFrame, &packet);
                if (len < 0)
                {
                    UHAPPLog(@"解码失败");
                    break;
                }
                
                ///4、怎么去?
                if (gotFrame)
                {
                    XXVideoFrame *frame = [self handleVideoFrame];
                    frame.type = XXFrameTypeVideo;
                    UHAPPLog(@"当前帧的时间戳：%f，当前帧的持续时间：%f", frame.position, frame.duration);
                    
                    if (frame)
                    {
                        [result addObject:frame];
                        
                        self.position = frame.position;
                        decodedDuration += frame.duration;
                        if (decodedDuration > minDuration)
                        {
                            finished = YES;
                        }
                    }
                }
                
                if (0 == len) {
                    break;
                }
                ///每解一次，就减去对应长度，知道解码完packet中的所有数据，就结束循环
                pktSize -= len;
            }
        }
        av_free_packet(&packet);
    }
    
    return result;
}

- (BOOL)setupVideoFrameFormat:(XXVideoFrameFormat)format
{
    if (format == XXVideoFrameFormatYUV &&
        self.videoCodecCtx &&
        (self.videoCodecCtx->pix_fmt == AV_PIX_FMT_YUV420P ||
         self.videoCodecCtx->pix_fmt == AV_PIX_FMT_YUVJ420P))
    {
        self.videoFrameFormat = XXVideoFrameFormatYUV;
        return YES;
    }
    
    self.videoFrameFormat = XXVideoFrameFormatRGB;
    return self.videoFrameFormat == format;
    
}

#pragma mark - —————————————————— 私有方法 ———————————————————

///读取文件信息
- (BOOL)openInput:(NSString *)path
{
    AVFormatContext *formatCtx = NULL;
    
    ///1、初始化输入输出上下文
    formatCtx = avformat_alloc_context();
    if (!formatCtx)
    {
        UHAPPLog(@"打开文件失败");
        return NO;
    }

    ///2、打开输入（读取文件信息）
    if (avformat_open_input(&formatCtx, [path cStringUsingEncoding:NSUTF8StringEncoding], NULL, NULL) < 0)
    {
        if (formatCtx)
        {
            ///释放上下文
            avformat_free_context(formatCtx);
        }
        UHAPPLog(@"打开文件失败");
        return NO;
    }

    ///3、从文件中获取流信息
    if (avformat_find_stream_info(formatCtx, NULL) < 0)
    {
        ///关闭输入
        avformat_close_input(&formatCtx);
        UHAPPLog(@"无法获取流信息");
        return NO;
    }

    ///4、打印输入输出的方法
    av_dump_format(formatCtx, 0, [path.lastPathComponent cStringUsingEncoding:NSUTF8StringEncoding], false);

    self.formatCtx = formatCtx;
    
    return YES;
}

///打开视频流
- (BOOL)openVideoStream
{
    BOOL resual = YES;
    
    self.videoStream = -1;
    self.videoStreams = collectStreams(self.formatCtx, AVMEDIA_TYPE_VIDEO);
    for (NSNumber *n in self.videoStreams)
    {
        const NSUInteger iStream = n.integerValue;
        if (0 == (self.formatCtx -> streams[iStream] -> disposition & AV_DISPOSITION_ATTACHED_PIC))
        {
            resual = [self openVideoStream:iStream];
            if (resual)
            {
                break;
            }
        }
    }
    
    return YES;
}

///初始化视频解码器
- (BOOL)openVideoStream:(NSInteger)videoStream
{
    AVCodecContext *codecCtx = self.formatCtx -> streams[videoStream] -> codec;
    
    ///1、通过对应匹配的编解码器ID找到已经注册的编解码器
    AVCodec *codec = avcodec_find_decoder(codecCtx -> codec_id);
    if (!codec)
    {
        UHAPPLog(@"无法找到解码器");
        return NO;
    }
    
    ///2、打开解码器
    if (avcodec_open2(codecCtx, codec, NULL) < 0)
    {
        UHAPPLog(@"打开解码器失败");
        return YES;
    }
    
    ///3、初始化 存储解码的音视频数据（YUV，PCM这些没有压缩过的，体积很大的数据）
    self.videoFrame = av_frame_alloc();
    if (!self.videoFrame)
    {
        ///关闭解码器（释放AVCodecContext中的所有数据，不是释放其本身）
        avcodec_close(codecCtx);
        UHAPPLog(@"创建视频帧失败");
        return NO;
    }
    
    self.videoStream = videoStream;
    self.videoCodecCtx = codecCtx;
    
    ///计算 fps 帧率
    AVStream *st = self.formatCtx -> streams[self.videoStream];
    avStreamFPSTimeBase(st, 0.04, &_fps, &_videoTimeBase);
    
    return YES;
}

///处理解码后的数据
- (XXVideoFrame *)handleVideoFrame
{
    if (!self.videoFrame -> data[0])
    {
        return nil;
    }
    
    XXVideoFrame *frame;
    ///1、处理YUV，封装成自己的格式
    if (self.videoFrameFormat == XXVideoFrameFormatYUV)
    {
        XXVideoFrameYUV *yuvFrame = [[XXVideoFrameYUV alloc] init];
        
        ///Y
        yuvFrame.luma = copyFrameData(self.videoFrame -> data[0],
                                      self.videoFrame -> linesize[0],
                                      self.videoCodecCtx -> width,
                                      self.videoCodecCtx -> height);
        
        ///U
        yuvFrame.chromaB = copyFrameData(self.videoFrame -> data[1],
                                         self.videoFrame -> linesize[1],
                                         self.videoCodecCtx -> width/2,
                                         self.videoCodecCtx -> height/2);
        
        ///V
        yuvFrame.chromaR = copyFrameData(self.videoFrame -> data[2],
                                         self.videoFrame -> linesize[2],
                                         self.videoCodecCtx -> width/2,
                                         self.videoCodecCtx -> height/2);
        
        frame = yuvFrame;
    }
    
    ///2、解码后数据的信息
    frame.width = self.videoCodecCtx -> width;
    frame.height = self.videoCodecCtx -> height;
    
    ///以流中的时间为基础 预估的时间戳(当前帧数*每帧播放时长=预估的时间点)
    frame.position = av_frame_get_best_effort_timestamp(self.videoFrame) * self.videoTimeBase;
    
    ///获取当前帧的持续时间
    const int64_t frameDuration = av_frame_get_pkt_duration(self.videoFrame);
    
    if (frameDuration)
    {
        frame.duration = frameDuration * self.videoTimeBase;
        frame.duration += self.videoFrame -> repeat_pict * self.videoTimeBase * 0.5;
    }
    else
    {
        frame.duration = 1.0 / self.fps;
    }
    
    return frame;
}

#pragma mark - —————————————————— Touch Event —————————————————

#pragma mark - —————————————————— Setter/Getter ————————————————


#pragma mark - tools

///分离出视频裸流
static NSArray * collectStreams(AVFormatContext * formatCtx, enum AVMediaType codecType)
{
    NSMutableArray * ma = [NSMutableArray array];
    for (NSInteger i = 0; i < formatCtx->nb_streams; i++)
    {
        if (codecType == formatCtx->streams[i]->codec->codec_type)
        {
            [ma addObject:[NSNumber numberWithInteger:i]];
        }
    }
    return [ma copy];
}

///计算fps帧率
static void avStreamFPSTimeBase(AVStream *st, CGFloat defaultTimeBase, CGFloat *pFPS, CGFloat *pTimeBase)
{
    ///timebase 播放一帧需要的时间
    CGFloat fps, timebase;
    
    // ffmpeg提供了一个把AVRatioal结构转换成double的函数
    // 默认0.04 意思就是25帧
    if (st->time_base.den && st->time_base.num)
    {
        timebase = av_q2d(st->time_base);
    }
    else if(st->codec->time_base.den && st->codec->time_base.num)
    {
        timebase = av_q2d(st->codec->time_base);
    }
    else
    {
        timebase = defaultTimeBase;
    }
    
    if (st->codec->ticks_per_frame != 1)
    {
        
    }
    
    // 平均帧率
    if (st->avg_frame_rate.den && st->avg_frame_rate.num)
    {
        fps = av_q2d(st->avg_frame_rate);
    }
    else if (st->r_frame_rate.den && st->r_frame_rate.num)
    {
        fps = av_q2d(st->r_frame_rate);
    }
    else
    {
        fps = 1.0 / timebase;
    }
    
    if (pFPS)
    {
        *pFPS = fps;
    }
    if (pTimeBase)
    {
        *pTimeBase = timebase;
    }
}


static NSData * copyFrameData(UInt8 *src, int linesize, int width, int height)
{
    ///linesize一般会比实际宽度大一点，为避免特殊情况，判断一下取最小的
    width = MIN(linesize, width);
    ///初始化数据大小
    NSMutableData *md = [NSMutableData dataWithLength: width * height];
    Byte *dst = md.mutableBytes;
    for (NSUInteger i = 0; i < height; ++i)
    {
        memcpy(dst, src, width);
        dst += width;
        src += linesize;
    }
    return md;
}
@end

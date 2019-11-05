//
//  XXMainViewController.m
//  XXMediaPlayer
//
//  Created by viper on 2019/11/1.
//  Copyright © 2019 viper. All rights reserved.
//

#import "XXMainViewController.h"
#import "XXDecoder.h"
#import "XXGLView.h"

#define LOCAL_MIN_BUFFERED_DURATION   0.2
#define LOCAL_MAX_BUFFERED_DURATION   0.4

@interface XXMainViewController ()
<XXDecoderDelegate>

@property (nonatomic, strong) UIButton *startBtn;

@property (nonatomic, copy) NSString *videoPath;

@property (nonatomic, strong) XXDecoder *decoder;

@property (nonatomic, strong) dispatch_queue_t dispatchQueue;

@property (nonatomic, strong) NSMutableArray *videoFrames;

@property (nonatomic, strong) NSData *currentAudioFrame;

@property (nonatomic, assign) NSUInteger currentAudioFramePos;

@property (nonatomic, strong) XXGLView *glView;

@property (nonatomic, assign) CGFloat bufferedDuration;

@property (nonatomic, assign) CGFloat minBufferedDuration;

@property (nonatomic, assign) CGFloat maxBufferedDuration;

@property (nonatomic, assign) BOOL buffered;

@end

@implementation XXMainViewController


#pragma mark -  —————————————————— Lifecycle ——————————————————

- (void)dealloc
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化变量
    [self initVariable];

    // 初始化界面
    [self initViews];

    // 注册消息
    [self regNotification];
    
    [self start];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark -  —————————————————— init and config ————————————————

///** 初始化变量 */
- (void)initVariable
{
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)initViews
{
    // 初始化Nav导航栏
    [self initNavView];

    // 创建相关子view
    [self initMainViews];
}

///** 初始化Nav导航栏 */
- (void)initNavView
{

}

///** 创建相关子view */
- (void)initMainViews
{
    [self.view addSubview:self.startBtn];
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}

///** 注册通知 */
- (void)regNotification
{

}



///准备打开资源
- (void)start
{
    UHAPPLog(@"start");
//    self.videoPath = [[NSBundle mainBundle] pathForResource:@"AVC-AAC-1080p" ofType:@"MOV"];
    self.videoPath = [[NSBundle mainBundle] pathForResource:@"AVC-MP3-512*288" ofType:@"mp4"];
    @weakify(self);
    XXDecoder *decoder = [[XXDecoder alloc] init];
    decoder.delegate = self;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @strongify(self);
        NSError *error = nil;
        [decoder openFile:self.videoPath error:&error];
        if (self)
        {
            @weakify(self);
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                [self setUpMovieDecoder:decoder];
            });
        }
    });
}


#pragma mark - —————————————————— 基类方法(如重写函数) —————————————

#pragma mark - —————————————————— Net Connection Event ————————————

#pragma mark - —————————————————— 对外方法 ———————————————————

#pragma mark - —————————————————— 私有方法 ———————————————————

- (void)setUpMovieDecoder:(XXDecoder *)decoder
{
    if (decoder)
    {
        self.decoder = decoder;
        ///创建一个串行队列，用于之后解码的线程
        self.dispatchQueue = dispatch_queue_create("XXMovie", DISPATCH_QUEUE_SERIAL);
        ///用来存储解码后的数据的可变数组
        self.videoFrames = [NSMutableArray array];
    }
    
    ///控制开始解码的两个参数
    self.minBufferedDuration = LOCAL_MIN_BUFFERED_DURATION;///小于就开始解码
    ///处于两者之间，就一直解码，不要停
    self.maxBufferedDuration = LOCAL_MAX_BUFFERED_DURATION;///大于就停止解码
    
    if (self.isViewLoaded)
    {
        [self setupPresentView];
    }
}

- (void)setupPresentView
{
    [self.view addSubview:self.glView];
    self.glView.backgroundColor = [UIColor colorWithRed:arc4random()%256 / 255.0 green:arc4random()%256 / 255.0 blue:arc4random()%256 / 255.0 alpha:1];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)play
{
    ///解码视频 并把视频存储到_videoFrames
    [self asyncDecodeFrames];
    
    ///延迟0.1秒后 开始绘制图像
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self tick];
    });
}

- (void)asyncDecodeFrames
{
    @weakify(self);
    XXDecoder *decoder = self.decoder;
    @weakify(decoder);
    dispatch_async(self.dispatchQueue, ^{
        ///当已经解码的视频总时长大雨_maxBufferedDuration 停止解码
        BOOL good = YES;
        while (good) {
            good = NO;
            @autoreleasepool
            {
                @strongify(decoder);
                if (decoder)
                {
                    NSArray *frames = [decoder decodeFrames:0.1];
                    if (frames.count)
                    {
                        @strongify(self);
                        if (self)
                        {
                            good = [self addFrames:frames];
                        }
                    }
                }
            }
        }
    });
}

- (BOOL)addFrames:(NSArray *)frames
{
    ///互斥锁，同一时间只有一个线程在访问锁中资源
    @synchronized (self.videoFrames)
    {
        for (XXFrame *frame in frames)
        {
            if (frame.type == XXFrameTypeVideo)
            {
                [self.videoFrames addObject:frame];
                self.bufferedDuration += frame.duration;
            }
        }
    }
    return self.bufferedDuration < self.maxBufferedDuration;
}

///轮训播放一帧一帧视频
- (void)tick
{
    ///返回当前播放帧的播放时间
    CGFloat interval = [self presentFrame];
    
    const NSUInteger leftFrames = self.videoFrames.count;
    if (0 == leftFrames)
    {
        return;
    }
    
    ///当VideoFrame中已经没有解码过后的数据 或者剩余的时间小于minBufferedDuration最小，就继续解码
    if (!leftFrames || !(self.bufferedDuration > self.minBufferedDuration))
    {
        [self asyncDecodeFrames];
    }
    
    ///播放完一帧后 继续播放下一帧 两帧之间的播放键哥不能小于0.01秒
    const NSTimeInterval time = MAX(interval, 0.01);
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, time * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [self tick];
    });

}

///绘制图像
- (CGFloat)presentFrame
{
    CGFloat interval = 0;
    XXVideoFrame * frame;
    
    ///互斥锁，同一时间只有一个线程在访问锁中资源
    @synchronized (self.videoFrames)
    {
        if (self.videoFrames.count > 0)
        {
            frame = self.videoFrames[0];
            [self.videoFrames removeObjectAtIndex:0];
            self.bufferedDuration -= frame.duration;
        }
    }
    
    if (frame)
    {
        if (self.glView)
        {
            [self.glView render:frame];
        }
        interval = frame.duration;
    }
    return interval;
}

#pragma mark - —————————————————— Touch Event —————————————————

- (void)playBtnClick:(UIButton *)btn
{
//    [self start];
    [self play];
//    [self play];
}

#pragma mark - —————————————————— Delegate Event ———————————————

- (void)getYUV420Data:(void *)pData width:(int)width height:(int)height
{
    /// do something!
}

#pragma mark - —————————————————— Notification Event ——————————————

#pragma mark - —————————————————— Setter/Getter ————————————————

#pragma mark - getter

- (UIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [UIButton new];
        [_startBtn setTitle:@"play" forState:UIControlStateNormal];
        [_startBtn setBackgroundColor:[UIColor colorWithRed:arc4random()%256 / 255.0 green:arc4random()%256 / 255.0 blue:arc4random()%256 / 255.0 alpha:1]];
        [_startBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}

- (XXGLView *)glView
{
    if (!_glView) {
        _glView = [[XXGLView alloc] initWithFrame:CGRectMake(0, 100, 300, 200) decoder:self.decoder];
//        _glView.backgroundColor = [UIColor colorWithRed:arc4random()%256 / 255.0 green:arc4random()%256 / 255.0 blue:arc4random()%256 / 255.0 alpha:1];
    }
    return _glView;
}

@end

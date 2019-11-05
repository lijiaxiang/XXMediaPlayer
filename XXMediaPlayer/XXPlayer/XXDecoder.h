//
//  XXDecoder.h
//  XXMediaPlayer
//
//  Created by viper on 2019/11/2.
//  Copyright © 2019 viper. All rights reserved.
//

/**
 解码器
 */
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, XXFrameType) {
    XXFrameTypeAudio,
    XXFrameTypeVideo,
};

typedef NS_ENUM(NSInteger, XXVideoFrameFormat) {
    XXVideoFrameFormatRGB,
    XXVideoFrameFormatYUV,
};

NS_ASSUME_NONNULL_BEGIN

@interface XXFrame : NSObject
@property (nonatomic, assign) XXFrameType type;
@property (nonatomic, assign) CGFloat position;
@property (nonatomic, assign) CGFloat duration;
@end

@interface XXAudioFrame : XXFrame
@property (nonatomic, strong) NSData *samples;
@end

@interface XXVideoFrame : XXFrame
@property (nonatomic, assign) XXVideoFrameFormat format;
@property (nonatomic, assign) NSUInteger width;
@property (nonatomic, assign) NSUInteger height;
@end

@interface XXVideoFrameRGB : XXVideoFrame
@property (nonatomic, assign) NSUInteger linesize;
@property (nonatomic, strong) NSData *rgb;
@end

@interface XXVideoFrameYUV : XXVideoFrame
@property (nonatomic, strong) NSData *luma;
@property (nonatomic, strong) NSData *chromaB;
@property (nonatomic, strong) NSData *chromaR;
@end

@protocol XXDecoderDelegate <NSObject>

- (void)getYUV420Data:(void *)pData width:(int)width height:(int)height;

@end

@interface XXDecoder : NSObject

///代理
@property (weak, nonatomic) id<XXDecoderDelegate> delegate;

@property (nonatomic, strong, readonly) NSString *path;
@property (nonatomic, assign) CGFloat fps;

@property (nonatomic, assign) NSUInteger frameWidth;
@property (nonatomic, assign) NSUInteger frameHeight;

- (BOOL)openFile:(NSString *)path error:(NSError **)perror;

- (NSArray *)decodeFrames:(CGFloat)minDuration;

- (BOOL)setupVideoFrameFormat:(XXVideoFrameFormat)format;

@end

NS_ASSUME_NONNULL_END

//
//  UHDurationCalculator.h
//  LGVideo
//
//  Created by coderyi on 2019/6/27.
//  Copyright © 2019 右划科技. All rights reserved.
//
/**
 * 时长统计的类
 * 缘起：
 * -----start----pause------start---pause----
 * 用于统计start+pause的总时长，常见场景比如要统计观看视频到一定时长（40分钟）然后做一个行为，但是中间可能因为App失活或者离开feed页，所以如果一个方便暂停开启的计时器，并且可以随时拿到真正的duration，那就比较方便，所以有了这么一个类
 * 设计：通过传入caculatorID创建一个计时器，start，pause控制内部状态，会持久化到NSUserDefault
 * 使用：具体使用Demo可以参考UHYoungModeHelper对它的使用
 */

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UHDurationCalculatorState) {
    UHDurationCalculatorStateRunning = 100, // 计时状态
    UHDurationCalculatorStatePause = 200, // 暂停状态
};

NS_ASSUME_NONNULL_BEGIN

@interface UHDurationCalculator : NSObject

// 传入caculatorID 获取一个calculator
+ (UHDurationCalculator *)durationCalculatorWithID:(NSString *)caculatorID;

// 计时器状态
@property (nonatomic, assign) UHDurationCalculatorState state;

// 暂停计时器
- (void)pause;

// 开始计时器
- (void)start;

// 获取计时器统计的时长
- (NSTimeInterval)getDuration;

// 清空计时器统计
- (void)clear;

@end

NS_ASSUME_NONNULL_END

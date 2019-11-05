//
//  UHDurationCalculator.m
//  LGVideo
//
//  Created by coderyi on 2019/6/27.
//  Copyright © 2019 右划科技. All rights reserved.
//

#import "UHDurationCalculator.h"
@interface UHDurationCalculator ()
@property (nonatomic, copy) NSString *caculatorID;
@property (nonatomic, assign) NSTimeInterval duration;

@end

@implementation UHDurationCalculator

+ (UHDurationCalculator *)durationCalculatorWithID:(NSString *)caculatorID
{
    if (caculatorID.length < 1) {
        return nil;
    }
    UHDurationCalculator *calculator = [[UHDurationCalculator alloc] initWithCaculatorID:caculatorID];
    return calculator;
}

- (id)initWithCaculatorID:(NSString *)caculatorID
{
    self = [super init];
    if (self) {
        _caculatorID = caculatorID;
        _state = UHDurationCalculatorStatePause;
        NSTimeInterval duration = [[[NSUserDefaults standardUserDefaults] objectForKey:_caculatorID] doubleValue];
        _duration = duration;
    }
    return self;
}

- (void)pause
{
    if (_state == UHDurationCalculatorStatePause) {
        return;
    }
    NSDate *now = [NSDate date];
    //当前时间的时间戳
    NSTimeInterval nowStamp = [now timeIntervalSince1970];
    
    NSTimeInterval lastStamp = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_start",_caculatorID]] doubleValue];
    NSTimeInterval duration = nowStamp - lastStamp;
    
    if (duration > 0) {
        NSTimeInterval lastDuration = [[[NSUserDefaults standardUserDefaults] objectForKey:_caculatorID] doubleValue];
        _duration = lastDuration + duration;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:_duration] forKey:_caculatorID];
    }
    _state = UHDurationCalculatorStatePause;
}

- (void)start
{
    if (_state == UHDurationCalculatorStateRunning) {
        return;
    }
    _state = UHDurationCalculatorStateRunning;
    
    NSDate *now = [NSDate date];
    //当前时间的时间戳
    NSTimeInterval nowStamp = [now timeIntervalSince1970];

    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:nowStamp] forKey:[NSString stringWithFormat:@"%@_start",_caculatorID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSTimeInterval)getDuration
{
    if (_state == UHDurationCalculatorStatePause) {
        return _duration;
    } else if (_state == UHDurationCalculatorStateRunning) {
        NSTimeInterval totalDuration = 0;
        NSDate *now = [NSDate date];
        //当前时间的时间戳
        NSTimeInterval nowStamp = [now timeIntervalSince1970];
        NSTimeInterval lastStamp = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_start",_caculatorID]] doubleValue];
        NSTimeInterval duration = nowStamp - lastStamp;
        NSTimeInterval lastDuration = [[[NSUserDefaults standardUserDefaults] objectForKey:_caculatorID] doubleValue];
        if (duration > 0) {
            totalDuration = lastDuration + duration;
        } else {
            totalDuration = lastDuration;
        }
        return totalDuration;
    }
    return 0.0;
}

- (void)clear
{
    _state = UHDurationCalculatorStatePause;
    _duration = 0.0;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:0.0] forKey:_caculatorID];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:0.0] forKey:[NSString stringWithFormat:@"%@_start",_caculatorID]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end

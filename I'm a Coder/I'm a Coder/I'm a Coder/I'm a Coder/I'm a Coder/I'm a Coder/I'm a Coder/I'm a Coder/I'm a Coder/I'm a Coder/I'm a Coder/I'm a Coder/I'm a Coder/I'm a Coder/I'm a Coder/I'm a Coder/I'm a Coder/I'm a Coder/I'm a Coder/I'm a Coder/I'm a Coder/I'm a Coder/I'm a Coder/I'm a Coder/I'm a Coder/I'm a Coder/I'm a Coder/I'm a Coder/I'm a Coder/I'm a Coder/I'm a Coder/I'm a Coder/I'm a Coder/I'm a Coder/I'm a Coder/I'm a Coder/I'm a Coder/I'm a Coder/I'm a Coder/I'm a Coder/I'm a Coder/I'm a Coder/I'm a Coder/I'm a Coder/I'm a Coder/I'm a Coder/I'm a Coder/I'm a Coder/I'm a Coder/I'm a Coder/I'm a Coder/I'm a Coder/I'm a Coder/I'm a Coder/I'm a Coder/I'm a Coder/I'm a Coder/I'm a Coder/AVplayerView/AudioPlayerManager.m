//
//  AudioPlayerManager.m
//  MusicDemo
//
//  Created by lanou3g on 15/9/23.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "AudioPlayerManager.h"

@import AVFoundation; //系统库  相当于加括号的。

//写延展是为了安全性
@interface AudioPlayerManager ()
@property(nonatomic,strong)AVPlayer *player;
//计时器
@property (nonatomic,strong)NSTimer *timer;


@end

@implementation AudioPlayerManager

+ (AudioPlayerManager *)shareAudioPlayerManager
{
    static AudioPlayerManager *audioPlayerManager = nil;

    @synchronized(self)
    {
        if (audioPlayerManager == nil) {
            audioPlayerManager = [[AudioPlayerManager alloc]init];
        }
    }
    return audioPlayerManager;
}

//player 初始化方法
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.player = [[AVPlayer alloc]init];
    }
    return self;
}

//准备播放的方法  
- (void)prepareMusic
{
    //如果已经有了观察者，需要移除观察者。
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    //初始化一个item
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:self.url]];
    //添加观察者
    [item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld ) context:nil];
    //把player当前的item替换成我们初始化的item
    [self.player replaceCurrentItemWithPlayerItem:item];
    
}

//实现观察者方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    //如果这个路径是status。status是一个枚举
    if ([keyPath isEqualToString:@"status"]) {
        //没有＊号。通过key拿到对象，用status接受
        AVPlayerItemStatus status = [[change valueForKey:@"new"]integerValue];
        switch (status)
        {
            case AVPlayerItemStatusUnknown:
            {
                NSLog(@"未知");
                break;
            }
            case AVPlayerItemStatusReadyToPlay:
            {
                [self playMusic];
                break;
            }
            case AVPlayerItemStatusFailed:
            {
                NSLog(@"失败");
                break;
            }
                
            default:
                break;
        }
    }
}


//实现播放方法
- (void)playMusic
{
    self.isPlaying = YES;
//  设定只有一个timer，如果生成一个就返回。
    if (self.timer) {
        return;
    }
    [self.player play];
    
    //计时器,进度条有关
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(timaAction) userInfo:nil repeats:YES];
}

//计时器的方法，主要用来调用代理方法
- (void)timaAction
{
    //代理：安全判断
    if (_delegate && [_delegate respondsToSelector:@selector(getCurrentTime:TotalTime:Progress:)])
    {
        [_delegate getCurrentTime:[self transformWith:[self currentTimeValue]] TotalTime:[self transformWith:[self totalTimaeValue]] Progress:[self progress]];
    }
}

//当前时间
- (NSInteger)currentTimeValue
{
    //当前“时间”除以当前的timescale就是当前的时间。
    return (self.player.currentTime.value)/self.player.currentTime.timescale;
}

//总时间
- (NSInteger)totalTimaeValue
{
    CMTime time = [self.player.currentItem duration];
    if (time.timescale == 0) {
        return 0;
    }else
    {
    return time.value/time.timescale;
    }
}

//进度
- (CGFloat)progress
{
    //强转取小数
    return (CGFloat)[self currentTimeValue]/(CGFloat)[self totalTimaeValue];
}

//数字转化为字符串
- (NSString *)transformWith:(NSInteger)time;
{
    //传过来的time是以秒为单位的。
    return [NSString stringWithFormat:@"%.2ld:%.2ld",time/60,time%60];
    
}


//暂停播放
- (void)pauseMusic
{
    //暂停之后时间无效
    [self.timer invalidate];
    self.timer = nil;
    
    self.isPlaying = NO;
    [self.player pause];
}


//自定义播放时间
- (void)seekToTime:(CGFloat)time
{
    [self pauseMusic];
    [self.player seekToTime:CMTimeMake(time*[self totalTimaeValue], 1) completionHandler:^(BOOL finished) {
        if (finished) {
            [self playMusic];
        }
        
    }];
}
@end

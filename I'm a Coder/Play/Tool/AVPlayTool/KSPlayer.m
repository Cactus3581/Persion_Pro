//
//  KSPlayer.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/11.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "KSPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "KSFileHandle.h"
#import "KSResourceLoader.h"
#import "KSPlayAudioCategory.h"

@interface KSPlayer()<KSResourceLoaderDelegate>
@property (nonatomic, strong) AVPlayer *player;//播放器
@property (strong, nonatomic) id timeObserver;  //视频播放时间观察者
@property (nonatomic, assign, readonly) BOOL playEnded;//记录是否播放完毕
@property (nonatomic, strong) KSResourceLoader * resourceLoader;

@end

static KSPlayer *playerManager = nil;
@implementation KSPlayer
#pragma mark - 初始化 布局
+ (instancetype)shareAVplayer{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerManager = [[KSPlayer alloc]init];
    });
    return playerManager;
}

#pragma mark - 创建播放器
- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];

    }
    return _player;
}

#pragma mark - setter 视频地址赋值
- (void)setUrlString:(NSString *)urlString {
    if ([XRZValidateString(_urlString) isEqualToString:urlString]) {
        return; //如果音频地址一样，返回
    }
    _urlString = urlString;
    [self preparePlay];
}

#pragma mark - 准备播放
- (void)preparePlay {
    [self resetPlayer];
    NSURL *url = [NSURL URLWithString:[self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    AVPlayerItem *playerItem;//创建新的item
    //有缓存播放缓存文件
    NSString * cacheFilePath = [KSFileHandle cacheFileExistsWithURL:url];
    if (cacheFilePath) {
        NSURL * url = [NSURL fileURLWithPath:cacheFilePath];
        playerItem = [AVPlayerItem playerItemWithURL:url];
        NSLog(@"有缓存，播放缓存文件");
        [self progressWithFile:YES cacheProgress:0];
    }else {
        //没有缓存播放网络文件
        self.resourceLoader = [[KSResourceLoader alloc]init];
        self.resourceLoader.delegate = self;
        AVURLAsset * asset = [AVURLAsset URLAssetWithURL:[url customSchemeURL] options:nil];
        [asset.resourceLoader setDelegate:self.resourceLoader queue:dispatch_get_main_queue()];
        playerItem = [AVPlayerItem playerItemWithAsset:asset];
        NSLog(@"无缓存，播放网络文件");
    }
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionInterrupted:) name:AVAudioSessionInterruptionNotification object:nil];
    //Observer
    [self addObserver:playerItem];
    _state = PlayerStateWaiting;

}

- (void)audioSessionInterrupted:(NSNotification *)notification{
    //通知类型
    NSDictionary * info = notification.userInfo;
    if ([[info objectForKey:AVAudioSessionInterruptionTypeKey] integerValue] == 1) {
        [self pause];
    }else{
        [self play];
    }
}

- (BOOL)isPlaying{
    if (self.state == PlayerStatePlaying) {
        return YES;
    }
    return NO;
}

#pragma mark - KVO
- (void)addObserver:(AVPlayerItem *)playerItem {
    //播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    //播放进度
    __weak typeof(self) weakSelf = self;
    // 播放1s回调一次
    self.timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //给显示时间的label赋值
        [weakSelf setTimeLabel];
        NSTimeInterval totalTime = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
        //给slider赋值:time.value/time.timescale是当前时间
        if (weakSelf.delegate && [_delegate respondsToSelector:@selector(slideValue:)]) {
            [weakSelf.delegate slideValue:time.value/time.timescale/totalTime];
        }
    }];
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.timeObserver) {
        [self.player removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
        [self.player removeObserver:self forKeyPath:@"rate"];
    }
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [self.player.currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.player.currentItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:self.player.currentItem];

}

#pragma mark - KSLoaderDelegate:关于进度的
- (void)loader:(KSResourceLoader *)loader cacheProgress:(CGFloat)progress {
    [self progressWithFile:NO cacheProgress:progress];
}

#pragma mark - KSLoaderDelegate:关于进度下载失败
- (void)loader:(KSResourceLoader *)loader failLoadingWithError:(NSError *)error {
    _state = PlayerStateError;
    if (_delegate && [_delegate respondsToSelector:@selector(playFail:)]) {
        [_delegate playFail:error];
    }
}

#pragma mark -  当用setter方法赋值视频地址,准备播放时 :播放暂停，重制播放器状态.
- (void)resetPlayer {
    if (self.state == PlayerStateStopped) {
        return;
    }
    _playEnded = NO;
    [self pause];
    //移除kvo
    [self removeObserver];
    [self.resourceLoader stopLoading];
    self.resourceLoader = nil;
    [self configurePlayButtonWithSelected:NO];
    [self configureControlWithEnabled:NO];
    self.state = PlayerStateStopped;

    //[_activityView startAnimating];
}

- (void)configureControlWithEnabled:(BOOL)enabled {
    if (_delegate && [_delegate respondsToSelector:@selector(controlEnabled:)]) {
        [_delegate controlEnabled:enabled];
    }
}

- (void)configurePlayButtonWithSelected:(BOOL)selected {
    if (_delegate && [_delegate respondsToSelector:@selector(playButton:)]) {
        [_delegate playButton:selected];
    }
}

#pragma mark - KVO 监听item状态方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    //只执行一次
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        switch (status) {
            case AVPlayerItemStatusUnknown: {
                NSLog(@"未知");
                [self configureControlWithEnabled:NO];
                break;
            }
            case AVPlayerItemStatusReadyToPlay: {
                NSLog(@"播放音乐");
                [self setTimeLabel];
                [self configureControlWithEnabled:YES];
                break;
            }
            case AVPlayerItemStatusFailed: {
                NSLog(@"失败");
                [self configureControlWithEnabled:NO];
                break;
            }
            default:
                [self configureControlWithEnabled:NO];
                break;
        }
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        /*
        //设置缓冲进度
        NSArray *array = self.player.currentItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
        NSTimeInterval startSeconds = CMTimeGetSeconds(timeRange.start);//本次缓冲起始时间
        NSTimeInterval durationSeconds = CMTimeGetSeconds(timeRange.duration);//缓冲时间
        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
        float totalTime = CMTimeGetSeconds(self.player.currentItem.duration);//视频总长度
        float progress = totalBuffer/totalTime;//缓冲进度
        if (_delegate && [_delegate respondsToSelector:@selector(progress:)]) {
            [_delegate progress:progress];
        }
         */
    }
    if ([keyPath isEqualToString:@"rate"]) {
        if (self.player.rate == 0.0) {
            _state = PlayerStatePaused;
        }else {
            _state = PlayerStatePlaying;
        }
    }
}

#pragma mark - 播放键 点击播放动作
- (void)playButtonClick {
    //rate ==1.0，表示正在播放；rate == 0.0，暂停；rate == -1.0，播放失败
    if (self.player.rate == 0) {
        [self play];
    } else if (self.player.rate == 1) {
        [self pause];
    }
}

#pragma mark - 开始播放
- (void)play {
    // 如果已播放完毕，则重新从头开始播放
    if (_playEnded == YES) {
        [self.player seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        _playEnded = NO;
    }
    [self.player play];
    [self configurePlayButtonWithSelected:YES];
}

#pragma mark - 暂停
- (void)pause {
    [self.player pause];
    [self configurePlayButtonWithSelected:NO];
}

//自定义播放时间
- (void)seekToTime:(CGFloat)value {
    if (self.state == PlayerStatePlaying || self.state == PlayerStatePaused) {
        NSTimeInterval slideTime = CMTimeGetSeconds(self.player.currentItem.duration) * value;
        if (slideTime == CMTimeGetSeconds(self.player.currentItem.duration)) {
            slideTime -= 0.5;
        }
        //self.resourceLoader.seekRequired = YES;(如果为yes：seek过的歌曲都不会缓存）
        [self.player seekToTime:CMTimeMakeWithSeconds(slideTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        [self play];
    }
}

#pragma mark - 播放完成通知方法
-(void)playFinished:(NSNotification *)noti {
    _playEnded = YES;
    [self pause];
    [self configurePlayButtonWithSelected:NO];
}

- (void)setTimeLabel {
    if (_delegate && [_delegate respondsToSelector:@selector(getCurrentTime:TotalTime:)]) {
        [_delegate getCurrentTime:[self currentTimeStr] TotalTime:self.totalTimeStr];
    }
}

#pragma mark - 获取总时间，当前时间，当前进度
- (NSString *)totalTimeStr {
    NSInteger totalTime = self.totalTime;
    NSInteger totalMin = totalTime / 60;
    NSInteger totalSec = (NSInteger)totalTime % 60;
    return  [NSString stringWithFormat:@"%02td:%02td",totalMin,totalSec];
}

- (NSString *)currentTimeStr {
    NSInteger currentTime = self.currentTime;
    NSInteger currentMin = currentTime / 60;
    NSInteger currentSec = (NSInteger)currentTime % 60;
    return [NSString stringWithFormat:@"%02td:%02td",currentMin,currentSec];
}

- (NSInteger)totalTime {
    NSTimeInterval totalTime = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    // 切换视频源时totalTime/currentTime的值会出现nan导致时间错乱
    if (!(totalTime>=0)||!(currentTime>=0)) {
        totalTime = 0;
    }
    return totalTime;
}

- (NSInteger)currentTime {
    NSTimeInterval totalTime = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    // 切换视频源时totalTime/currentTime的值会出现nan导致时间错乱
    if (!(totalTime>=0)||!(currentTime>=0)) {
        currentTime = 0;
    }
    return currentTime;
}

- (void)progressWithFile:(BOOL)finish cacheProgress:(CGFloat)progress {
    if (finish) {
        progress = 1.0f;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(progress:)]) {
        [_delegate progress:progress];
    }
}

#pragma mark -  销毁时做的操作，如移除通知
- (void)dealloc {
    //移除kvo
    [self removeObserver];
}

@end

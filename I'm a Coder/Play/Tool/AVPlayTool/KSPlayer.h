//
//  KSPlayer.h
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/11.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, KSPlayerState) {
    PlayerStateWaiting,
    PlayerStatePlaying,
    PlayerStatePaused,
    PlayerStateStopped,
    PlayerStateBuffering,
    PlayerStateError
};

@protocol KSPlayerDelegate <NSObject>
- (void)getCurrentTime:(NSString *)curentTime TotalTime:(NSString *)totalTime;//获取总时间，当前时间
- (void)controlEnabled:(BOOL)enabled;//可以播放后的一切动作：停止播放菊花；button，slide可以响应事件
- (void)progress:(CGFloat)progress;////设置缓冲进度
- (void)slideValue:(CGFloat)value;//给外部的slide赋值
- (void)playButton:(CGFloat)selected;//button 切换播放暂停图片
- (void)playFail:(NSError *)error;

@end


@interface KSPlayer : NSObject
@property (nonatomic, copy) NSString *urlString;//视频地址
+ (instancetype)shareAVplayer;
- (void)playButtonClick; //外界view的播放按钮事件
- (void)seekToTime:(CGFloat)value; //滑动时间,跳到某个时间进度
- (void)play;//播放
- (void)pause;//暂停
@property (nonatomic,copy) NSString *totalTimeStr;
@property (nonatomic,copy) NSString *currentTimeStr;
@property (nonatomic,assign) NSInteger totalTime;
@property (nonatomic,assign) NSInteger currentTime;
@property (nonatomic,assign) BOOL controlEnabled;
@property (nonatomic, assign) KSPlayerState state;

@property (nonatomic, assign) CGFloat slideValue;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat cacheProgress;
@property (nonatomic, assign) BOOL playSelected;


/**
 *  当前歌曲缓存情况 YES：已缓存  NO：未缓存
 */
- (BOOL)currentItemCacheState;

/**
 *  当前歌曲缓存文件完整路径
 */
- (NSString *)currentItemCacheFilePath;

/**
 *  清除缓存
 */
+ (BOOL)clearCache;
/**
 *  正在播放
 */
- (BOOL)isPlaying;
@property (nonatomic,weak)id<KSPlayerDelegate>delegate;

@end

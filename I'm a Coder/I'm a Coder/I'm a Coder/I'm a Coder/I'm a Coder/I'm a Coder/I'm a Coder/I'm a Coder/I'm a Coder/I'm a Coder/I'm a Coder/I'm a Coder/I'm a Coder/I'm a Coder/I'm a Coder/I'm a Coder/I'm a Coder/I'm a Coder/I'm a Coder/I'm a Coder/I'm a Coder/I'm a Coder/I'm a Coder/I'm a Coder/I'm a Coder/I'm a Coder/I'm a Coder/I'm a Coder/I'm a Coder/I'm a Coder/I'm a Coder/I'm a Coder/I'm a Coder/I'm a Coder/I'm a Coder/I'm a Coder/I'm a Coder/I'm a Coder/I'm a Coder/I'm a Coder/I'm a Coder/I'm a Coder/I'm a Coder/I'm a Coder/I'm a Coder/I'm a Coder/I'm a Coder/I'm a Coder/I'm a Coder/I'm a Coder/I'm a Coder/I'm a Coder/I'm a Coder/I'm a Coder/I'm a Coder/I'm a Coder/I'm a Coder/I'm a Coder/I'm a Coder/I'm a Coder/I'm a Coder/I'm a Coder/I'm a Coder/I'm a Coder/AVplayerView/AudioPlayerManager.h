//
//  AudioPlayerManager.h
//  MusicDemo
//
//  Created by lanou3g on 15/9/23.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AudioPlayerManagerDelegate <NSObject>
- (void)getCurrentTime:(NSString *)curentTime TotalTime:(NSString *)totalTime Progress:(CGFloat)progress;
@end

@interface AudioPlayerManager : NSObject
//拿到音乐数据／地址
@property (nonatomic,strong)NSString *url;
//判断播放
@property (nonatomic,assign)BOOL isPlaying;
@property (nonatomic,weak) id<AudioPlayerManagerDelegate>delegate;

//单例:原因，始终是一个，否则页面跳转会新初始化一个。而且在回到前页的时候，单例不释放。
+ (AudioPlayerManager *)shareAudioPlayerManager;
//准备播放
- (void)prepareMusic;
//播放方法
- (void)playMusic;
//暂停播放
- (void)pauseMusic;

//自定义播放时间
- (void)seekToTime:(CGFloat)time;

@end

//
//  AudioPlayerView.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/7.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "AudioPlayerView.h"
#import "PLayButton.h"
@interface AudioPlayerView ()<AudioPlayerManagerDelegate>

@property (strong, nonatomic) UIView *toolView;
@property (strong, nonatomic) UILabel *totalTime;
@property (strong, nonatomic)  UILabel *currentTime;
@property (strong, nonatomic) PLayButton *playButton;
@property (strong, nonatomic) UISlider *slider;

@end

static AudioPlayerView *playerView = nil;
@implementation AudioPlayerView
+ (AudioPlayerView *)sharePlayView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerView = [[AudioPlayerView alloc]init];
    });
    return playerView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layoutUI];
        [AudioPlayerManager shareAudioPlayerManager].delegate = self;
    }
    [self play];
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

//播放：给AudioPlayerManager赋值，并且调用准备播放方法。
- (void)play {
    [AudioPlayerManager shareAudioPlayerManager].url = _url;
    [[AudioPlayerManager shareAudioPlayerManager] prepareMusic];
}

//实现代理方法:选择当播放的时候传过来。
- (void)getCurrentTime:(NSString *)curentTime TotalTime:(NSString *)totalTime Progress:(CGFloat)progress {
    self.slider.maximumValue = 1;
    self.currentTime.text = curentTime;
    self.totalTime.text = totalTime;
    self.slider.value = progress;
    _currentTime.text = curentTime;
}

//UISlider滑动方法
- (void)sliderValueChanged:(UISlider *)sender {
    [[AudioPlayerManager shareAudioPlayerManager] seekToTime:sender.value];
}

#pragma mark - setter 视频地址赋值
- (void)setUrl:(NSString *)url {
    _url = url;
}

#pragma mark -  销毁时做的操作，如移除通知
- (void)dealloc {
    //    [self playerItemRemoveObserver];
    //    [self.player replaceCurrentItemWithPlayerItem:nil];
    //    //移除时间观察者
    //    [self.player removeTimeObserver:self.timeObserver];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //
    //    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}


#pragma mark - 布局UI
- (void)layoutUI {
    _toolView = [[UIView alloc]init];
    _toolView.alpha = 0.7;
    self.backgroundColor =  [UIColor whiteColor];
    [self addSubview:_toolView];
    
    _playButton = [PLayButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:[UIImage imageNamed:@"voa_media_play"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"voa_media_stop"] forState:UIControlStateSelected];
    [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _playButton.enabled = YES;
    
    _currentTime = [[UILabel alloc]init];
    _currentTime.text =@"00:00";
    _currentTime.textColor =  [UIColor darkTextColor];
    _currentTime.font = [UIFont systemFontOfSize:10];
    _currentTime.textAlignment = NSTextAlignmentLeft;
    
    _slider = [[UISlider alloc]init];
    _slider.enabled = NO;
    [_slider setThumbImage:[UIImage imageNamed:@"avplyer"] forState:UIControlStateNormal];
    _slider.minimumTrackTintColor =  [UIColor greenColor];//大于滑块当前值滑块条的颜色，默认为白色
    //_slider.maximumTrackTintColor = [UIColor clearColor];//大于滑块当前值滑块条的颜色
    _slider.maximumTrackTintColor = [UIColor greenColor];//大于滑块当前值滑块条的颜色
    //    [_slider addTarget:self action:@selector(sliderPause:) forControlEvents:UIControlEventTouchDown];
    //    [_slider addTarget:self action:@selector(sliderPlay:) forControlEvents:UIControlEventTouchUpInside];
    //    [_slider addTarget:self action:@selector(sliderPlay:) forControlEvents:UIControlEventTouchUpOutside];
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    
    _totalTime = [[UILabel alloc]init];
    _totalTime.text =@"00:00";
    _totalTime.textColor = [UIColor darkTextColor];
    _totalTime.font = [UIFont systemFontOfSize:10];
    _totalTime.textAlignment = NSTextAlignmentRight;
    
    [_toolView addSubview:self.playButton];
    [_toolView addSubview:self.currentTime];
    [_toolView addSubview:self.slider];
    [_toolView addSubview:self.totalTime];
}

//播放暂停键
- (void)playButtonClick:(id)sender {
    if ([AudioPlayerManager shareAudioPlayerManager].isPlaying) {
        [[AudioPlayerManager shareAudioPlayerManager] pauseMusic];
        _playButton.selected = YES;
    }else {
        [[AudioPlayerManager shareAudioPlayerManager] playMusic];
        _playButton.selected = NO;
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.right.equalTo(self).offset(-20);
        make.top.equalTo(self).offset(1);
        make.bottom.equalTo(self).offset(-1);
    }];
    self.toolView.layer.cornerRadius = 20;
    self.toolView.layer.borderColor = [UIColor darkTextColor].CGColor;
    self.toolView.layer.borderWidth = 1;
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.toolView).offset(15);
        make.centerY.equalTo(self.toolView);
        make.width.height.mas_offset(30);
    }];
    
    [self.currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playButton.mas_right).offset(10);
        make.centerY.equalTo(self.toolView);
    }];
    
    [self.totalTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolView);
        make.right.equalTo(self.toolView.mas_right).offset(-15);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.currentTime.mas_right).offset(10);
        make.centerY.equalTo(self.toolView);
        make.height.mas_offset(30);
        make.right.equalTo(self.totalTime.mas_left).offset(-10);
    }];
    
    //    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
    ////        make.left.equalTo(self.slider).offset(1);
    ////        make.right.equalTo(self.slider).offset(-3);
    ////        make.centerY.equalTo(self.slider).offset(1);
    ////        make.height.mas_offset(2);
    //        make.left.equalTo(self.slider);
    //        make.right.equalTo(self.slider);
    //        make.centerY.equalTo(self.slider).offset(1);
    //        make.height.mas_offset(2);
    //    }];
}


@end


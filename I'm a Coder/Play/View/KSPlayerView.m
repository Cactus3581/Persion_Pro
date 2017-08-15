//
//  KSPlayerView.m
//  I'm a Coder
//
//  Created by xiaruzhen on 2017/8/11.
//  Copyright © 2017年 xiaruzhen. All rights reserved.
//

#import "KSPlayerView.h"
#import "KSPlayer.h"

@interface KSPlayerView()<KSPlayerDelegate>
//UI 元素
@property (strong, nonatomic) UIView *toolView;
@property (strong, nonatomic) UILabel *totalTime;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UISlider *slider;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UILabel *currentTime;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) KSPlayer *player;
@end

@implementation KSPlayerView
#pragma mark - 初始化 布局
- (instancetype)init {
    self = [super init];
    if (self) {
        [self layoutUI];
        //添加自身view活跃情况的通知,当不活跃时，暂停播放
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    }
    return self;
}

- (KSPlayer *)player {
    if (!_player) {
        _player = [KSPlayer shareAVplayer];
        _player.delegate = self;
    }
    return _player;
}

- (void)addKVO {
    [self.player addObserver:self forKeyPath:@"slideValue" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"cacheProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"playSelected" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"playSelected" options:NSKeyValueObservingOptionNew context:nil];
    [self.player addObserver:self forKeyPath:@"playSelected" options:NSKeyValueObservingOptionNew context:nil];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"slideValue"]) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.slider.value = self.player.progress;
//                self.currentTime.text = [self convertStringWithTime:self.player.duration * self.player.progress];
//            });
//    }
//    if ([keyPath isEqualToString:@"duration"]) {
//        if (self.player.duration > 0) {
//            self.duration.text = [self convertStringWithTime:self.player.duration];
//            self.duration.hidden = NO;
//            self.currentTime.hidden = NO;
//        }else {
//            self.duration.hidden = YES;
//            self.currentTime.hidden = YES;
//        }
//    }
//    if ([keyPath isEqualToString:@"cacheProgress"]) {
//        //        NSLog(@"缓存进度：%f", self.player.cacheProgress);
//    }
//}

- (void)setKeepDelegate:(BOOL)keep {
    if (keep) {
        self.player.delegate = self;
    }
}

#pragma mark - 提供给外界的接口
- (void)play {
    [self.player play];
}

- (void)pause {
    [self.player pause];
}

#pragma mark - delegate
//获取总时间，当前时间
- (void)getCurrentTime:(NSString *)curentTime TotalTime:(NSString *)totalTime {
    self.currentTime.text = curentTime;
    self.totalTime.text = totalTime;
}

//可以播放后的一切动作：button，slide可以响应事件
- (void)controlEnabled:(BOOL)enabled {
     _slider.enabled = _playButton.enabled = enabled;
}

//设置缓冲进度
- (void)progress:(CGFloat)progress {
    _progressView.progress = progress;
    if (progress < _slider.value) {
        [_activityView startAnimating];
    }else {
        [_activityView stopAnimating];
    }
}

//给外部的slide赋值
- (void)slideValue:(CGFloat)value {
    _slider.value = value;
}

//button 切换播放暂停图片
- (void)playButton:(CGFloat)selected {
    self.playButton.selected = selected;
}

//下载播放出错
- (void)playFail:(NSError *)error {
    
}

#pragma mark - setter 视频地址赋值
- (void)setUrlString:(NSString *)urlString {
    if ([XRZValidateString(_urlString) isEqualToString:urlString]) {
        return;
    }
    _urlString = urlString;
    self.player.urlString = urlString;
//    [self addKVO];
}

#pragma mark - 播放键 点击事件
- (void)playButtonClick:(UIButton *)sender {
    [self.player playButtonClick];
}

#pragma mark - Slider点击/滑动动作
- (void)sliderPlay:(UISlider *)sender {
    [self.player seekToTime:sender.value];
}

- (void)sliderPause:(UISlider *)sender {
    [self.player pause];
}

- (void)sliderValueChanged:(UISlider *)sender {
    _currentTime.text = self.player.currentTimeStr;
}


#pragma mark - 布局UI
- (void)layoutUI {
    _toolView = [[UIView alloc]init];
    [self addSubview:_toolView];
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_playButton setImage:[UIImage imageNamed:@"play_player"]  forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"pause_player"] forState:UIControlStateSelected];
    [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    _playButton.enabled = NO;

    _currentTime = [[UILabel alloc]init];
    _currentTime.text =@"00:00";
    _currentTime.font = [UIFont systemFontOfSize:10];
    _currentTime.textAlignment = NSTextAlignmentLeft;

    _slider = [[UISlider alloc]init];
//    _slider.enabled = NO;
    [_slider setThumbImage:[UIImage imageNamed:@"avplyer"] forState:UIControlStateNormal];
    _slider.minimumTrackTintColor = [UIColor redColor];//小于滑块当前值滑块条的颜色，默认为白色
    _slider.maximumTrackTintColor = [UIColor lightTextColor];//大于滑块当前值滑块条的颜色
    [_slider addTarget:self action:@selector(sliderPause:) forControlEvents:UIControlEventTouchDown];//按下
    [_slider addTarget:self action:@selector(sliderPlay:) forControlEvents:UIControlEventTouchUpInside];//抬起
    [_slider addTarget:self action:@selector(sliderPlay:) forControlEvents:UIControlEventTouchUpOutside];//拖动
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    //后面的颜色（譬如进度到30%，那么30%部分后面的颜色就是这个属性）
    [_progressView setProgressTintColor:[UIColor blackColor]];
    //前面的颜色
    [_progressView setTrackTintColor:[UIColor greenColor]];

    _totalTime = [[UILabel alloc]init];
    _totalTime.text =@"00:00";
    _totalTime.font = [UIFont systemFontOfSize:10];
    _totalTime.textAlignment = NSTextAlignmentRight;

    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityView.color = [UIColor redColor];
    [_activityView startAnimating];
    
    [_toolView addSubview:self.playButton];
    [_toolView addSubview:self.currentTime];
    [_toolView addSubview:self.slider];
    [_toolView addSubview:self.totalTime];
    [_toolView addSubview:self.activityView];

    [_slider addSubview:self.progressView];
    [_slider sendSubviewToBack:_progressView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.top.equalTo(self).offset(1);
        make.bottom.equalTo(self).offset(-1);
    }];

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
        make.right.equalTo(self.toolView.mas_right).offset(-35);
    }];

    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.toolView).offset(95);
        make.right.equalTo(self.toolView).offset(-70);
        make.centerY.equalTo(self.toolView);
        make.height.mas_offset(30);
    }];

    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.slider);
        make.right.equalTo(self.slider);
        make.centerY.equalTo(self.slider).offset(1);
        make.height.mas_offset(2);
    }];
    
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(10);
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self.slider);
    }];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(.7f, .7f);
    self.activityView.transform = transform;
    [self setThemeColor];
}

- (void)setThemeColor {
    self.backgroundColor = [UIColor greenColor];
    self.toolView.backgroundColor = [UIColor whiteColor];
    [_playButton setImage:[UIImage imageNamed:@"play_player"]  forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamed:@"pause_player"] forState:UIControlStateSelected];
    [_slider setThumbImage:[UIImage imageNamed:@"avplyer"] forState:UIControlStateNormal];
    _slider.minimumTrackTintColor = [UIColor whiteColor];
    _slider.maximumTrackTintColor = [UIColor whiteColor];
    _slider.minimumTrackTintColor = [UIColor redColor];//大于滑块当前值滑块条的颜色，默认为白色
    _slider.maximumTrackTintColor = [UIColor greenColor];//大于滑块当前值滑块条的颜色
    [_progressView setProgressTintColor:[UIColor blackColor]];
    [_progressView setTrackTintColor:[UIColor lightTextColor]];
    self.toolView.layer.cornerRadius = 20;
    self.toolView.layer.borderColor = [UIColor lightTextColor].CGColor;
    self.toolView.layer.borderWidth = 1;
    _activityView.color = [UIColor redColor];

}

@end

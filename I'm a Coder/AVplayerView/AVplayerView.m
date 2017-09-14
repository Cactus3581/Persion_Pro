//
//  AVplayerView.m
//  yanagou
//
//  Created by xiaruzhen on 2016/10/11.
//  Copyright © 2016年 com.yanagou. All rights reserved.
//

#import "AVplayerView.h"
#import "PLayButton.h"
@interface AVplayerView()

//播放器
@property (nonatomic, strong) AVPlayer *player;//播放器
@property (strong, nonatomic) id timeObserver;  //视频播放时间观察者
//记录
@property (nonatomic, assign, readonly) BOOL playEnded;//是否播放完毕
//UI 元素
@property (strong, nonatomic) UIView *toolView;
@property (strong, nonatomic) UILabel *totalTime;
@property (strong, nonatomic) PLayButton *playButton;
@property (strong, nonatomic) UISlider *slider;
@end

static AVplayerView *playerView = nil;

@implementation AVplayerView

#pragma mark - 初始化 布局
+ (instancetype)shareAVplayerView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        playerView = [[AVplayerView alloc]init];
        AVAudioSession *session = [AVAudioSession sharedInstance];
        
        NSError *activeError = nil;
        if (![session setActive:YES error:&activeError]) {
            NSLog(@"Failed to set active audio session!");
        }
        
        //No.1
        //开始写代码，调整音频会话设置，确保即便应用进入后台或静音开关已开启，音频仍将继续播放
        
        NSError *categoryError = nil;
        [session setCategory:AVAudioSessionCategoryPlayback error:&categoryError];
        
        
        //end_code

    });
    return playerView;
}
//No.3
//开始写代码，响应远程控制，使得进入锁屏状态后可以控制音乐“播放”和“暂停”


- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [self.player play];
                break;
                
            case UIEventSubtypeRemoteControlPause:
                [self.player pause];
                break;
                
            default:
                NSLog(@"没有处理过这个事件------receivedEvent.subtype==%ld",(long)receivedEvent.subtype);
                break;
        }
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self layoutUI];
    }
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

#pragma mark - 创建播放器
- (AVPlayer *)player {
    if (!_player) {
        _player = [[AVPlayer alloc] init];
        
        __weak typeof(self) weakSelf = self;
        // 播放1s回调一次
        self.timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
            //给显示时间的label赋值
            [weakSelf setTimeLabel];
            //给slider赋值
            NSTimeInterval totalTime = CMTimeGetSeconds(weakSelf.player.currentItem.duration);
            weakSelf.slider.value = time.value/time.timescale/totalTime;
        }];
    }
    return _player;
}

- (void)preparePlay {
    [self playButtonClick:_playButton];
}
- (void)preparePLay {
    [self resetPlayer];
    if (self.player.currentItem != nil) {
        //移除播放完成通知
        //移除item观察者
        [self playerItemRemoveObserver];
    }
    NSURL *url = [NSURL URLWithString:[self.urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //创建新的item
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    //监听item状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.player replaceCurrentItemWithPlayerItem:playerItem];
        //添加播放完成通知
        [self addPlayerItemNotification];
    });
    //No.2
    //开始写代码，将媒体信息显示在锁定屏幕上，并使锁屏上控件可以控制音频播放
    
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    
    //end_code
}

#pragma mark - KVO 监听item状态方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
        //只执行一次
        if (status == AVPlayerStatusReadyToPlay) {
            [self setTimeLabel];
            // 开始自动播放
            _playButton.enabled = YES;
            _slider.enabled = YES;
//            [self playButtonClick:_playButton];
        }
    }
}

#pragma mark - 添加播放完成通知
- (void)addPlayerItemNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

#pragma mark - 播放完成通知方法
-(void)playFinished:(NSNotification *)noti {
    _playEnded = YES;
    [self pause];
    if (_playButton.selected) {
        _playButton.selected = NO;
    }
}

#pragma mark -  当用setter方法赋值视频地址时  播放暂停，重制播放器状态
- (void)resetPlayer {
    _playEnded = NO;
    [self pause];
    if (_playButton.selected) {
        _playButton.selected = NO;
    }
}

#pragma mark - 播放键 点击播放动作
- (void)playButtonClick:(UIButton *)sender {
    //rate 暂停／播放
    if (self.player.rate == 0) {
        sender.selected = YES;
        [self play];
    } else if (self.player.rate == 1) {
        sender.selected = NO;
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
    _playButton.selected = YES;
}

#pragma mark - 暂停
- (void)pause {
    [self.player pause];
    _playButton.selected = NO;
}

#pragma mark - Slider点击/滑动动作
- (void)sliderPlay:(UISlider *)sender {
    NSTimeInterval slideTime = CMTimeGetSeconds(self.player.currentItem.duration) * _slider.value;
    if (slideTime == CMTimeGetSeconds(self.player.currentItem.duration)) {
        slideTime -= 0.5;
    }
    [self.player seekToTime:CMTimeMakeWithSeconds(slideTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];

    [self play];
}

- (void)sliderPause:(UISlider *)sender {
    [self pause];
}

- (void)sliderValueChanged:(UISlider *)sender {
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * _slider.value;
    NSInteger currentMin = currentTime / 60;
    NSInteger currentSec = (NSInteger)currentTime % 60;
    _currentTime.text = [NSString stringWithFormat:@"%02td:%02td",currentMin,currentSec];
}

#pragma mark - TimeLabel动态赋值
- (void)setTimeLabel {
    NSTimeInterval totalTime = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    // 切换视频源时totalTime/currentTime的值会出现nan导致时间错乱
    if (!(totalTime>=0)||!(currentTime>=0)) {
        totalTime = 0;
        currentTime = 0;
    }
    NSInteger totalMin = totalTime / 60;
    NSInteger totalSec = (NSInteger)totalTime % 60;
    _totalTime.text = [NSString stringWithFormat:@"%02td:%02td",totalMin,totalSec];
    NSInteger currentMin = currentTime / 60;
    NSInteger currentSec = (NSInteger)currentTime % 60;
    _currentTime.text = [NSString stringWithFormat:@"%02td:%02td",currentMin,currentSec];
}

#pragma mark - 移除item观察者/移除播放完成通知
- (void)playerItemRemoveObserver {
    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

#pragma mark -  销毁时做的操作，如移除通知
- (void)dealloc {
    [self playerItemRemoveObserver];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    //移除时间观察者
    [self.player removeTimeObserver:self.timeObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - setter 视频地址赋值
- (void)setUrlString:(NSString *)urlString {
    if ([XRZValidateString(_urlString) isEqualToString:urlString]) {
        return;
    }
    _urlString = urlString;
    [self preparePLay];
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
    [_slider addTarget:self action:@selector(sliderPause:) forControlEvents:UIControlEventTouchDown];
    [_slider addTarget:self action:@selector(sliderPlay:) forControlEvents:UIControlEventTouchUpInside];
    [_slider addTarget:self action:@selector(sliderPlay:) forControlEvents:UIControlEventTouchUpOutside];
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

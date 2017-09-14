//
//  KSSlider.m
//  PowerWord7
//
//  Created by xiaruzhen on 2017/9/8.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

#import "KSSlider.h"
#import "UIButton+KSEnlargeEdge.h"
@interface KSSlider() {
    CGFloat currentX;
    CGPoint clickCenter;
    NSString *type;
}
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (strong, nonatomic) UIProgressView *progressView;


/**
 *  slider覆盖颜色
 */
@property(nonatomic,strong)UIView *minimumTrackView;

/**
 *  slier背景
 */
@property(nonatomic,strong)UIView *maximumTrackView;

/**
 *  滑块
 */
@property(nonatomic,strong)UIButton *sliderBtn;
/**
 *  模糊点击区域按钮
 */
@property(nonatomic,strong)UIButton *expandBtn;

@end

static const CGFloat sliderBlockDefaultSize = 10;
static const CGFloat trackProgressDefaultH = 2;

@implementation KSSlider

+ (instancetype) sliderWithProgressHeight:(CGFloat)progressHeight blockSize:(CGFloat)size {
    KSSlider *slider = [[KSSlider alloc] init];
    slider.trackProgressHeight = progressHeight;
    slider.sliderBlocksize = size;
    return slider;
}

- (id)init {
    self = [super init];
    if (!self) return nil;
    [self configureSubViews];
    return self;
}

- (void)configureSubViews {
    self.backgroundColor = [UIColor purpleColor];
    _maximumTrackView = [[UIView alloc]init];
    _maximumTrackView.layer.cornerRadius = trackProgressDefaultH/2.0;
    _maximumTrackView.layer.masksToBounds = YES;
    _maximumTrackView.backgroundColor = [UIColor grayColor];
    _maximumTrackView.clipsToBounds = YES;
    [self addSubview:_maximumTrackView];
    
    _minimumTrackView = [[UIView alloc]init];
    _minimumTrackView.layer.cornerRadius = trackProgressDefaultH/2.0;
    _minimumTrackView.layer.masksToBounds = YES;
    _minimumTrackView.clipsToBounds = YES;
    _minimumTrackView.backgroundColor = [UIColor blueColor];
    [_maximumTrackView addSubview:_minimumTrackView];
    
    _sliderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _sliderBtn.backgroundColor = [UIColor lightGrayColor];
    if (_thumbImage == nil) {
        _sliderBtn.layer.borderWidth = 0.5;
        _sliderBtn.layer.borderColor = [UIColor grayColor].CGColor;
        _sliderBtn.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        [_sliderBtn setImage:_thumbImage forState:UIControlStateNormal];
    }
    _sliderBtn.userInteractionEnabled = YES;
    _sliderBtn.layer.cornerRadius = sliderBlockDefaultSize / 2;
    
    [_sliderBtn addTarget:self action:@selector(dragMoving:withEvent:)forControlEvents: UIControlEventTouchDragInside];
    [self addSubview:_sliderBtn];
    
    _expandBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _expandBtn.center = _sliderBtn.center;
    [_expandBtn addTarget:self action:@selector(dragMoving:withEvent:)forControlEvents: UIControlEventTouchDragInside];
//    [self addSubview:_expandBtn];
    
    _activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [_sliderBtn addSubview:_activityView];
    
    
    _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
    [_progressView setProgressTintColor:[UIColor redColor]];
    [_progressView setTrackTintColor:[UIColor blackColor]];//未填充部分的颜色
    _progressView.progress = 0.8;
    [_maximumTrackView addSubview:self.progressView];
    [_maximumTrackView sendSubviewToBack:_progressView];
    
    
    [_maximumTrackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-sliderBlockDefaultSize/2.0);
        make.left.equalTo(self).offset(sliderBlockDefaultSize/2.0);
        make.center.equalTo(self);
        make.height.mas_equalTo(trackProgressDefaultH);
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_maximumTrackView);
    }];
    
    [_minimumTrackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.bottom.equalTo(_maximumTrackView);
        make.width.equalTo(_maximumTrackView.mas_width).multipliedBy(0.5);
    }];
    
    [_sliderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_minimumTrackView);
        make.width.and.height.mas_equalTo(sliderBlockDefaultSize);
        make.left.equalTo(_minimumTrackView.mas_right).offset(-sliderBlockDefaultSize / 2);
    }];
//    [_sliderBtn be_setEnlargeEdge:10];

//    [_expandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(_minimumTrackView);
//        make.left.equalTo(_minimumTrackView).offset(-sliderBlockDefaultSize);
//        make.width.and.height.mas_equalTo(sliderBlockDefaultSize * 2);
//    }];
    
    [self.activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(sliderBlockDefaultSize/2.0);
        make.centerY.centerX.equalTo(_sliderBtn);
    }];
    
    CGAffineTransform transform = CGAffineTransformMakeScale(.4f, .4f);
    _activityView.transform = transform;
}


- (void)updateConstraints {
    if ([type isEqualToString:@"nottap"]) { //通过setter方法设置值
        [_maximumTrackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-_sliderBlocksize/2.0);
            make.left.equalTo(self).offset(_sliderBlocksize/2.0);
            make.center.equalTo(self);
            make.height.mas_equalTo(_trackProgressHeight);
        }];
        
        [_minimumTrackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.bottom.equalTo(_maximumTrackView);
            make.width.equalTo(_maximumTrackView.mas_width).multipliedBy(_value);
        }];
        
        [_sliderBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_minimumTrackView);
            make.width.and.height.mas_equalTo(_sliderBlocksize);
            make.left.equalTo(_minimumTrackView.mas_right).offset(-_sliderBlocksize / 2);
        }];
        [_sliderBtn be_setEnlargeEdge:10];


//        [_expandBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_minimumTrackView);
//            make.width.height.mas_equalTo(_sliderBlocksize * 2);
//            make.left.equalTo(_minimumTrackView.mas_right).offset(-_sliderBlocksize);
//        }];
        
        [_activityView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(_sliderBlocksize/2.0);
            make.centerY.centerX.equalTo(_sliderBtn);
        }];
        
        [_progressView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_maximumTrackView);
        }];
        
        CGAffineTransform transform = CGAffineTransformMakeScale(.4f, .4f);
        _activityView.transform = transform;
        [super updateConstraints];
    }
    if ([type isEqualToString:@"tap"]) { //通过button滑动
        [_minimumTrackView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.and.top.and.bottom.equalTo(_maximumTrackView);
            make.width.mas_equalTo(currentX);
        }];
        
        [_sliderBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_minimumTrackView);
            make.width.and.height.mas_equalTo(_sliderBlocksize);
            make.left.mas_equalTo(currentX - _sliderBlocksize / 2);
        }];
        
        [_sliderBtn be_setEnlargeEdge:10];

        
//        [_expandBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_minimumTrackView);
//            make.width.and.height.mas_equalTo(_sliderBlocksize * 2);
//            make.left.mas_equalTo(currentX - _sliderBlocksize * 2 / 2);
//        }];
    }
    [super updateConstraints];
}

- (void)dragMoving:(UIButton *)btn withEvent:(UIEvent *)event {
    CGPoint point = [[[event allTouches] anyObject] locationInView:self];
    CGFloat x = point.x;
    if(x <= _sliderBlocksize / 2) {
        point.x = _sliderBlocksize / 2;
    }
    
    if(x >= self.bounds.size.width - _sliderBlocksize / 2) {
        point.x = self.bounds.size.width - _sliderBlocksize / 2;
    }
    
    point.y = self.frame.size.height / 2;
    currentX = point.x;
    type = @"tap";
    // 告诉self.view约束需要更新
    [self setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
    CGFloat value = (currentX - _sliderBlocksize/2.0) / ((self.bounds.size.width) - _sliderBlocksize);
}

- (void)setValue:(CGFloat)value {
    _value = value;
    type = @"nottap";
    // 告诉self.view约束需要更新
    [self setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (void)setTrackProgressHeight:(CGFloat)trackProgressHeight {
    _trackProgressHeight = trackProgressHeight;
    if (_trackProgressHeight >= 2 && _trackProgressHeight <= 20) {
        type = @"nottap";
        // 告诉self约束需要更新
        [self setNeedsUpdateConstraints];
        // 调用此方法告诉self检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
        [self updateConstraintsIfNeeded];
        [self layoutIfNeeded];
    }
}

- (void)setSliderBlocksize:(CGFloat)sliderBlocksize {
    _sliderBlocksize = sliderBlocksize;
    type = @"nottap";
    _sliderBtn.layer.cornerRadius = _sliderBlocksize / 2;
    // 告诉self约束需要更新
    [self setNeedsUpdateConstraints];
    // 调用此方法告诉self检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

#pragma mark  滑块里的缓冲动画
- (void)startAnimating {
    if (_activityView) {
        [_activityView startAnimating];
    }
}

- (void)stopAnimating {
    if (_activityView) {
        [_activityView stopAnimating];
    }
}

#pragma mark  setter方法 设置实例变量
- (void)setThumbImage:(UIImage *)thumbImage {
    _thumbImage = thumbImage;
    [_sliderBtn setImage:_thumbImage forState:UIControlStateNormal];
}

- (void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
    _maximumTrackTintColor = maximumTrackTintColor;
    _maximumTrackView.backgroundColor = _maximumTrackTintColor;
}

- (void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
    _minimumTrackTintColor = minimumTrackTintColor;
    _minimumTrackView.backgroundColor = _minimumTrackTintColor;
}

- (void)setSliderBlockColor:(UIColor *)sliderBlockColor {
    _sliderBlockColor = sliderBlockColor;
    _sliderBtn.backgroundColor = _sliderBlockColor;
}

@end
